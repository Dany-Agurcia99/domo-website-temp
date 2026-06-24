-- Persist ISV metadata on booking payments and expose it in booking detail views.

ALTER TABLE public.booking_payments
  ADD COLUMN IF NOT EXISTS isv_percentage numeric(5,2) NOT NULL DEFAULT 16.00;
ALTER TABLE public.booking_payments
  ADD COLUMN IF NOT EXISTS isv_amount numeric(10,2)
  GENERATED ALWAYS AS (
    round(
      service_comission - (service_comission / (1 + (isv_percentage / 100))),
      2
    )
  ) STORED;
CREATE OR REPLACE VIEW public.client_booking_details AS
SELECT
  b.id,
  b.client_id,
  b.status,
  to_char(b.scheduled_for, 'YYYY-MM-DD'::text) AS date,
  to_char(b.scheduled_for, 'HH24:MI'::text) AS "time",
  jsonb_build_object('id', s.id, 'long_name', s.name, 'icon_key', s.icon_key) AS sub_category,
  jsonb_build_object('address', concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country), 'street', b.address_line_1, 'city', b.city, 'latitude', b.latitude, 'longitude', b.longitude) AS address,
  jsonb_build_object('name', s.name, 'description', b.description, 'price', COALESCE(b.final_price, b.quoted_price), 'estimated_time', NULL::unknown) AS offering,
  b.description AS problem_description,
  b.started_at,
  b.completed_at AS finished_at,
  CASE
    WHEN r.id IS NOT NULL THEN jsonb_build_object('rating', r.rating, 'comment', r.comment)
    ELSE NULL::jsonb
  END AS review,
  b.scheduled_for - '24:00:00'::interval AS cancelation_due_date,
  CASE
    WHEN pay.id IS NOT NULL THEN jsonb_build_object(
      'amount', pay.amount,
      'service_comission', pay.service_comission,
      'isv_percentage', pay.isv_percentage,
      'isv_amount', pay.isv_amount,
      'subtotal', pay.subtotal,
      'discount', pay.discount,
      'total_amount', pay.total_amount,
      'payment_card', jsonb_build_object('type', pay.payment_card_type, 'last_four', pay.payment_card_last_four)
    )
    ELSE NULL::jsonb
  END AS payment_data,
  jsonb_build_object('full_name', tasker_profile.full_name, 'profile_image', tasker_profile.avatar_url, 'average_rating', tp.average_rating, 'total_reviews', tp.total_reviews, 'is_verified', tp.is_verified, 'is_domo_diamond', COALESCE(tp.is_domo_diamond, false)) AS tasker,
  tp.user_id AS tasker_user_id
FROM bookings b
LEFT JOIN subcategories s ON s.id = b.subcategory_id
LEFT JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
LEFT JOIN profiles tasker_profile ON tasker_profile.id = tp.user_id
LEFT JOIN LATERAL (
  SELECT r2.id, r2.rating, r2.comment
  FROM reviews r2
  WHERE r2.booking_id = b.id AND (r2.is_reviewer_tasker IS NOT TRUE)
  ORDER BY r2.created_at DESC
  LIMIT 1
) r ON true
LEFT JOIN LATERAL (
  SELECT p.id, p.amount, p.service_comission, p.isv_percentage, p.isv_amount, p.subtotal, p.discount, p.total_amount, p.payment_card_type, p.payment_card_last_four
  FROM booking_payments p
  WHERE p.booking_id = b.id
  ORDER BY p.created_at DESC
  LIMIT 1
) pay ON true;
CREATE OR REPLACE VIEW public.tasker_booking_details AS
WITH client_reviews AS (
  SELECT
    r.reviewed_user_id AS client_id,
    count(*)::integer AS review_count,
    COALESCE(round(avg(r.rating), 1), 0::numeric) AS review_score
  FROM reviews r
  WHERE r.is_reviewer_tasker = true AND r.reviewed_user_id IS NOT NULL
  GROUP BY r.reviewed_user_id
)
SELECT
  b.id,
  b.id::text AS booking_id,
  b.client_id,
  b.tasker_profile_id::text AS tasker_id,
  tp.user_id::text AS tasker_user_id,
  tp.user_id::text AS user_id,
  s.name AS service_name,
  cp.avatar_url AS client_picture,
  cp.full_name AS client_name,
  c.name AS category_name,
  concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) AS address_text,
  b.scheduled_for AS date_time,
  b.status,
  to_char(b.scheduled_for, 'YYYY-MM-DD'::text) AS date,
  to_char(b.scheduled_for, 'HH24:MI'::text) AS "time",
  jsonb_build_object('id', s.id, 'long_name', s.name, 'icon_key', s.icon_key) AS sub_category,
  jsonb_build_object('address', concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country), 'street', b.address_line_1, 'city', b.city, 'latitude', b.latitude, 'longitude', b.longitude) AS address,
  jsonb_build_object('name', s.name, 'description', b.description, 'price', COALESCE(b.final_price, b.quoted_price), 'estimated_time', NULL::unknown) AS offering,
  b.description AS problem_description,
  b.started_at,
  b.completed_at AS finished_at,
  CASE
    WHEN review_data.rating IS NOT NULL THEN jsonb_build_object('rating', review_data.rating, 'comment', review_data.comment)
    ELSE NULL::jsonb
  END AS review,
  b.scheduled_for - '24:00:00'::interval AS cancelation_due_date,
  CASE
    WHEN pay.id IS NOT NULL THEN jsonb_build_object(
      'amount', pay.amount,
      'service_comission', pay.service_comission,
      'isv_percentage', pay.isv_percentage,
      'isv_amount', pay.isv_amount,
      'subtotal', pay.subtotal,
      'discount', pay.discount,
      'total_amount', pay.total_amount,
      'payment_card', jsonb_build_object('type', pay.payment_card_type, 'last_four', pay.payment_card_last_four)
    )
    ELSE NULL::jsonb
  END AS payment_data,
  jsonb_build_object('full_name', cp.full_name, 'profile_image', cp.avatar_url, 'average_rating', COALESCE(cr.review_score, 0::numeric), 'total_reviews', COALESCE(cr.review_count, 0)) AS client
FROM bookings b
LEFT JOIN tasker_profiles tp ON tp.id = b.tasker_profile_id
LEFT JOIN subcategories s ON s.id = b.subcategory_id
LEFT JOIN categories c ON c.id = s.category_id
LEFT JOIN profiles cp ON cp.id = b.client_id
LEFT JOIN LATERAL (
  SELECT r.rating, r.comment
  FROM reviews r
  WHERE r.booking_id = b.id AND r.is_reviewer_tasker = true
  ORDER BY r.created_at DESC
  LIMIT 1
) review_data ON true
LEFT JOIN LATERAL (
  SELECT p.id, p.booking_id, p.amount, p.service_comission, p.isv_percentage, p.isv_amount, p.subtotal, p.discount, p.total_amount, p.payment_card_type, p.payment_card_last_four, p.status, p.created_at
  FROM booking_payments p
  WHERE p.booking_id = b.id
  ORDER BY p.created_at DESC
  LIMIT 1
) pay ON true
LEFT JOIN client_reviews cr ON cr.client_id = b.client_id;
GRANT SELECT ON public.client_booking_details TO authenticated;
GRANT SELECT ON public.tasker_booking_details TO authenticated;
