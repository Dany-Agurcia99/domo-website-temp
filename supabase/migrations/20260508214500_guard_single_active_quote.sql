-- Prevent tasker from sending multiple pending quote cards for the same booking

CREATE OR REPLACE FUNCTION tasker_send_quote(
  p_booking_id           uuid,
  p_amount               numeric,
  p_estimated_minutes    int,
  p_scheduled_for_override timestamptz DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_message_id     uuid;
  v_has_active_quote boolean;
BEGIN
  -- Verify caller is the tasker and lock booking row to avoid race conditions.
  SELECT tp.user_id INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM booking_messages bm
    WHERE bm.booking_id = p_booking_id
      AND bm.card_type = 'quote'
      AND bm.card_status = 'active'
      AND bm.deleted_at IS NULL
  )
  INTO v_has_active_quote;

  IF v_has_active_quote THEN
    RAISE EXCEPTION 'Ya existe una cotizacion pendiente por responder';
  END IF;

  INSERT INTO booking_messages (
    booking_id, sender_id, message_type, card_type, card_payload, card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'interactive_card',
    'quote',
    jsonb_build_object(
      'amount', p_amount,
      'estimated_minutes', p_estimated_minutes,
      'scheduled_for', COALESCE(
        p_scheduled_for_override,
        (SELECT scheduled_for FROM bookings WHERE id = p_booking_id)
      )
    ),
    'active'
  )
  RETURNING id INTO v_message_id;

  IF p_scheduled_for_override IS NOT NULL THEN
    UPDATE bookings
    SET scheduled_for = p_scheduled_for_override,
        quoted_price = p_amount,
        updated_at = now()
    WHERE id = p_booking_id;
  ELSE
    UPDATE bookings
    SET quoted_price = p_amount,
        updated_at = now()
    WHERE id = p_booking_id;
  END IF;

  RETURN v_message_id;
END;
$$;
