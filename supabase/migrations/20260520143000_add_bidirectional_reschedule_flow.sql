-- Bidirectional reschedule flow for booked bookings.
-- Either client or tasker can propose a new date/time.

ALTER TABLE booking_messages
  DROP CONSTRAINT IF EXISTS booking_messages_card_type_check;
ALTER TABLE booking_messages
  ADD CONSTRAINT booking_messages_card_type_check
  CHECK (
    card_type IN (
      'quote',
      'renegotiation',
      'reschedule',
      'request_more_info',
      'rejection_notice',
      'completion_confirmation'
    )
  );
CREATE OR REPLACE FUNCTION enforce_reschedule_window(
  p_booking_id uuid,
  p_scheduled_for timestamptz
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_status text;
BEGIN
  IF p_scheduled_for IS NULL THEN
    RAISE EXCEPTION 'Debes seleccionar fecha y hora';
  END IF;

  SELECT b.status
  INTO v_status
  FROM bookings b
  WHERE b.id = p_booking_id;

  IF v_status IS NULL THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF v_status <> 'booked' THEN
    RAISE EXCEPTION 'Solo se puede reagendar en estado booked';
  END IF;

  IF p_scheduled_for < (now() + interval '1 hour') THEN
    RAISE EXCEPTION 'La nueva fecha debe tener al menos 1 hora de anticipacion';
  END IF;

  IF p_scheduled_for > (now() + interval '7 days') THEN
    RAISE EXCEPTION 'La nueva fecha no puede exceder 1 semana desde hoy';
  END IF;
END;
$$;
CREATE OR REPLACE FUNCTION submit_reschedule_proposal(
  p_booking_id uuid,
  p_new_scheduled_for timestamptz
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
  v_tasker_user_id uuid;
  v_actor_role text;
  v_status text;
  v_current_scheduled timestamptz;
  v_date_changed boolean;
  v_time_changed boolean;
  v_message_id uuid;
BEGIN
  SELECT b.client_id, tp.user_id, b.status, b.scheduled_for
  INTO v_client_id, v_tasker_user_id, v_status, v_current_scheduled
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_client_id IS NULL THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF auth.uid() = v_client_id THEN
    v_actor_role := 'client';
  ELSIF auth.uid() = v_tasker_user_id THEN
    v_actor_role := 'tasker';
  ELSE
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_current_scheduled IS NULL THEN
    RAISE EXCEPTION 'El booking no tiene horario actual';
  END IF;

  PERFORM enforce_reschedule_window(p_booking_id, p_new_scheduled_for);

  IF EXISTS (
    SELECT 1
    FROM booking_messages bm
    WHERE bm.booking_id = p_booking_id
      AND bm.card_type = 'reschedule'
      AND bm.card_status = 'active'
      AND bm.deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Ya existe una propuesta de reagendacion pendiente por responder';
  END IF;

  v_date_changed :=
    (v_current_scheduled AT TIME ZONE 'America/Tegucigalpa')::date
    IS DISTINCT FROM
    (p_new_scheduled_for AT TIME ZONE 'America/Tegucigalpa')::date;

  v_time_changed :=
    to_char(v_current_scheduled AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI')
    IS DISTINCT FROM
    to_char(p_new_scheduled_for AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI');

  IF NOT (v_date_changed OR v_time_changed) THEN
    RAISE EXCEPTION 'Debes seleccionar una fecha u hora distinta';
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
    'reschedule',
    jsonb_build_object(
      'proposed_scheduled_for', p_new_scheduled_for,
      'previous_scheduled_for', v_current_scheduled,
      'changed_by', v_actor_role,
      'proposal_status', 'pending',
      'field_changes', jsonb_build_object(
        'date_changed', v_date_changed,
        'time_changed', v_time_changed
      )
    ),
    'active'
  )
  RETURNING id INTO v_message_id;

  RETURN v_message_id;
END;
$$;
CREATE OR REPLACE FUNCTION accept_reschedule_proposal(
  p_booking_id uuid,
  p_message_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
  v_tasker_user_id uuid;
  v_status text;
  v_source_message booking_messages%ROWTYPE;
  v_new_scheduled_for timestamptz;
BEGIN
  SELECT b.client_id, tp.user_id, b.status
  INTO v_client_id, v_tasker_user_id, v_status
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_client_id IS NULL THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF auth.uid() IS DISTINCT FROM v_client_id
     AND auth.uid() IS DISTINCT FROM v_tasker_user_id THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_status <> 'booked' THEN
    RAISE EXCEPTION 'Solo se puede reagendar en estado booked';
  END IF;

  SELECT bm.*
  INTO v_source_message
  FROM booking_messages bm
  WHERE bm.id = p_message_id
    AND bm.booking_id = p_booking_id
    AND bm.card_type = 'reschedule'
    AND bm.card_status = 'active'
    AND bm.deleted_at IS NULL
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No hay propuesta activa para reagendar';
  END IF;

  IF v_source_message.sender_id = auth.uid() THEN
    RAISE EXCEPTION 'No puedes aceptar tu propia propuesta activa';
  END IF;

  v_new_scheduled_for := nullif(v_source_message.card_payload->>'proposed_scheduled_for', '')::timestamptz;

  IF v_new_scheduled_for IS NULL THEN
    RAISE EXCEPTION 'La propuesta no tiene horario valido';
  END IF;

  UPDATE booking_messages
  SET card_status = 'resolved',
      card_payload = COALESCE(card_payload, '{}'::jsonb)
        || jsonb_build_object('proposal_status', 'accepted')
  WHERE id = p_message_id;

  UPDATE booking_messages
  SET card_status = 'locked'
  WHERE booking_id = p_booking_id
    AND id <> p_message_id
    AND card_type = 'reschedule'
    AND card_status = 'active';

  INSERT INTO booking_message_actions (message_id, actor_id, action)
  VALUES (p_message_id, auth.uid(), 'accepted');

  UPDATE bookings
  SET scheduled_for = v_new_scheduled_for,
      updated_at = now()
  WHERE id = p_booking_id;

  INSERT INTO booking_messages (
    booking_id,
    sender_id,
    message_type,
    body,
    card_status
  ) VALUES (
    p_booking_id,
    auth.uid(),
    'system',
    'Servicio Reagendado',
    'locked'
  );
END;
$$;
CREATE OR REPLACE FUNCTION reject_reschedule_proposal(
  p_booking_id uuid,
  p_message_id uuid,
  p_reason text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id uuid;
  v_tasker_user_id uuid;
  v_status text;
  v_reason text;
BEGIN
  SELECT b.client_id, tp.user_id, b.status
  INTO v_client_id, v_tasker_user_id, v_status
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_client_id IS NULL THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF auth.uid() IS DISTINCT FROM v_client_id
     AND auth.uid() IS DISTINCT FROM v_tasker_user_id THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_status <> 'booked' THEN
    RAISE EXCEPTION 'Solo se puede reagendar en estado booked';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM booking_messages bm
    WHERE bm.id = p_message_id
      AND bm.sender_id = auth.uid()
      AND bm.booking_id = p_booking_id
      AND bm.card_type = 'reschedule'
      AND bm.card_status = 'active'
      AND bm.deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'No puedes rechazar tu propia propuesta activa';
  END IF;

  UPDATE booking_messages
  SET card_status = 'locked',
      card_payload = COALESCE(card_payload, '{}'::jsonb)
        || jsonb_build_object('proposal_status', 'rejected')
  WHERE id = p_message_id
    AND booking_id = p_booking_id
    AND card_type = 'reschedule'
    AND card_status = 'active'
    AND deleted_at IS NULL;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No hay propuesta activa para rechazar';
  END IF;

  v_reason := nullif(trim(p_reason), '');

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (
    p_message_id,
    auth.uid(),
    'rejected',
    CASE
      WHEN v_reason IS NULL THEN NULL
      ELSE jsonb_build_object('reason', v_reason)
    END
  );
END;
$$;
