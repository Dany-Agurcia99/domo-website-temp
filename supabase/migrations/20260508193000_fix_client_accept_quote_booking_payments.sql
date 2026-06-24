-- Fix client_accept_quote to match booking_payments schema
-- booking_payments currently stores card snapshot + totals, not payment_method_id/currency
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
BEGIN
  SELECT b.client_id, (bm.card_payload->>'amount')::numeric
  INTO v_client_id, v_amount
  FROM bookings b
  JOIN booking_messages bm ON bm.id = p_message_id
  WHERE b.id = p_booking_id
    AND bm.booking_id = p_booking_id;

  IF v_client_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
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

  -- Snapshot totals in booking_payments using current DOMO fee (15%)
  v_subtotal := v_amount;
  v_service_fee := round((v_amount * 0.15)::numeric, 2);
  v_total := round((v_subtotal + v_service_fee - v_discount)::numeric, 2);

  -- Lock quote card
  UPDATE booking_messages
  SET card_status = 'resolved'
  WHERE id = p_message_id;

  -- Record action metadata
  INSERT INTO booking_message_actions (message_id, actor_id, action, metadata)
  VALUES (
    p_message_id,
    auth.uid(),
    'accepted',
    jsonb_build_object('payment_method_id', p_payment_method_id)
  );

  -- Create pending booking payment row
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
