-- Fix taskers_by_category: the service_stats CTE was joining all reviews without
-- filtering direction, causing tasker→client reviews (is_reviewer_tasker = true)
-- to inflate rating averages and review counts shown on tasker cards.

CREATE OR REPLACE VIEW public.taskers_by_category AS
WITH subcategory_tags AS (
  SELECT
    tss.tasker_service_id,
    COALESCE(array_agg(DISTINCT s.name) FILTER (WHERE s.id IS NOT NULL), '{}'::text[]) AS specialized_subcategory_tags
  FROM public.tasker_service_subcategories tss
  JOIN public.subcategories s ON s.id = tss.subcategory_id
  GROUP BY tss.tasker_service_id
),
offering_stats AS (
  SELECT
    tso.tasker_service_id,
    min(tso.price) AS starting_price
  FROM public.tasker_service_offerings tso
  WHERE tso.is_active = true
  GROUP BY tso.tasker_service_id
),
service_stats AS (
  SELECT
    ts_1.id AS tasker_service_id,
    count(DISTINCT b.id) FILTER (WHERE b.status = 'completed') AS completed_jobs_count,
    COALESCE(avg(r.rating), 0::numeric) AS rating,
    count(DISTINCT r.id) AS reviews_count
  FROM public.tasker_services ts_1
  LEFT JOIN public.bookings b
    ON b.tasker_profile_id = ts_1.tasker_profile_id
    AND b.category_id = ts_1.category_id
  LEFT JOIN public.reviews r
    ON r.booking_id = b.id
    AND (r.is_reviewer_tasker IS NOT TRUE)
  GROUP BY ts_1.id
)
SELECT
  ts.id AS service_id,
  ts.category_id,
  c.name AS category_name,
  c.slug AS category_icon_name,
  ts.tasker_profile_id,
  tp.user_id AS tasker_user_id,
  p.full_name AS tasker_name,
  p.avatar_url AS tasker_picture,
  tp.is_verified AS is_tasker_verified,
  tp.is_domo_diamond,
  ts.is_active,
  COALESCE(ss.rating, 0::numeric) AS rating,
  COALESCE(ss.reviews_count, 0::bigint) AS reviews_count,
  COALESCE(ss.completed_jobs_count, 0::bigint) AS completed_jobs_count,
  COALESCE(st.specialized_subcategory_tags, '{}'::text[]) AS specialized_subcategory_tags,
  os.starting_price,
  CASE
    WHEN array_length(ts.images, 1) > 0 THEN ts.images[1]
    ELSE NULL::text
  END AS cover_image,
  ts.experience
FROM public.tasker_services ts
JOIN public.tasker_profiles tp ON tp.id = ts.tasker_profile_id
JOIN public.profiles p ON p.id = tp.user_id
JOIN public.categories c ON c.id = ts.category_id
LEFT JOIN subcategory_tags st ON st.tasker_service_id = ts.id
LEFT JOIN offering_stats os ON os.tasker_service_id = ts.id
LEFT JOIN service_stats ss ON ss.tasker_service_id = ts.id
WHERE ts.is_active = true
  AND (auth.uid() IS NULL OR tp.user_id <> auth.uid());
