-- Enable pg_net for outbound HTTP calls (no-op if already enabled)
CREATE EXTENSION IF NOT EXISTS pg_net SCHEMA extensions;
-- ----------------------------------------------------------------
-- Function: send_booking_reminders
-- Called by pg_cron every 2 minutes.
-- Finds confirmed bookings starting in ~30 min, atomically claims
-- them via reminder_sent_at, then POSTs to Expo push API.
-- ----------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.send_booking_reminders()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_booking         RECORD;
  v_tasker_user_id  uuid;
  v_push_token      text;
  v_client_name     text;
  v_category_name   text;
  v_formatted_time  text;
BEGIN
  -- Atomically claim bookings that fall in the 28-32 minute window and
  -- have not yet received a reminder. The CTE UPDATE...RETURNING means
  -- each row is claimed by exactly one invocation even under concurrent runs.
  FOR v_booking IN
    WITH claimed AS (
      UPDATE bookings
      SET reminder_sent_at = now()
      WHERE status = 'booked'
        AND reminder_sent_at IS NULL
        AND scheduled_for BETWEEN (now() + interval '28 minutes')
                               AND (now() + interval '32 minutes')
      RETURNING id, client_id, tasker_profile_id, category_id, scheduled_for
    )
    SELECT * FROM claimed
  LOOP
    -- Resolve the tasker's auth user_id
    SELECT user_id INTO v_tasker_user_id
    FROM tasker_profiles
    WHERE id = v_booking.tasker_profile_id;

    IF v_tasker_user_id IS NULL THEN CONTINUE; END IF;

    -- Fetch push token
    SELECT expo_push_token INTO v_push_token
    FROM profiles
    WHERE id = v_tasker_user_id;

    IF v_push_token IS NULL THEN CONTINUE; END IF;

    -- Fetch display names
    SELECT full_name INTO v_client_name
    FROM profiles WHERE id = v_booking.client_id;

    SELECT name INTO v_category_name
    FROM categories WHERE id = v_booking.category_id;

    -- Format booking time in Honduras timezone (UTC-6, no DST)
    v_formatted_time := to_char(
      v_booking.scheduled_for AT TIME ZONE 'America/Tegucigalpa',
      'HH12:MI AM'
    );

    -- Send via Expo Push API
    PERFORM net.http_post(
      url     := 'https://exp.host/--/api/v2/push/send',
      headers := '{"Content-Type": "application/json", "Accept": "application/json"}'::jsonb,
      body    := jsonb_build_object(
        'to',        v_push_token,
        'title',     'Servicio en 30 minutos: ' || COALESCE(v_category_name, 'servicio'),
        'body',      'Recuerda que tienes un servicio con '
                       || COALESCE(v_client_name, 'un cliente')
                       || ' a las ' || v_formatted_time,
        'data',      jsonb_build_object(
                       'booking_id',     v_booking.id,
                       'type',           'booking_reminder',
                       'recipient_role', 'tasker'
                     ),
        'sound',     'default',
        'priority',  'high',
        'channelId', 'default'
      )
    );
  END LOOP;
END;
$$;
-- Schedule: run every 2 minutes
SELECT cron.schedule(
  'send-booking-reminders',
  '*/2 * * * *',
  'SELECT public.send_booking_reminders()'
);
