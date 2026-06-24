-- Normalize backend booking currency to 'L'.

ALTER TABLE public.bookings
  ALTER COLUMN currency SET DEFAULT 'L';
UPDATE public.bookings
SET currency = 'L'
WHERE currency IN ('LPS', 'Lps', 'HNL');
