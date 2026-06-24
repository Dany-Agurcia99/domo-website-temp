-- Drop title column (derivable from subcategory_id, not needed as stored field)
ALTER TABLE public.bookings DROP COLUMN IF EXISTS title;
-- Drop address_line_2 column (not used)
ALTER TABLE public.bookings DROP COLUMN IF EXISTS address_line_2;
-- Add service_id nullable FK to tasker_services
ALTER TABLE public.bookings
  ADD COLUMN IF NOT EXISTS service_id uuid REFERENCES public.tasker_services(id);
