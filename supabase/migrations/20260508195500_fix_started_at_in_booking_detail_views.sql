-- Fix booking detail views: started_at must reflect actual work start time
-- and not quote/payment acceptance timestamp.

alter table public.bookings
  add column if not exists started_at timestamptz;
-- Historical backfill: keep booked as null, but ensure in_progress/completed can show
-- a meaningful start reference when older rows predate started_at column.
update public.bookings
set started_at = coalesce(started_at, accepted_at)
where status in ('in_progress', 'completed')
  and started_at is null;
create or replace view "public"."client_booking_details" as
  SELECT b.id,
    b.client_id,
    b.status,
    to_char(b.scheduled_for, 'YYYY-MM-DD'::text) AS date,
    to_char(b.scheduled_for, 'HH24:MI'::text) AS "time",
    jsonb_build_object('id', s.id, 'long_name', s.name, 'icon_key', s.icon_key) AS sub_category,
    jsonb_build_object('address', concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country), 'street', b.address_line_1, 'city', b.city, 'latitude', b.latitude, 'longitude', b.longitude) AS address,
    jsonb_build_object('name', s.name, 'description', b.description, 'price', COALESCE(b.final_price, b.quoted_price), 'estimated_time', NULL::unknown) AS offering,
    b.description AS problem_description,
    b.started_at AS started_at,
    b.completed_at AS finished_at,
        CASE
            WHEN (r.id IS NOT NULL) THEN jsonb_build_object('rating', r.rating, 'comment', r.comment)
            ELSE NULL::jsonb
        END AS review,
    (b.scheduled_for - '24:00:00'::interval) AS cancelation_due_date,
        CASE
            WHEN (pay.id IS NOT NULL) THEN jsonb_build_object('amount', pay.amount, 'service_comission', pay.service_comission, 'subtotal', pay.subtotal, 'discount', pay.discount, 'total_amount', pay.total_amount, 'payment_card', jsonb_build_object('type', pay.payment_card_type, 'last_four', pay.payment_card_last_four))
            ELSE NULL::jsonb
        END AS payment_data,
    jsonb_build_object('full_name', tasker_profile.full_name, 'profile_image', tasker_profile.avatar_url, 'average_rating', tp.average_rating, 'total_reviews', tp.total_reviews, 'is_verified', tp.is_verified, 'is_domo_diamond', COALESCE(tp.is_domo_diamond, false)) AS tasker
   FROM (((((public.bookings b
     LEFT JOIN public.subcategories s ON ((s.id = b.subcategory_id)))
     LEFT JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
     LEFT JOIN public.profiles tasker_profile ON ((tasker_profile.id = tp.user_id)))
     LEFT JOIN public.reviews r ON ((r.booking_id = b.id)))
     LEFT JOIN public.booking_payments pay ON ((pay.booking_id = b.id)));
create or replace view "public"."tasker_booking_details" as
  with client_reviews as (
    select
      r.reviewed_user_id as client_id,
      count(*)::integer as review_count,
      coalesce(round(avg(r.rating), 1), 0::numeric) as review_score
    from public.reviews r
    where r.is_reviewer_tasker = true
      and r.reviewed_user_id is not null
    group by r.reviewed_user_id
  )
  select
    b.id,
    (b.id)::text as booking_id,
    b.client_id,
    (b.tasker_profile_id)::text as tasker_id,
    (tp.user_id)::text as tasker_user_id,
    (tp.user_id)::text as user_id,
    s.name as service_name,
    cp.avatar_url as client_picture,
    cp.full_name as client_name,
    c.name as category_name,
    concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) as address_text,
    b.scheduled_for as date_time,
    b.status,
    to_char(b.scheduled_for, 'YYYY-MM-DD'::text) as date,
    to_char(b.scheduled_for, 'HH24:MI'::text) as "time",
    jsonb_build_object(
      'id', s.id,
      'long_name', s.name,
      'icon_key', s.icon_key
    ) as sub_category,
    jsonb_build_object(
      'address', concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country),
      'street', b.address_line_1,
      'city', b.city,
      'latitude', b.latitude,
      'longitude', b.longitude
    ) as address,
    jsonb_build_object(
      'name', s.name,
      'description', b.description,
      'price', coalesce(b.final_price, b.quoted_price),
      'estimated_time', null::unknown
    ) as offering,
    b.description as problem_description,
    b.started_at as started_at,
    b.completed_at as finished_at,
    case
      when review_data.rating is not null then jsonb_build_object(
        'rating', review_data.rating,
        'comment', review_data.comment
      )
      else null::jsonb
    end as review,
    (b.scheduled_for - '24:00:00'::interval) as cancelation_due_date,
    case
      when pay.id is not null then jsonb_build_object(
        'amount', pay.amount,
        'service_comission', pay.service_comission,
        'subtotal', pay.subtotal,
        'discount', pay.discount,
        'total_amount', pay.total_amount,
        'payment_card', jsonb_build_object(
          'type', pay.payment_card_type,
          'last_four', pay.payment_card_last_four
        )
      )
      else null::jsonb
    end as payment_data,
    jsonb_build_object(
      'full_name', cp.full_name,
      'profile_image', cp.avatar_url,
      'average_rating', coalesce(cr.review_score, 0::numeric),
      'total_reviews', coalesce(cr.review_count, 0)
    ) as client
  from public.bookings b
    left join public.tasker_profiles tp on tp.id = b.tasker_profile_id
    left join public.subcategories s on s.id = b.subcategory_id
    left join public.categories c on c.id = s.category_id
    left join public.profiles cp on cp.id = b.client_id
    left join lateral (
      select r.rating, r.comment
      from public.reviews r
      where r.booking_id = b.id
      order by r.created_at desc
      limit 1
    ) review_data on true
    left join lateral (
      select p.*
      from public.booking_payments p
      where p.booking_id = b.id
      order by p.created_at desc
      limit 1
    ) pay on true
    left join client_reviews cr on cr.client_id = b.client_id;
