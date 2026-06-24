-- Fix: remove "El servicio sigue en progreso." from reject completion system message

CREATE OR REPLACE FUNCTION client_reject_completion(
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
  SELECT client_id INTO v_client_id
  FROM bookings
  WHERE id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  UPDATE booking_messages
  SET card_status = 'locked'
  WHERE id = p_message_id
    AND booking_id = p_booking_id
    AND card_type = 'completion_confirmation';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Completion request not found';
  END IF;

  INSERT INTO booking_message_actions (message_id, actor_id, action)
  VALUES (p_message_id, auth.uid(), 'rejected_completion');

  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (
    p_booking_id,
    auth.uid(),
    'system',
    'El cliente rechazó la solicitud de finalización.'
  );
END;
$$;
