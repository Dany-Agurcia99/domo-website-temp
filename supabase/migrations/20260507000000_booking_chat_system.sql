-- ============================================================
-- BOOKING CHAT SYSTEM MIGRATION
-- New statuses, interactive message cards, RPCs, RLS, Realtime
-- ============================================================

-- ----------------------------------------------------------
-- 1. Update bookings.status CHECK constraint
-- ----------------------------------------------------------
ALTER TABLE bookings
  DROP CONSTRAINT IF EXISTS bookings_status_check;
-- Migrate existing rows to new status values BEFORE adding new constraint
UPDATE bookings SET status = 'requested'  WHERE status = 'pending';
UPDATE bookings SET status = 'booked'     WHERE status IN ('accepted','awaiting_payment','paid');
UPDATE bookings SET status = 'cancelled'  WHERE status = 'disputed';
ALTER TABLE bookings
  ADD CONSTRAINT bookings_status_check
  CHECK (status IN ('requested','booked','in_progress','completed','rejected','cancelled'));
-- ----------------------------------------------------------
-- 2. Add status_source and status_reason to bookings
-- ----------------------------------------------------------
ALTER TABLE bookings
  ADD COLUMN IF NOT EXISTS status_source text
    CHECK (status_source IN ('tasker','client','system')),
  ADD COLUMN IF NOT EXISTS status_reason text;
-- ----------------------------------------------------------
-- 3. booking_messages table
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS booking_messages (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id      uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  sender_id       uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  message_type    text NOT NULL CHECK (message_type IN ('text','interactive_card','system')),
  body            text,
  card_type       text CHECK (card_type IN (
                    'quote',
                    'renegotiation',
                    'request_more_info',
                    'rejection_notice',
                    'completion_confirmation'
                  )),
  card_payload    jsonb,
  card_status     text NOT NULL DEFAULT 'active'
                    CHECK (card_status IN ('active','resolved','locked')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  deleted_at      timestamptz,
  CONSTRAINT interactive_card_requires_card_type
    CHECK (message_type != 'interactive_card' OR card_type IS NOT NULL),
  CONSTRAINT text_requires_body
    CHECK (message_type != 'text' OR body IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS idx_booking_messages_booking_created
  ON booking_messages (booking_id, created_at);
CREATE INDEX IF NOT EXISTS idx_booking_messages_sender
  ON booking_messages (sender_id);
-- ----------------------------------------------------------
-- 4. booking_message_actions table
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS booking_message_actions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id  uuid NOT NULL REFERENCES booking_messages(id) ON DELETE CASCADE,
  actor_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  action      text NOT NULL,
  metadata    jsonb,
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_bma_message_id
  ON booking_message_actions (message_id);
-- ----------------------------------------------------------
-- 5. booking_message_reads table
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS booking_message_reads (
  booking_id   uuid NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  last_read_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (booking_id, user_id)
);
-- ----------------------------------------------------------
-- 6. RLS policies
-- ----------------------------------------------------------
ALTER TABLE booking_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_message_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_message_reads ENABLE ROW LEVEL SECURITY;
-- Helper: check if current user is a participant in a booking
CREATE OR REPLACE FUNCTION is_booking_participant(p_booking_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM bookings b
    JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
    WHERE b.id = p_booking_id
      AND (b.client_id = auth.uid() OR tp.user_id = auth.uid())
  );
$$;
-- booking_messages: SELECT
CREATE POLICY "booking_messages_select_participants"
  ON booking_messages FOR SELECT
  USING (is_booking_participant(booking_id) AND deleted_at IS NULL);
-- booking_messages: INSERT (card type — any participant, any status in active flow)
CREATE POLICY "booking_messages_insert_participants"
  ON booking_messages FOR INSERT
  WITH CHECK (
    sender_id = auth.uid()
    AND is_booking_participant(booking_id)
  );
-- booking_message_actions: SELECT
CREATE POLICY "bma_select_participants"
  ON booking_message_actions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM booking_messages bm
      WHERE bm.id = message_id AND is_booking_participant(bm.booking_id)
    )
  );
-- booking_message_actions: INSERT
CREATE POLICY "bma_insert_actor"
  ON booking_message_actions FOR INSERT
  WITH CHECK (actor_id = auth.uid());
-- booking_message_reads: SELECT + UPSERT
CREATE POLICY "bmr_select_self"
  ON booking_message_reads FOR SELECT
  USING (user_id = auth.uid());
CREATE POLICY "bmr_upsert_self"
  ON booking_message_reads FOR INSERT
  WITH CHECK (user_id = auth.uid());
CREATE POLICY "bmr_update_self"
  ON booking_message_reads FOR UPDATE
  USING (user_id = auth.uid());
-- ----------------------------------------------------------
-- 7. Enable Realtime on booking_messages
-- ----------------------------------------------------------
ALTER PUBLICATION supabase_realtime ADD TABLE booking_messages;
-- ----------------------------------------------------------
-- 8. RPCs
-- ----------------------------------------------------------

-- 8a. tasker_send_quote
CREATE OR REPLACE FUNCTION tasker_send_quote(
  p_booking_id           uuid,
  p_amount               numeric,
  p_estimated_minutes    int,
  p_scheduled_for_override timestamptz DEFAULT NULL
)
RETURNS uuid   -- message_id
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_message_id     uuid;
BEGIN
  -- Verify caller is the tasker
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Lock any previously active quote cards for this booking
  UPDATE booking_messages
  SET card_status = 'locked'
  WHERE booking_id = p_booking_id
    AND card_type = 'quote'
    AND card_status = 'active';

  -- Insert quote card
  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'quote',
    jsonb_build_object(
      'amount',              p_amount,
      'estimated_minutes',   p_estimated_minutes,
      'scheduled_for',       COALESCE(p_scheduled_for_override,
                               (SELECT scheduled_for FROM bookings WHERE id = p_booking_id))
    ),
    'active'
  )
  RETURNING id INTO v_message_id;

  -- Update booking scheduled_for if override provided
  IF p_scheduled_for_override IS NOT NULL THEN
    UPDATE bookings
    SET scheduled_for = p_scheduled_for_override,
        quoted_price  = p_amount,
        updated_at    = now()
    WHERE id = p_booking_id;
  ELSE
    UPDATE bookings
    SET quoted_price = p_amount,
        updated_at   = now()
    WHERE id = p_booking_id;
  END IF;

  RETURN v_message_id;
