-- Expose status_source in booking card views for UI labels like
-- "Cancelado por cliente" / "Rechazado por tasker".

CREATE OR REPLACE VIEW public.client_booking_cards AS
SELECT
  b.id AS booking_id,
  b.client_id,
  s.name AS service_name,
  p.avatar_url AS tasker_picture,
  tp.is_verified AS is_tasker_verified,
  p.full_name AS tasker_name,
  concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) AS address,
  b.scheduled_for AS date_time,
  b.status,
  b.status_source
FROM public.bookings b
JOIN public.subcategories s ON s.id = b.subcategory_id
JOIN public.tasker_profiles tp ON tp.id = b.tasker_profile_id
JOIN public.profiles p ON p.id = tp.user_id;
CREATE OR REPLACE VIEW public.tasker_booking_cards AS
SELECT
  (b.id)::text AS booking_id,
  (b.client_id)::text AS client_id,
  (b.tasker_profile_id)::text AS tasker_id,
  (tp.user_id)::text AS user_id,
  s.name AS service_name,
  cp.avatar_url AS client_picture,
  cp.full_name AS client_name,
  c.name AS category_name,
  concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) AS address,
  b.scheduled_for AS date_time,
  b.status,
  b.status_source
FROM public.bookings b
JOIN public.tasker_profiles tp ON tp.id = b.tasker_profile_id
JOIN public.subcategories s ON s.id = b.subcategory_id
JOIN public.categories c ON c.id = s.category_id
JOIN public.profiles cp ON cp.id = b.client_id;
