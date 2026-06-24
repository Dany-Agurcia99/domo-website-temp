-- Fix service_cards, service_details, and tasker_service_info views to only count
-- client→tasker reviews (is_reviewer_tasker = false) instead of all bidirectional reviews.
-- Without this filter, tasker→client reviews (is_reviewer_tasker = true) were being
-- included in rating averages and review counts shown on service cards.

-- ─── service_cards ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.service_cards AS
SELECT
  ts.id,
  ts.tasker_profile_id,
  tp.user_id AS tasker_user_id,
  c.id AS category_id,
  c.name AS category_name,
  c.slug AS category_icon_name,
  ts.is_active,
  COALESCE(avg(r.rating), 0::numeric) AS rating,
  count(DISTINCT r.id) AS reviews_count,
  count(DISTINCT b.id) FILTER (WHERE b.status = 'completed') AS completed_jobs_count,
  COALESCE(array_agg(DISTINCT s.name) FILTER (WHERE s.id IS NOT NULL), '{}'::text[]) AS specialized_subcategory_tags
FROM public.tasker_services ts
JOIN public.tasker_profiles tp ON tp.id = ts.tasker_profile_id
JOIN public.categories c ON c.id = ts.category_id
LEFT JOIN public.tasker_service_subcategories tss ON tss.tasker_service_id = ts.id
LEFT JOIN public.subcategories s ON s.id = tss.subcategory_id
LEFT JOIN public.bookings b ON b.tasker_profile_id = ts.tasker_profile_id AND b.category_id = ts.category_id
LEFT JOIN public.reviews r ON r.booking_id = b.id AND (r.is_reviewer_tasker IS NOT TRUE)
GROUP BY ts.id, ts.tasker_profile_id, tp.user_id, c.id, c.name, c.slug, ts.is_active;
-- ─── service_details ───────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.service_details AS
SELECT
  ts.id,
  ts.tasker_profile_id,
  tp.user_id AS tasker_user_id,
  jsonb_build_object('id', c.id, 'name', c.name, 'slug', c.slug, 'description', c.description) AS category,
  COALESCE(
    jsonb_agg(DISTINCT jsonb_build_object(
      'id', s.id, 'category_id', s.category_id, 'name', s.name,
      'slug', s.slug, 'icon_key', s.icon_key, 'description', s.description,
      'jobsDone', COALESCE(tss.jobs_done, 0)
    )) FILTER (WHERE s.id IS NOT NULL),
    '[]'::jsonb
  ) AS specialized_subcategories,
  ts.images,
  ts.experience,
  ts.knowledge,
  ts.working_areas,
  COALESCE(
    jsonb_agg(DISTINCT jsonb_build_object(
      'id', tso.id, 'name', tso.name, 'description', tso.description,
      'price', tso.price, 'estimated_time', tso.estimated_time, 'is_active', tso.is_active
    )) FILTER (WHERE tso.id IS NOT NULL),
    '[]'::jsonb
  ) AS offerings,
  count(DISTINCT b.id) FILTER (WHERE b.status = 'completed') AS jobs_done,
  COALESCE(
    jsonb_agg(DISTINCT jsonb_build_object(
      'id', r.id, 'rating', r.rating, 'comment', r.comment, 'created_at', r.created_at
    )) FILTER (WHERE r.id IS NOT NULL),
    '[]'::jsonb
  ) AS service_reviews,
  ts.is_active
FROM public.tasker_services ts
JOIN public.tasker_profiles tp ON tp.id = ts.tasker_profile_id
JOIN public.categories c ON c.id = ts.category_id
LEFT JOIN public.tasker_service_subcategories tss ON tss.tasker_service_id = ts.id
LEFT JOIN public.subcategories s ON s.id = tss.subcategory_id
LEFT JOIN public.tasker_service_offerings tso ON tso.tasker_service_id = ts.id
LEFT JOIN public.bookings b ON b.tasker_profile_id = ts.tasker_profile_id AND b.category_id = ts.category_id
LEFT JOIN public.reviews r ON r.booking_id = b.id AND (r.is_reviewer_tasker IS NOT TRUE)
GROUP BY ts.id, ts.tasker_profile_id, tp.user_id, c.id, c.name, c.slug, c.description,
         ts.images, ts.experience, ts.knowledge, ts.working_areas, ts.is_active;
