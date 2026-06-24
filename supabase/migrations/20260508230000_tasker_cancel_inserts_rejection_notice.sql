-- When a tasker cancels a booking, persist an interactive rejection_notice card
-- so chat renders a visible cancellation card like rejection.

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
  VALUES (
    p_booking_id,
    auth.uid(),
    'system',
    CASE
      WHEN v_source = 'client' THEN 'El cliente ha cancelado la reservación'
      ELSE 'El tasker ha cancelado la reservación'
    END
  );

  IF v_source = 'tasker' THEN
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
      jsonb_build_object('reason', p_reason),
      'locked'
    );
  END IF;

  UPDATE bookings
  SET status        = 'cancelled',
      status_source = v_source,
      status_reason = p_reason,
      cancelled_at  = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
