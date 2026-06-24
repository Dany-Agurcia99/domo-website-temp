-- Add strict guards for completion requests and support client rejection flow.

-- tasker_request_completion: allow only in_progress and prevent duplicate active requests
CREATE OR REPLACE FUNCTION tasker_request_completion(p_booking_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_status         text;
  v_message_id     uuid;
BEGIN
  SELECT tp.user_id, b.status
  INTO v_tasker_user_id, v_status
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_status IS DISTINCT FROM 'in_progress' THEN
    RAISE EXCEPTION 'Solo puedes solicitar finalizacion cuando el servicio esta en progreso';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM booking_messages bm
    WHERE bm.booking_id = p_booking_id
      AND bm.card_type = 'completion_confirmation'
      AND bm.card_status = 'active'
      AND bm.deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Ya hay una solicitud en progreso';
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
-- client_reject_completion: reject completion request but keep booking in_progress
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
    'El cliente rechazo la solicitud de finalizacion. El servicio sigue en progreso.'
  );
END;
$$;