-- ─── tasker_service_info ───────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.tasker_service_info AS
WITH specialized_subcategories AS (
  SELECT
    tss.tasker_service_id,
    COALESCE(
      jsonb_agg(DISTINCT jsonb_build_object(
        'id', s.id, 'category_id', s.category_id, 'name', s.name,
        'slug', s.slug, 'icon_key', s.icon_key, 'description', s.description,
        'jobsDone', COALESCE(tss.jobs_done, 0)
      )) FILTER (WHERE s.id IS NOT NULL),
      '[]'::jsonb
    ) AS specialized_subcategories
  FROM public.tasker_service_subcategories tss
  JOIN public.subcategories s ON s.id = tss.subcategory_id
  GROUP BY tss.tasker_service_id
),
offerings AS (
  SELECT
    tso.tasker_service_id,
    COALESCE(
      jsonb_agg(jsonb_build_object(
        'id', tso.id, 'name', tso.name, 'description', tso.description,
        'price', tso.price, 'estimated_time', tso.estimated_time, 'is_active', tso.is_active
      ) ORDER BY tso.price) FILTER (WHERE tso.id IS NOT NULL),
      '[]'::jsonb
    ) AS offerings
  FROM public.tasker_service_offerings tso
  WHERE tso.is_active = true
  GROUP BY tso.tasker_service_id
),
service_reviews AS (
  SELECT
    ts_1.id AS tasker_service_id,
    COALESCE(
      jsonb_agg(DISTINCT jsonb_build_object(
        'id', r.id, 'rating', r.rating, 'comment', r.comment, 'created_at', r.created_at,
        'reviewer', jsonb_build_object(
          'id', reviewer.id, 'full_name', reviewer.full_name, 'avatar_url', reviewer.avatar_url
        )
      )) FILTER (WHERE r.id IS NOT NULL),
      '[]'::jsonb
    ) AS service_reviews,
    COALESCE(avg(r.rating), 0::numeric) AS rating,
    count(DISTINCT r.id) AS reviews_count
  FROM public.tasker_services ts_1
  LEFT JOIN public.bookings b ON b.tasker_profile_id = ts_1.tasker_profile_id AND b.category_id = ts_1.category_id
  LEFT JOIN public.reviews r ON r.booking_id = b.id AND (r.is_reviewer_tasker IS NOT TRUE)
  LEFT JOIN public.profiles reviewer ON reviewer.id = r.reviewer_id
  GROUP BY ts_1.id
),
service_jobs AS (
  SELECT
    ts_1.id AS tasker_service_id,
    count(DISTINCT b.id) FILTER (WHERE b.status = 'completed') AS jobs_done
  FROM public.tasker_services ts_1
  LEFT JOIN public.bookings b ON b.tasker_profile_id = ts_1.tasker_profile_id AND b.category_id = ts_1.category_id
  GROUP BY ts_1.id
)
SELECT
  ts.id AS service_id,
  ts.tasker_profile_id,
  tp.user_id AS tasker_user_id,
  jsonb_build_object('id', c.id, 'name', c.name, 'slug', c.slug, 'description', c.description) AS category,
  jsonb_build_object(
    'id', tp.id, 'user_id', tp.user_id, 'full_name', p.full_name,
    'profile_image', p.avatar_url, 'bio', tp.bio, 'experience_years', tp.experience_years,
    'average_rating', tp.average_rating, 'total_reviews', tp.total_reviews,
    'total_jobs', tp.total_jobs, 'is_verified', tp.is_verified, 'is_domo_diamond', tp.is_domo_diamond
  ) AS tasker,
  COALESCE(ss.specialized_subcategories, '[]'::jsonb) AS specialized_subcategories,
  COALESCE(ts.images, '{}'::text[]) AS images,
  ts.experience,
  ts.knowledge,
  COALESCE(ts.working_areas, '{}'::text[]) AS working_areas,
  COALESCE(o.offerings, '[]'::jsonb) AS offerings,
  COALESCE(sj.jobs_done, 0::bigint) AS jobs_done,
  COALESCE(sr.rating, 0::numeric) AS rating,
  COALESCE(sr.reviews_count, 0::bigint) AS reviews_count,
  COALESCE(sr.service_reviews, '[]'::jsonb) AS service_reviews,
  ts.is_active,
  ts.created_at,
  ts.updated_at
FROM public.tasker_services ts
JOIN public.tasker_profiles tp ON tp.id = ts.tasker_profile_id
JOIN public.profiles p ON p.id = tp.user_id
JOIN public.categories c ON c.id = ts.category_id
LEFT JOIN specialized_subcategories ss ON ss.tasker_service_id = ts.id
LEFT JOIN offerings o ON o.tasker_service_id = ts.id
LEFT JOIN service_reviews sr ON sr.tasker_service_id = ts.id
LEFT JOIN service_jobs sj ON sj.tasker_service_id = ts.id
WHERE ts.is_active = true;
