-- Ensure client_reject_quote always inserts a rejection_notice card
-- so both sides can render the rejection interactive card.

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

  UPDATE booking_messages
  SET card_status = 'locked'
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (p_message_id, auth.uid(), 'rejected', jsonb_build_object('reason', p_reason));

  -- Persist rejection notice card so tasker/client chats can render it consistently.
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

  UPDATE bookings
  SET status        = 'rejected',
      status_source = 'client',
      status_reason = p_reason,
      rejected_at   = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
