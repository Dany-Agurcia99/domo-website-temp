-- Guard tasker_start_job so it can only run once when booking is booked.

CREATE OR REPLACE FUNCTION tasker_start_job(p_booking_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_scheduled_for  timestamptz;
  v_status         text;
  v_started_at     timestamptz;
BEGIN
  SELECT tp.user_id, b.scheduled_for, b.status, b.started_at
  INTO v_tasker_user_id, v_scheduled_for, v_status, v_started_at
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id
  FOR UPDATE;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF v_status IS DISTINCT FROM 'booked' THEN
    RAISE EXCEPTION 'Cannot start job: booking must be booked';
  END IF;

  IF v_started_at IS NOT NULL THEN
    RAISE EXCEPTION 'Cannot start job: booking already started';
  END IF;

  -- Only allow starting if booking date is today (UTC)
  IF DATE(v_scheduled_for AT TIME ZONE 'UTC') != CURRENT_DATE THEN
    RAISE EXCEPTION 'Cannot start job: booking is not scheduled for today';
  END IF;

  UPDATE bookings
  SET status        = 'in_progress',
      status_source = 'tasker',
      started_at    = now(),
      updated_at    = now()
  WHERE id = p_booking_id
    AND status = 'booked'
    AND started_at IS NULL;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Cannot start job: booking already started or not booked';
  END IF;

  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'system', 'El tasker ha comenzado el trabajo');
END;
$$;
