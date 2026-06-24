-- Add cancellation_rate and services_last_30_days to tasker_profile_info.
-- cancellation_rate: % of non-requested bookings that ended in cancellation.
-- services_last_30_days: completed bookings in the last 30 days.

CREATE OR REPLACE VIEW public.tasker_profile_info AS
WITH tasker_base AS (
  SELECT
    tp.id AS tasker_profile_id,
    tp.user_id AS tasker_user_id,
    p.full_name,
    p.avatar_url,
    tp.created_at AS tasker_profile_created_at,
    p.is_tasker,
    tp.is_verified,
    tp.is_domo_diamond
  FROM public.tasker_profiles tp
  JOIN public.profiles p ON p.id = tp.user_id
),
reviews_agg AS (
  SELECT
    r.reviewed_user_id AS tasker_user_id,
    count(*)::integer AS review_count,
    COALESCE(round(avg(r.rating), 1), 0::numeric) AS review_score
  FROM public.reviews r
  WHERE r.reviewed_user_id IS NOT NULL AND r.is_reviewer_tasker = false
  GROUP BY r.reviewed_user_id
),
completed_bookings AS (
  SELECT
    b.tasker_profile_id,
    b.final_price::numeric AS final_price,
    COALESCE(b.completed_at, b.created_at) AS completed_ts
  FROM public.bookings b
  WHERE b.status = 'completed'
),
earnings_monthly AS (
  SELECT
    cb.tasker_profile_id,
    date_trunc('month', cb.completed_ts)::date AS month_start,
    sum(cb.final_price) AS monthly_earnings,
    count(*)::integer AS monthly_task_count
  FROM completed_bookings cb
  GROUP BY cb.tasker_profile_id, date_trunc('month', cb.completed_ts)
),
earnings_overall AS (
  SELECT
    cb.tasker_profile_id,
    COALESCE(sum(cb.final_price), 0::numeric) AS overall_earnings,
    count(*)::integer AS overall_task_count
  FROM completed_bookings cb
  GROUP BY cb.tasker_profile_id
),
cancellation_stats AS (
  SELECT
    tp.user_id AS tasker_user_id,
    COALESCE(
      round(
        100.0
          * count(*) FILTER (WHERE b.status = 'cancelled')
          / NULLIF(count(*) FILTER (WHERE b.status <> 'requested'), 0),
        1
      ),
      0::numeric
    ) AS cancellation_rate
  FROM public.bookings b
  JOIN public.tasker_profiles tp ON tp.id = b.tasker_profile_id
  GROUP BY tp.user_id
),
services_30d AS (
  SELECT
    tp.user_id AS tasker_user_id,
    count(*)::integer AS services_last_30_days
  FROM public.bookings b
  JOIN public.tasker_profiles tp ON tp.id = b.tasker_profile_id
  WHERE b.status = 'completed'
    AND b.completed_at >= now() - interval '30 days'
  GROUP BY tp.user_id
)
SELECT
  tb.tasker_user_id AS id,
  tb.full_name,
  tb.avatar_url,
  COALESCE(ra.review_count, 0) AS review_count,
  COALESCE(ra.review_score, 0::numeric) AS review_score,
  COALESCE(em.monthly_earnings, 0::numeric) AS monthly_earnings,
  COALESCE(em_1.monthly_earnings, 0::numeric) AS one_month_ago_earnings,
  COALESCE(em_2.monthly_earnings, 0::numeric) AS two_months_ago_earnings,
  COALESCE(em_3.monthly_earnings, 0::numeric) AS three_months_ago_earnings,
  COALESCE(em_4.monthly_earnings, 0::numeric) AS four_months_ago_earnings,
  COALESCE(em_5.monthly_earnings, 0::numeric) AS five_months_ago_earnings,
  COALESCE(em.monthly_task_count, 0) AS monthly_task_count,
  COALESCE(eo.overall_earnings, 0::numeric) AS overall_earnings,
  COALESCE(eo.overall_task_count, 0) AS overall_task_count,
  tb.tasker_profile_created_at AS created_at,
  tb.is_verified,
  tb.is_domo_diamond,
  COALESCE(cs.cancellation_rate, 0::numeric) AS cancellation_rate,
  COALESCE(s30.services_last_30_days, 0) AS services_last_30_days
FROM tasker_base tb
LEFT JOIN reviews_agg ra ON ra.tasker_user_id = tb.tasker_user_id
LEFT JOIN earnings_overall eo ON eo.tasker_profile_id = tb.tasker_profile_id
LEFT JOIN earnings_monthly em
  ON em.tasker_profile_id = tb.tasker_profile_id
  AND em.month_start = date_trunc('month', now())::date
LEFT JOIN earnings_monthly em_1
  ON em_1.tasker_profile_id = tb.tasker_profile_id
  AND em_1.month_start = (date_trunc('month', now())::date - interval '1 mon')
LEFT JOIN earnings_monthly em_2
  ON em_2.tasker_profile_id = tb.tasker_profile_id
  AND em_2.month_start = (date_trunc('month', now())::date - interval '2 mons')
LEFT JOIN earnings_monthly em_3
  ON em_3.tasker_profile_id = tb.tasker_profile_id
  AND em_3.month_start = (date_trunc('month', now())::date - interval '3 mons')
LEFT JOIN earnings_monthly em_4
  ON em_4.tasker_profile_id = tb.tasker_profile_id
  AND em_4.month_start = (date_trunc('month', now())::date - interval '4 mons')
LEFT JOIN earnings_monthly em_5
  ON em_5.tasker_profile_id = tb.tasker_profile_id
  AND em_5.month_start = (date_trunc('month', now())::date - interval '5 mons')
LEFT JOIN cancellation_stats cs ON cs.tasker_user_id = tb.tasker_user_id
LEFT JOIN services_30d s30 ON s30.tasker_user_id = tb.tasker_user_id;
