-- Enforce controlled reason-code catalogs for reject/cancel flows.
-- Reason values are now stored as predefined codes from app constants.

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
  v_reason         text;
BEGIN
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  v_reason := nullif(trim(p_reason), '');

  IF v_reason IS NULL THEN
    RAISE EXCEPTION 'Reason code is required';
  END IF;

  IF v_reason NOT IN (
    'not_available',
    'out_of_area',
    'no_tools',
    'requires_more_experience'
  ) THEN
    RAISE EXCEPTION 'Invalid reason code for tasker_reject_booking: %', v_reason;
  END IF;

  INSERT INTO booking_messages (
    booking_id,
    sender_id,
    message_type,
    card_type,
    card_payload,
    card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'rejection_notice',
    jsonb_build_object('reason', v_reason),
    'locked'
  );

  UPDATE bookings
  SET status        = 'rejected',
      status_source = 'tasker',
      status_reason = v_reason,
      rejected_at   = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
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
  v_reason    text;
BEGIN
  SELECT client_id INTO v_client_id
  FROM bookings
  WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  v_reason := nullif(trim(p_reason), '');

  IF v_reason IS NULL THEN
    RAISE EXCEPTION 'Reason code is required';
  END IF;

  IF v_reason NOT IN (
    'too_expensive',
    'schedule_not_convenient',
    'need_more_details',
    'prefer_another_tasker'
  ) THEN
    RAISE EXCEPTION 'Invalid reason code for client_reject_quote: %', v_reason;
  END IF;

  UPDATE booking_messages
  SET card_status = 'locked'
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (
    p_message_id,
    auth.uid(),
    'rejected',
    jsonb_build_object('reason', v_reason)
  );

  INSERT INTO booking_messages (
    booking_id,
    sender_id,
    message_type,
    card_type,
    card_payload,
    card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'rejection_notice',
    jsonb_build_object('reason', v_reason),
    'locked'
  );

  UPDATE bookings
  SET status        = 'rejected',
      status_source = 'client',
      status_reason = v_reason,
      rejected_at   = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
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
  v_reason         text;
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

  v_reason := nullif(trim(p_reason), '');

  IF v_reason IS NULL THEN
    RAISE EXCEPTION 'Reason code is required';
  END IF;

  IF v_source = 'client' AND v_reason NOT IN (
    'plans_changed',
    'issue_resolved',
    'no_longer_available',
    'booked_by_mistake'
  ) THEN
    RAISE EXCEPTION 'Invalid reason code for client cancel_booking: %', v_reason;
  END IF;

  IF v_source = 'tasker' AND v_reason NOT IN (
    'emergency',
    'schedule_conflict',
    'materials_unavailable',
    'outside_service_area'
  ) THEN
    RAISE EXCEPTION 'Invalid reason code for tasker cancel_booking: %', v_reason;
  END IF;

  INSERT INTO booking_messages (
    booking_id,
    sender_id,
    message_type,
    card_type,
    card_payload,
    card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'rejection_notice',
    jsonb_build_object('reason', v_reason, 'action', 'cancelled'),
    'locked'
  );

  UPDATE bookings
  SET status        = 'cancelled',
      status_source = v_source,
      status_reason = v_reason,
      cancelled_at  = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
