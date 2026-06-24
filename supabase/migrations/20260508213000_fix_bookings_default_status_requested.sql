-- Fix bookings default status to match current bookings_status_check values

ALTER TABLE bookings
  ALTER COLUMN status SET DEFAULT 'requested';
-- Safety backfill in case rows were inserted before this migration with old default.
UPDATE bookings
SET status = 'requested'
WHERE status = 'pending';