END;
$$;
-- 8b. tasker_reject_booking
CREATE OR REPLACE FUNCTION tasker_reject_booking(
  p_booking_id uuid,
  p_reason     text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
BEGIN
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Insert rejection card
  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'rejection_notice',
    jsonb_build_object('reason', p_reason),
    'locked'
  );

  UPDATE bookings
  SET status        = 'rejected',
      status_source = 'tasker',
      status_reason = p_reason,
      rejected_at   = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- 8c. tasker_request_more_info
CREATE OR REPLACE FUNCTION tasker_request_more_info(
  p_booking_id uuid,
  p_question   text
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_message_id     uuid;
BEGIN
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'request_more_info',
    jsonb_build_object('question', p_question, 'answered', false),
    'active'
  )
  RETURNING id INTO v_message_id;

  RETURN v_message_id;
END;
$$;
-- 8d. client_accept_quote
CREATE OR REPLACE FUNCTION client_accept_quote(
  p_booking_id        uuid,
  p_message_id        uuid,
  p_payment_method_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id  uuid;
  v_amount     numeric;
BEGIN
  SELECT b.client_id, (bm.card_payload->>'amount')::numeric
  INTO v_client_id, v_amount
  FROM bookings b
  JOIN booking_messages bm ON bm.id = p_message_id
  WHERE b.id = p_booking_id AND bm.booking_id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Lock the quote card
  UPDATE booking_messages
  SET card_status = 'resolved'
  WHERE id = p_message_id;

  -- Record action
  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (p_message_id, auth.uid(), 'accepted', jsonb_build_object('payment_method_id', p_payment_method_id));

  -- Create pending booking_payment
  INSERT INTO booking_payments (
    booking_id, amount, currency, payment_method_id, status
  ) VALUES (
    p_booking_id, v_amount, 'HNL', p_payment_method_id, 'pending'
  );

  -- Transition booking to booked
  UPDATE bookings
  SET status        = 'booked',
      status_source = 'client',
      accepted_at   = now(),
      final_price   = v_amount,
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- 8e. client_reject_quote
CREATE OR REPLACE FUNCTION client_reject_quote(
  p_booking_id uuid,
  p_message_id uuid,
  p_reason     text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
BEGIN
  SELECT client_id INTO v_client_id FROM bookings WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  UPDATE booking_messages SET card_status = 'locked' WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (p_message_id, auth.uid(), 'rejected', jsonb_build_object('reason', p_reason));

  UPDATE bookings
  SET status        = 'rejected',
      status_source = 'client',
      status_reason = p_reason,
      rejected_at   = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- 8f. client_renegotiate
CREATE OR REPLACE FUNCTION client_renegotiate(
  p_booking_id      uuid,
  p_message_id      uuid,     -- original quote card being responded to
  p_new_amount      numeric,
  p_new_scheduled_for timestamptz DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id  uuid;
  v_new_msg_id uuid;
BEGIN
  SELECT client_id INTO v_client_id FROM bookings WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Lock the original quote card
  UPDATE booking_messages SET card_status = 'locked' WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (p_message_id, auth.uid(), 'renegotiated', NULL);

  -- Insert a renegotiation card from client side
  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'renegotiation',
    jsonb_build_object(
      'proposed_amount',       p_new_amount,
      'proposed_scheduled_for', p_new_scheduled_for
    ),
    'active'
  )
  RETURNING id INTO v_new_msg_id;

  RETURN v_new_msg_id;
END;
$$;
-- 8g. client_respond_more_info
CREATE OR REPLACE FUNCTION client_respond_more_info(
  p_booking_id   uuid,
  p_message_id   uuid,
  p_response_text text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
BEGIN
  SELECT client_id INTO v_client_id FROM bookings WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  UPDATE booking_messages
  SET card_status  = 'resolved',
      card_payload = card_payload || jsonb_build_object('response', p_response_text, 'answered', true)
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (p_message_id, auth.uid(), 'responded', jsonb_build_object('response', p_response_text));
END;
$$;
-- 8h. tasker_start_job
CREATE OR REPLACE FUNCTION tasker_start_job(p_booking_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_scheduled_for  timestamptz;
BEGIN
  SELECT tp.user_id, b.scheduled_for
  INTO v_tasker_user_id, v_scheduled_for
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Only allow starting if booking date is today (UTC)
  IF DATE(v_scheduled_for AT TIME ZONE 'UTC') != CURRENT_DATE THEN
    RAISE EXCEPTION 'Cannot start job: booking is not scheduled for today';
  END IF;

  -- Insert system message
  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'system', 'El tasker ha comenzado el trabajo');

  UPDATE bookings
  SET status        = 'in_progress',
      status_source = 'tasker',
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- 8i. tasker_request_completion
CREATE OR REPLACE FUNCTION tasker_request_completion(p_booking_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_message_id     uuid;
BEGIN
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'completion_confirmation',
    jsonb_build_object('requested_at', now()),
    'active'
  )
  RETURNING id INTO v_message_id;

  RETURN v_message_id;
END;
$$;
-- 8j. client_confirm_completion
CREATE OR REPLACE FUNCTION client_confirm_completion(
  p_booking_id uuid,
  p_message_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
BEGIN
  SELECT client_id INTO v_client_id FROM bookings WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  UPDATE booking_messages
  SET card_status = 'resolved'
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action)
  VALUES (p_message_id, auth.uid(), 'confirmed_completion');

  -- Insert system message
  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'system', 'El cliente ha confirmado que el trabajo fue completado');

  UPDATE bookings
  SET status        = 'completed',
      status_source = 'client',
      completed_at  = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- 8k. send_text_message
CREATE OR REPLACE FUNCTION send_text_message(
  p_booking_id uuid,
  p_body       text
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_message_id uuid;
  v_status     text;
  v_completed_at timestamptz;
BEGIN
  SELECT status, completed_at INTO v_status, v_completed_at
  FROM bookings WHERE id = p_booking_id;

  -- Gate: only allow text in booked, in_progress, or completed within 3 days
  IF v_status NOT IN ('booked','in_progress')
     AND NOT (v_status = 'completed' AND v_completed_at > now() - INTERVAL '3 days') THEN
    RAISE EXCEPTION 'Text messages not allowed in current booking state';
  END IF;

  IF NOT is_booking_participant(p_booking_id) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'text', p_body)
  RETURNING id INTO v_message_id;

  RETURN v_message_id;
END;
$$;
-- 8l. cancel_booking (client or tasker)
CREATE OR REPLACE FUNCTION cancel_booking(
  p_booking_id uuid,
  p_reason     text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id      uuid;
  v_tasker_user_id uuid;
  v_source         text;
BEGIN
  SELECT b.client_id, tp.user_id
  INTO v_client_id, v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF auth.uid() = v_client_id THEN
    v_source := 'client';
  ELSIF auth.uid() = v_tasker_user_id THEN
    v_source := 'tasker';
  ELSE
    RAISE EXCEPTION 'Not authorized';
  END IF;

  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'system',
          CASE WHEN v_source = 'client' THEN 'El cliente ha cancelado la reservación'
               ELSE 'El tasker ha cancelado la reservación' END);

  UPDATE bookings
  SET status        = 'cancelled',
      status_source = v_source,
      status_reason = p_reason,
      cancelled_at  = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
-- ----------------------------------------------------------
-- 9. booking_chat_previews view
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW booking_chat_previews AS
SELECT
  b.id                  AS booking_id,
  b.client_id,
  tp.user_id            AS tasker_user_id,
  b.status,
  last_msg.id           AS last_message_id,
  last_msg.body         AS last_message_body,
  last_msg.card_type    AS last_message_card_type,
  last_msg.message_type AS last_message_type,
  last_msg.sender_id    AS last_message_sender_id,
  last_msg.created_at   AS last_message_at,
  -- unread count for each role will be computed per user in app layer
  p_client.full_name    AS client_name,
  p_client.avatar_url AS client_picture,
  p_tasker.full_name    AS tasker_name,
  p_tasker.avatar_url AS tasker_picture
FROM bookings b
JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
JOIN profiles p_client ON p_client.id = b.client_id
JOIN profiles p_tasker ON p_tasker.id = tp.user_id
LEFT JOIN LATERAL (
  SELECT id, body, card_type, message_type, sender_id, created_at
  FROM booking_messages
  WHERE booking_id = b.id AND deleted_at IS NULL
  ORDER BY created_at DESC
  LIMIT 1
) last_msg ON true;
