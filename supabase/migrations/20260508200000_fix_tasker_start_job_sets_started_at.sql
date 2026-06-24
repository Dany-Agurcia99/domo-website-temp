-- Ensure tasker_start_job records real job start time.

CREATE OR REPLACE FUNCTION tasker_start_job(p_booking_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_tasker_user_id uuid;
  v_scheduled_for  timestamptz;
BEGIN
  SELECT tp.user_id, b.scheduled_for
  INTO v_tasker_user_id, v_scheduled_for
  FROM bookings b
  JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.id = p_booking_id;

  IF v_tasker_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Only allow starting if booking date is today (UTC)
  IF DATE(v_scheduled_for AT TIME ZONE 'UTC') != CURRENT_DATE THEN
    RAISE EXCEPTION 'Cannot start job: booking is not scheduled for today';
  END IF;

  -- Insert system message
  INSERT INTO booking_messages (booking_id, sender_id, message_type, body)
  VALUES (p_booking_id, auth.uid(), 'system', 'El tasker ha comenzado el trabajo');

  UPDATE bookings
  SET status        = 'in_progress',
      status_source = 'tasker',
      started_at    = now(),
      updated_at    = now()
  WHERE id = p_booking_id;
END;
$$;
