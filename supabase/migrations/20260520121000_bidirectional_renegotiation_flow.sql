-- Bidirectional renegotiation flow for quote, date and time.
-- Keeps booking schedule pending until quote acceptance by client payment.

CREATE OR REPLACE FUNCTION enforce_booking_schedule_window(
  p_booking_id uuid,
  p_scheduled_for timestamptz
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_booking_created_at timestamptz;
BEGIN
  IF p_scheduled_for IS NULL THEN
    RAISE EXCEPTION 'Debes seleccionar fecha y hora';
  END IF;

  SELECT b.created_at
  INTO v_booking_created_at
  FROM bookings b
  WHERE b.id = p_booking_id;

  IF v_booking_created_at IS NULL THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF p_scheduled_for < v_booking_created_at THEN
    RAISE EXCEPTION 'La fecha/hora no puede ser anterior a la creacion de la solicitud';
  END IF;

  IF p_scheduled_for > (v_booking_created_at + interval '14 days') THEN
    RAISE EXCEPTION 'La fecha/hora no puede exceder 2 semanas desde la creacion de la solicitud';
  END IF;

  IF p_scheduled_for < (now() + interval '2 hours') THEN
    RAISE EXCEPTION 'La propuesta debe tener al menos 2 horas de anticipacion';
  END IF;
END;
$$;
CREATE OR REPLACE FUNCTION tasker_send_quote(
  p_booking_id             uuid,
  p_amount                 numeric,
  p_estimated_minutes      int,
  p_scheduled_for_override timestamptz DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id        uuid;
  v_message_id            uuid;
  v_booking_scheduled_for timestamptz;
  v_previous_amount       numeric;
  v_proposed_scheduled    timestamptz;
  v_price_changed         boolean;
  v_date_changed          boolean;
  v_time_changed          boolean;
BEGIN
  SELECT tp.user_id, b.scheduled_for, b.quoted_price
  INTO v_tasker_user_id, v_booking_scheduled_for, v_previous_amount
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF p_amount IS NULL OR p_amount <= 0 THEN
    RAISE EXCEPTION 'El monto debe ser mayor que cero';
  END IF;

  v_proposed_scheduled := COALESCE(p_scheduled_for_override, v_booking_scheduled_for);

  PERFORM enforce_booking_schedule_window(p_booking_id, v_proposed_scheduled);

  IF EXISTS (
    SELECT 1
    FROM booking_messages bm
    WHERE bm.booking_id = p_booking_id
      AND bm.card_type IN ('quote', 'renegotiation')
      AND bm.card_status = 'active'
      AND bm.deleted_at IS NULL
  ) THEN
    RAISE EXCEPTION 'Ya existe una propuesta pendiente por responder';
  END IF;

  v_price_changed :=
    v_previous_amount IS NOT NULL
    AND round(v_previous_amount, 2) IS DISTINCT FROM round(p_amount, 2);

  v_date_changed :=
    (v_booking_scheduled_for AT TIME ZONE 'America/Tegucigalpa')::date
    IS DISTINCT FROM
    (v_proposed_scheduled AT TIME ZONE 'America/Tegucigalpa')::date;

  v_time_changed :=
    to_char(v_booking_scheduled_for AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI')
    IS DISTINCT FROM
    to_char(v_proposed_scheduled AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI');

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
    'quote',
    jsonb_build_object(
      'amount', p_amount,
      'estimated_minutes', p_estimated_minutes,
      'scheduled_for', v_proposed_scheduled,
      'previous_amount', v_previous_amount,
      'previous_scheduled_for', v_booking_scheduled_for,
      'changed_by', 'tasker',
      'proposal_status', 'pending',
      'field_changes', jsonb_build_object(
        'price_changed', v_price_changed,
        'date_changed', v_date_changed,
        'time_changed', v_time_changed
      )
    ),
    'active'
  )
  RETURNING id INTO v_message_id;

  UPDATE bookings
  SET quoted_price = p_amount,
      updated_at = now()
  WHERE id = p_booking_id;

  RETURN v_message_id;
END;
$$;
CREATE OR REPLACE FUNCTION submit_renegotiation_proposal(
  p_booking_id       uuid,
  p_message_id       uuid,
  p_new_amount       numeric,
  p_new_scheduled_for timestamptz DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id            uuid;
  v_tasker_user_id       uuid;
  v_actor_role           text;
  v_source_message       booking_messages%ROWTYPE;
  v_booking_scheduled_for timestamptz;
  v_current_amount       numeric;
  v_current_scheduled    timestamptz;
  v_current_estimated    int;
  v_proposed_amount      numeric;
  v_proposed_scheduled   timestamptz;
  v_price_changed        boolean;
  v_date_changed         boolean;
  v_time_changed         boolean;
  v_new_message_id       uuid;
BEGIN
  SELECT b.client_id, tp.user_id, b.scheduled_for
  INTO v_client_id, v_tasker_user_id, v_booking_scheduled_for
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF auth.uid() = v_client_id THEN
    v_actor_role := 'client';
  ELSIF auth.uid() = v_tasker_user_id THEN
    v_actor_role := 'tasker';
  ELSE
    RAISE EXCEPTION 'Not authorized';
  END IF;

  SELECT bm.*
  INTO v_source_message
  FROM booking_messages bm
  WHERE bm.id = p_message_id
    AND bm.booking_id = p_booking_id
    AND bm.card_type IN ('quote', 'renegotiation')
    AND bm.card_status = 'active'
    AND bm.deleted_at IS NULL
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No hay propuesta activa para renegociar';
  END IF;

  IF v_source_message.sender_id = auth.uid() THEN
    RAISE EXCEPTION 'No puedes renegociar tu propia propuesta activa';
  END IF;

  IF v_source_message.card_type = 'quote' THEN
    v_current_amount := COALESCE((v_source_message.card_payload->>'amount')::numeric, 0);
    v_current_scheduled := COALESCE(
      nullif(v_source_message.card_payload->>'scheduled_for', '')::timestamptz,
      v_booking_scheduled_for
    );
    v_current_estimated := COALESCE((v_source_message.card_payload->>'estimated_minutes')::int, 60);
  ELSE
    v_current_amount := COALESCE((v_source_message.card_payload->>'proposed_amount')::numeric, 0);
    v_current_scheduled := COALESCE(
      nullif(v_source_message.card_payload->>'proposed_scheduled_for', '')::timestamptz,
      v_booking_scheduled_for
    );
    v_current_estimated := COALESCE((v_source_message.card_payload->>'estimated_minutes')::int, 60);
  END IF;

  v_proposed_amount := p_new_amount;
  v_proposed_scheduled := COALESCE(p_new_scheduled_for, v_current_scheduled);

  IF v_proposed_amount IS NULL OR v_proposed_amount <= 0 THEN
    RAISE EXCEPTION 'El monto propuesto debe ser mayor que cero';
  END IF;

  PERFORM enforce_booking_schedule_window(p_booking_id, v_proposed_scheduled);

  v_price_changed := round(v_current_amount, 2) IS DISTINCT FROM round(v_proposed_amount, 2);

  v_date_changed :=
    (v_current_scheduled AT TIME ZONE 'America/Tegucigalpa')::date
    IS DISTINCT FROM
    (v_proposed_scheduled AT TIME ZONE 'America/Tegucigalpa')::date;

  v_time_changed :=
    to_char(v_current_scheduled AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI')
    IS DISTINCT FROM
    to_char(v_proposed_scheduled AT TIME ZONE 'America/Tegucigalpa', 'HH24:MI');

  IF NOT (v_price_changed OR v_date_changed OR v_time_changed) THEN
    RAISE EXCEPTION 'Debes cambiar al menos precio, fecha u hora';
  END IF;

  UPDATE booking_messages
  SET card_status = 'locked',
      card_payload = COALESCE(card_payload, '{}'::jsonb) || jsonb_build_object('proposal_status', 'countered')
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (
    p_message_id,
    auth.uid(),
    'countered',
    jsonb_build_object(
      'changed_by', v_actor_role,
      'price_changed', v_price_changed,
      'date_changed', v_date_changed,
      'time_changed', v_time_changed
    )
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
    'renegotiation',
    jsonb_build_object(
      'proposed_amount', v_proposed_amount,
      'proposed_scheduled_for', v_proposed_scheduled,
      'previous_amount', v_current_amount,
      'previous_scheduled_for', v_current_scheduled,
      'estimated_minutes', v_current_estimated,
      'changed_by', v_actor_role,
      'proposal_status', 'pending',
      'field_changes', jsonb_build_object(
        'price_changed', v_price_changed,
        'date_changed', v_date_changed,
        'time_changed', v_time_changed
      )
    ),
    'active'
  )
  RETURNING id INTO v_new_message_id;

  RETURN v_new_message_id;
END;
$$;
CREATE OR REPLACE FUNCTION client_renegotiate(
  p_booking_id        uuid,
  p_message_id        uuid,
  p_new_amount        numeric,
  p_new_scheduled_for timestamptz DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN submit_renegotiation_proposal(
    p_booking_id,
    p_message_id,
    p_new_amount,
    p_new_scheduled_for
  );
END;
$$;
CREATE OR REPLACE FUNCTION tasker_accept_renegotiation(
  p_booking_id uuid,
  p_message_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id        uuid;
  v_source_message        booking_messages%ROWTYPE;
  v_proposed_amount       numeric;
  v_proposed_scheduled    timestamptz;
  v_estimated_minutes     int;
  v_previous_amount       numeric;
  v_previous_scheduled    timestamptz;
  v_changed_by            text;
  v_field_changes         jsonb;
  v_quote_message_id      uuid;
BEGIN
  SELECT tp.user_id
  INTO v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  SELECT bm.*
  INTO v_source_message
  FROM booking_messages bm
  WHERE bm.id = p_message_id
    AND bm.booking_id = p_booking_id
    AND bm.card_type = 'renegotiation'
    AND bm.card_status = 'active'
    AND bm.deleted_at IS NULL
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No hay propuesta activa para aceptar';
  END IF;

  IF v_source_message.sender_id = auth.uid() THEN
    RAISE EXCEPTION 'No puedes aceptar tu propia propuesta activa';
  END IF;

  v_proposed_amount := COALESCE((v_source_message.card_payload->>'proposed_amount')::numeric, 0);
  v_proposed_scheduled := nullif(v_source_message.card_payload->>'proposed_scheduled_for', '')::timestamptz;
  v_estimated_minutes := COALESCE((v_source_message.card_payload->>'estimated_minutes')::int, 60);
  v_previous_amount := (v_source_message.card_payload->>'previous_amount')::numeric;
  v_previous_scheduled := nullif(v_source_message.card_payload->>'previous_scheduled_for', '')::timestamptz;
  v_changed_by := COALESCE(v_source_message.card_payload->>'changed_by', 'client');
  v_field_changes := COALESCE(v_source_message.card_payload->'field_changes', '{}'::jsonb);

  UPDATE booking_messages
  SET card_status = 'resolved',
      card_payload = COALESCE(card_payload, '{}'::jsonb) || jsonb_build_object('proposal_status', 'accepted')
  WHERE id = p_message_id;

  INSERT INTO booking_message_actions (message_id, actor_id, action)
  VALUES (p_message_id, auth.uid(), 'accepted');

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
    'quote',
    jsonb_build_object(
      'amount', v_proposed_amount,
      'estimated_minutes', v_estimated_minutes,
      'scheduled_for', v_proposed_scheduled,
      'previous_amount', v_previous_amount,
      'previous_scheduled_for', v_previous_scheduled,
      'changed_by', v_changed_by,
      'proposal_status', 'pending',
      'field_changes', v_field_changes
    ),
    'active'
  )
  RETURNING id INTO v_quote_message_id;

  UPDATE bookings
  SET quoted_price = v_proposed_amount,
      updated_at = now()
  WHERE id = p_booking_id;

  RETURN v_quote_message_id;
END;
$$;
CREATE OR REPLACE FUNCTION reject_renegotiation_proposal(
  p_booking_id uuid,
  p_message_id uuid,
  p_reason text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_client_id      uuid;
  v_tasker_user_id uuid;
  v_reason         text;
BEGIN
  SELECT b.client_id, tp.user_id
  INTO v_client_id, v_tasker_user_id
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF auth.uid() IS DISTINCT FROM v_client_id
     AND auth.uid() IS DISTINCT FROM v_tasker_user_id THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  UPDATE booking_messages
  SET card_status = 'locked',
      card_payload = COALESCE(card_payload, '{}'::jsonb)
        || jsonb_build_object('proposal_status', 'rejected')
  WHERE id = p_message_id
    AND booking_id = p_booking_id
    AND card_type = 'renegotiation'
    AND card_status = 'active';

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
  v_client_id         uuid;
  v_amount            numeric;
  v_card_owner_id     uuid;
  v_card_brand        text;
  v_card_last_four    text;
  v_service_fee       numeric;
  v_subtotal          numeric;
  v_discount          numeric := 0;
  v_total             numeric;
  v_card_type         text;
  v_scheduled_for     timestamptz;
BEGIN
  SELECT b.client_id, bm.card_type
  INTO v_client_id, v_card_type
  FROM bookings b
  JOIN booking_messages bm ON bm.id = p_message_id
  WHERE b.id = p_booking_id
    AND bm.booking_id = p_booking_id
    AND bm.card_status = 'active'
  FOR UPDATE;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_card_type = 'quote' THEN
    SELECT (bm.card_payload->>'amount')::numeric,
           nullif(bm.card_payload->>'scheduled_for', '')::timestamptz
    INTO v_amount, v_scheduled_for
    FROM booking_messages bm
    WHERE bm.id = p_message_id;
  ELSIF v_card_type = 'renegotiation' THEN
    SELECT (bm.card_payload->>'proposed_amount')::numeric,
           nullif(bm.card_payload->>'proposed_scheduled_for', '')::timestamptz
    INTO v_amount, v_scheduled_for
    FROM booking_messages bm
    WHERE bm.id = p_message_id;
  ELSE
    RAISE EXCEPTION 'La propuesta seleccionada no se puede aceptar';
  END IF;

  SELECT pm.user_id, pm.brand, pm.last_four
  INTO v_card_owner_id, v_card_brand, v_card_last_four
  FROM payment_methods pm
  WHERE pm.id = p_payment_method_id;

  IF v_card_owner_id IS NULL THEN
    RAISE EXCEPTION 'Payment method not found';
  END IF;

  IF v_card_owner_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Payment method does not belong to current user';
  END IF;

  v_subtotal := v_amount;
  v_service_fee := round((v_amount * 0.15)::numeric, 2);
  v_total := round((v_subtotal + v_service_fee - v_discount)::numeric, 2);

  UPDATE booking_messages
  SET card_status = 'resolved',
      card_payload = COALESCE(card_payload, '{}'::jsonb)
        || jsonb_build_object('proposal_status', 'accepted')
  WHERE id = p_message_id;

  UPDATE booking_messages
  SET card_status = 'locked',
      card_payload = COALESCE(card_payload, '{}'::jsonb)
        || jsonb_build_object('proposal_status', 'countered')
  WHERE booking_id = p_booking_id
    AND id <> p_message_id
    AND card_status = 'active'
    AND card_type IN ('quote', 'renegotiation');

  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (
    p_message_id,
    auth.uid(),
    'accepted',
    jsonb_build_object('payment_method_id', p_payment_method_id)
  );

  INSERT INTO booking_payments (
    booking_id,
    amount,
    service_comission,
    subtotal,
    discount,
    total_amount,
    payment_card_type,
    payment_card_last_four,
    status
  ) VALUES (
    p_booking_id,
    v_amount,
    v_service_fee,
    v_subtotal,
    v_discount,
    v_total,
    v_card_brand,
    v_card_last_four,
    'pending'
  );

  UPDATE bookings
  SET status = 'booked',
      status_source = 'client',
      accepted_at = now(),
      final_price = v_amount,
      quoted_price = v_amount,
      scheduled_for = COALESCE(v_scheduled_for, scheduled_for),
      updated_at = now()
  WHERE id = p_booking_id;
END;
$$;
