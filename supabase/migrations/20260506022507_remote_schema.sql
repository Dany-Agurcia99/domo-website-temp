drop extension if exists "pg_net";
create table "public"."addresses" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "address" text not null,
    "street" text,
    "city" text,
    "state" text,
    "country" text,
    "latitude" numeric,
    "longitude" numeric,
    "is_default" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "name" text,
    "reference" text
      );
alter table "public"."addresses" enable row level security;
create table "public"."booking_payments" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid not null,
    "amount" numeric(10,2) not null,
    "service_comission" numeric(10,2) not null default 0,
    "subtotal" numeric(10,2) not null default 0,
    "discount" numeric(10,2) not null default 0,
    "total_amount" numeric(10,2) not null,
    "payment_card_type" text,
    "payment_card_last_four" text,
    "status" text not null default 'pending'::text,
    "created_at" timestamp with time zone not null default now()
      );
alter table "public"."booking_payments" enable row level security;
create table "public"."bookings" (
    "id" uuid not null default gen_random_uuid(),
    "client_id" uuid not null,
    "tasker_profile_id" uuid not null,
    "category_id" uuid not null,
    "subcategory_id" uuid not null,
    "title" text not null,
    "description" text,
    "address_line_1" text,
    "address_line_2" text,
    "city" text,
    "state" text,
    "country" text,
    "postal_code" text,
    "latitude" numeric(9,6),
    "longitude" numeric(9,6),
    "scheduled_for" timestamp with time zone,
    "status" text not null default 'pending'::text,
    "quoted_price" numeric(10,2),
    "final_price" numeric(10,2),
    "currency" text not null default 'USD'::text,
    "payment_status" text not null default 'pending'::text,
    "payout_status" text not null default 'pending'::text,
    "accepted_at" timestamp with time zone,
    "rejected_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "cancelled_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );
alter table "public"."bookings" enable row level security;
create table "public"."categories" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "slug" text not null,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "description" text not null
      );
alter table "public"."categories" enable row level security;
create table "public"."favorite_taskers" (
    "id" uuid not null default gen_random_uuid(),
    "client_id" uuid not null,
    "tasker_profile_id" uuid not null,
    "created_at" timestamp with time zone not null default now()
      );
alter table "public"."favorite_taskers" enable row level security;
create table "public"."payment_methods" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "brand" text not null,
    "last_four" text,
    "expiration" text,
    "is_default" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "holder_name" text
      );
alter table "public"."payment_methods" enable row level security;
create table "public"."profiles" (
    "id" uuid not null,
    "updated_at" timestamp with time zone,
    "full_name" text,
    "avatar_url" text,
    "created_at" timestamp with time zone default (now() AT TIME ZONE 'utc'::text),
    "is_tasker" boolean not null default false
      );
alter table "public"."profiles" enable row level security;
create table "public"."reviews" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid not null,
    "reviewer_id" uuid not null,
    "rating" integer not null,
    "comment" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "is_reviewer_tasker" boolean,
    "reviewed_user_id" uuid
      );
alter table "public"."reviews" enable row level security;
create table "public"."subcategories" (
    "id" uuid not null default gen_random_uuid(),
    "category_id" uuid not null,
    "name" text not null,
    "slug" text not null,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "icon_key" text,
    "description" text
      );
alter table "public"."subcategories" enable row level security;
create table "public"."tasker_profiles" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "bio" text,
    "experience_years" integer default 0,
    "is_verified" boolean not null default false,
    "is_available" boolean not null default true,
    "average_rating" numeric(3,2) default 0,
    "total_reviews" integer not null default 0,
    "total_jobs" integer not null default 0,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "is_domo_diamond" boolean not null default false
      );
alter table "public"."tasker_profiles" enable row level security;
create table "public"."tasker_service_offerings" (
    "id" uuid not null default gen_random_uuid(),
    "tasker_service_id" uuid not null,
    "name" text not null,
    "description" text,
    "price" numeric(10,2),
    "estimated_time" text,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );
alter table "public"."tasker_service_offerings" enable row level security;
create table "public"."tasker_service_subcategories" (
    "id" uuid not null default gen_random_uuid(),
    "tasker_service_id" uuid not null,
    "subcategory_id" uuid not null,
    "jobs_done" integer not null default 0,
    "created_at" timestamp with time zone not null default now()
      );
alter table "public"."tasker_service_subcategories" enable row level security;
create table "public"."tasker_services" (
    "id" uuid not null default gen_random_uuid(),
    "tasker_profile_id" uuid not null,
    "category_id" uuid not null,
    "experience" text,
    "knowledge" text,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "working_areas" text[] not null default '{}'::text[],
    "images" text[] not null default '{}'::text[]
      );
alter table "public"."tasker_services" enable row level security;
create table "public"."tasker_subcategories" (
    "id" uuid not null default gen_random_uuid(),
    "tasker_profile_id" uuid not null,
    "subcategory_id" uuid not null,
    "starting_price" numeric(10,2),
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now()
      );
alter table "public"."tasker_subcategories" enable row level security;
CREATE UNIQUE INDEX addresses_pkey ON public.addresses USING btree (id);
CREATE UNIQUE INDEX bookings_pkey ON public.bookings USING btree (id);
CREATE UNIQUE INDEX categories_name_key ON public.categories USING btree (name);
CREATE UNIQUE INDEX categories_pkey ON public.categories USING btree (id);
CREATE UNIQUE INDEX categories_slug_key ON public.categories USING btree (slug);
CREATE UNIQUE INDEX favorite_taskers_client_id_tasker_profile_id_key ON public.favorite_taskers USING btree (client_id, tasker_profile_id);
CREATE UNIQUE INDEX favorite_taskers_pkey ON public.favorite_taskers USING btree (id);
CREATE UNIQUE INDEX payment_methods_pkey ON public.payment_methods USING btree (id);
CREATE UNIQUE INDEX payments_booking_id_key ON public.booking_payments USING btree (booking_id);
CREATE UNIQUE INDEX payments_pkey ON public.booking_payments USING btree (id);
CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);
CREATE UNIQUE INDEX reviews_booking_id_is_tasker_review_key ON public.reviews USING btree (booking_id, is_reviewer_tasker);
CREATE UNIQUE INDEX reviews_pkey ON public.reviews USING btree (id);
CREATE UNIQUE INDEX subcategories_category_id_slug_key ON public.subcategories USING btree (category_id, slug);
CREATE UNIQUE INDEX subcategories_pkey ON public.subcategories USING btree (id);
CREATE UNIQUE INDEX tasker_profiles_pkey ON public.tasker_profiles USING btree (id);
CREATE UNIQUE INDEX tasker_profiles_user_id_key ON public.tasker_profiles USING btree (user_id);
CREATE UNIQUE INDEX tasker_service_offerings_pkey ON public.tasker_service_offerings USING btree (id);
CREATE UNIQUE INDEX tasker_service_subcategories_pkey ON public.tasker_service_subcategories USING btree (id);
CREATE UNIQUE INDEX tasker_service_subcategories_tasker_service_id_subcategory__key ON public.tasker_service_subcategories USING btree (tasker_service_id, subcategory_id);
CREATE UNIQUE INDEX tasker_services_pkey ON public.tasker_services USING btree (id);
CREATE UNIQUE INDEX tasker_services_tasker_profile_id_category_id_key ON public.tasker_services USING btree (tasker_profile_id, category_id);
CREATE UNIQUE INDEX tasker_subcategories_pkey ON public.tasker_subcategories USING btree (id);
CREATE UNIQUE INDEX tasker_subcategories_tasker_profile_id_subcategory_id_key ON public.tasker_subcategories USING btree (tasker_profile_id, subcategory_id);
alter table "public"."addresses" add constraint "addresses_pkey" PRIMARY KEY using index "addresses_pkey";
alter table "public"."booking_payments" add constraint "payments_pkey" PRIMARY KEY using index "payments_pkey";
alter table "public"."bookings" add constraint "bookings_pkey" PRIMARY KEY using index "bookings_pkey";
alter table "public"."categories" add constraint "categories_pkey" PRIMARY KEY using index "categories_pkey";
alter table "public"."favorite_taskers" add constraint "favorite_taskers_pkey" PRIMARY KEY using index "favorite_taskers_pkey";
alter table "public"."payment_methods" add constraint "payment_methods_pkey" PRIMARY KEY using index "payment_methods_pkey";
alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";
alter table "public"."reviews" add constraint "reviews_pkey" PRIMARY KEY using index "reviews_pkey";
alter table "public"."subcategories" add constraint "subcategories_pkey" PRIMARY KEY using index "subcategories_pkey";
alter table "public"."tasker_profiles" add constraint "tasker_profiles_pkey" PRIMARY KEY using index "tasker_profiles_pkey";
alter table "public"."tasker_service_offerings" add constraint "tasker_service_offerings_pkey" PRIMARY KEY using index "tasker_service_offerings_pkey";
alter table "public"."tasker_service_subcategories" add constraint "tasker_service_subcategories_pkey" PRIMARY KEY using index "tasker_service_subcategories_pkey";
alter table "public"."tasker_services" add constraint "tasker_services_pkey" PRIMARY KEY using index "tasker_services_pkey";
alter table "public"."tasker_subcategories" add constraint "tasker_subcategories_pkey" PRIMARY KEY using index "tasker_subcategories_pkey";
alter table "public"."addresses" add constraint "addresses_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."addresses" validate constraint "addresses_user_id_fkey";
alter table "public"."booking_payments" add constraint "payments_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE not valid;
alter table "public"."booking_payments" validate constraint "payments_booking_id_fkey";
alter table "public"."booking_payments" add constraint "payments_booking_id_key" UNIQUE using index "payments_booking_id_key";
alter table "public"."bookings" add constraint "bookings_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT not valid;
alter table "public"."bookings" validate constraint "bookings_category_id_fkey";
alter table "public"."bookings" add constraint "bookings_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."bookings" validate constraint "bookings_client_id_fkey";
alter table "public"."bookings" add constraint "bookings_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text]))) not valid;
alter table "public"."bookings" validate constraint "bookings_payment_status_check";
alter table "public"."bookings" add constraint "bookings_payout_status_check" CHECK ((payout_status = ANY (ARRAY['pending'::text, 'processing'::text, 'paid'::text, 'failed'::text]))) not valid;
alter table "public"."bookings" validate constraint "bookings_payout_status_check";
alter table "public"."bookings" add constraint "bookings_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'cancelled'::text, 'awaiting_payment'::text, 'paid'::text, 'in_progress'::text, 'completed'::text, 'disputed'::text]))) not valid;
alter table "public"."bookings" validate constraint "bookings_status_check";
alter table "public"."bookings" add constraint "bookings_subcategory_id_fkey" FOREIGN KEY (subcategory_id) REFERENCES public.subcategories(id) ON DELETE RESTRICT not valid;
alter table "public"."bookings" validate constraint "bookings_subcategory_id_fkey";
alter table "public"."bookings" add constraint "bookings_tasker_profile_id_fkey" FOREIGN KEY (tasker_profile_id) REFERENCES public.tasker_profiles(id) ON DELETE RESTRICT not valid;
alter table "public"."bookings" validate constraint "bookings_tasker_profile_id_fkey";
alter table "public"."categories" add constraint "categories_name_key" UNIQUE using index "categories_name_key";
alter table "public"."categories" add constraint "categories_slug_key" UNIQUE using index "categories_slug_key";
alter table "public"."favorite_taskers" add constraint "favorite_taskers_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."favorite_taskers" validate constraint "favorite_taskers_client_id_fkey";
alter table "public"."favorite_taskers" add constraint "favorite_taskers_client_id_tasker_profile_id_key" UNIQUE using index "favorite_taskers_client_id_tasker_profile_id_key";
alter table "public"."favorite_taskers" add constraint "favorite_taskers_tasker_profile_id_fkey" FOREIGN KEY (tasker_profile_id) REFERENCES public.tasker_profiles(id) ON DELETE CASCADE not valid;
alter table "public"."favorite_taskers" validate constraint "favorite_taskers_tasker_profile_id_fkey";
alter table "public"."payment_methods" add constraint "payment_methods_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."payment_methods" validate constraint "payment_methods_user_id_fkey";
alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;
alter table "public"."profiles" validate constraint "profiles_id_fkey";
alter table "public"."reviews" add constraint "reviews_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE not valid;
alter table "public"."reviews" validate constraint "reviews_booking_id_fkey";
alter table "public"."reviews" add constraint "reviews_booking_id_is_tasker_review_key" UNIQUE using index "reviews_booking_id_is_tasker_review_key";
alter table "public"."reviews" add constraint "reviews_rating_check" CHECK (((rating >= 1) AND (rating <= 5))) not valid;
alter table "public"."reviews" validate constraint "reviews_rating_check";
alter table "public"."reviews" add constraint "reviews_reviewed_user_id_fkey" FOREIGN KEY (reviewed_user_id) REFERENCES public.profiles(id) not valid;
alter table "public"."reviews" validate constraint "reviews_reviewed_user_id_fkey";
alter table "public"."reviews" add constraint "reviews_reviewer_id_fkey" FOREIGN KEY (reviewer_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."reviews" validate constraint "reviews_reviewer_id_fkey";
alter table "public"."subcategories" add constraint "subcategories_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE not valid;
alter table "public"."subcategories" validate constraint "subcategories_category_id_fkey";
alter table "public"."subcategories" add constraint "subcategories_category_id_slug_key" UNIQUE using index "subcategories_category_id_slug_key";
alter table "public"."tasker_profiles" add constraint "tasker_profiles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_profiles" validate constraint "tasker_profiles_user_id_fkey";
alter table "public"."tasker_profiles" add constraint "tasker_profiles_user_id_key" UNIQUE using index "tasker_profiles_user_id_key";
alter table "public"."tasker_service_offerings" add constraint "tasker_service_offerings_tasker_service_id_fkey" FOREIGN KEY (tasker_service_id) REFERENCES public.tasker_services(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_service_offerings" validate constraint "tasker_service_offerings_tasker_service_id_fkey";
alter table "public"."tasker_service_subcategories" add constraint "tasker_service_subcategories_subcategory_id_fkey" FOREIGN KEY (subcategory_id) REFERENCES public.subcategories(id) ON DELETE RESTRICT not valid;
alter table "public"."tasker_service_subcategories" validate constraint "tasker_service_subcategories_subcategory_id_fkey";
alter table "public"."tasker_service_subcategories" add constraint "tasker_service_subcategories_tasker_service_id_fkey" FOREIGN KEY (tasker_service_id) REFERENCES public.tasker_services(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_service_subcategories" validate constraint "tasker_service_subcategories_tasker_service_id_fkey";
alter table "public"."tasker_service_subcategories" add constraint "tasker_service_subcategories_tasker_service_id_subcategory__key" UNIQUE using index "tasker_service_subcategories_tasker_service_id_subcategory__key";
alter table "public"."tasker_services" add constraint "tasker_services_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT not valid;
alter table "public"."tasker_services" validate constraint "tasker_services_category_id_fkey";
alter table "public"."tasker_services" add constraint "tasker_services_tasker_profile_id_category_id_key" UNIQUE using index "tasker_services_tasker_profile_id_category_id_key";
alter table "public"."tasker_services" add constraint "tasker_services_tasker_profile_id_fkey" FOREIGN KEY (tasker_profile_id) REFERENCES public.tasker_profiles(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_services" validate constraint "tasker_services_tasker_profile_id_fkey";
alter table "public"."tasker_subcategories" add constraint "tasker_subcategories_subcategory_id_fkey" FOREIGN KEY (subcategory_id) REFERENCES public.subcategories(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_subcategories" validate constraint "tasker_subcategories_subcategory_id_fkey";
alter table "public"."tasker_subcategories" add constraint "tasker_subcategories_tasker_profile_id_fkey" FOREIGN KEY (tasker_profile_id) REFERENCES public.tasker_profiles(id) ON DELETE CASCADE not valid;
alter table "public"."tasker_subcategories" validate constraint "tasker_subcategories_tasker_profile_id_fkey";
alter table "public"."tasker_subcategories" add constraint "tasker_subcategories_tasker_profile_id_subcategory_id_key" UNIQUE using index "tasker_subcategories_tasker_profile_id_subcategory_id_key";
set check_function_bodies = off;
create or replace view "public"."client_booking_cards" as  SELECT b.id AS booking_id,
    b.client_id,
    s.name AS service_name,
    p.avatar_url AS tasker_picture,
    tp.is_verified AS is_tasker_verified,
    p.full_name AS tasker_name,
    concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) AS address,
    b.scheduled_for AS date_time,
    b.status
   FROM (((public.bookings b
     JOIN public.subcategories s ON ((s.id = b.subcategory_id)))
     JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
     JOIN public.profiles p ON ((p.id = tp.user_id)));
create or replace view "public"."client_booking_details" as  SELECT b.id,
    b.client_id,
    b.status,
    to_char(b.scheduled_for, 'YYYY-MM-DD'::text) AS date,
    to_char(b.scheduled_for, 'HH24:MI'::text) AS "time",
    jsonb_build_object('id', s.id, 'long_name', s.name, 'icon_key', s.icon_key) AS sub_category,
    jsonb_build_object('address', concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country), 'street', b.address_line_1, 'city', b.city, 'latitude', b.latitude, 'longitude', b.longitude) AS address,
    jsonb_build_object('name', s.name, 'description', b.description, 'price', COALESCE(b.final_price, b.quoted_price), 'estimated_time', NULL::unknown) AS offering,
    b.description AS problem_description,
    b.accepted_at AS started_at,
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
create or replace view "public"."client_profile_card" as  SELECT p.id,
    p.full_name,
    p.avatar_url,
    COALESCE(rv.review_count, 0) AS review_count,
    COALESCE(rv.review_score, (0)::numeric) AS review_score,
    p.created_at,
    p.is_tasker
   FROM (public.profiles p
     LEFT JOIN ( SELECT r.reviewed_user_id,
            (count(*))::integer AS review_count,
            COALESCE(round(avg(r.rating), 1), (0)::numeric) AS review_score
           FROM public.reviews r
          WHERE (r.is_reviewer_tasker = true)
          GROUP BY r.reviewed_user_id) rv ON ((rv.reviewed_user_id = p.id)));
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'name'
    ),
    coalesce(
      new.raw_user_meta_data->>'picture'
    )
  );

  return new;
end;
$function$;
create or replace view "public"."home_high_rated_taskers" as  WITH tasker_service_summary AS (
         SELECT ts.tasker_profile_id,
            count(DISTINCT ts.id) FILTER (WHERE (ts.is_active = true)) AS active_services_count,
            COALESCE(array_agg(DISTINCT c.name) FILTER (WHERE ((c.id IS NOT NULL) AND (ts.is_active = true))), '{}'::text[]) AS category_tags,
            min(tso.price) FILTER (WHERE ((tso.is_active = true) AND (ts.is_active = true))) AS starting_price,
                CASE
                    WHEN (count(ts.images) FILTER (WHERE ((array_length(ts.images, 1) > 0) AND (ts.is_active = true))) > 0) THEN (array_agg(ts.images[1]) FILTER (WHERE ((array_length(ts.images, 1) > 0) AND (ts.is_active = true))))[1]
                    ELSE NULL::text
                END AS cover_image
           FROM ((public.tasker_services ts
             LEFT JOIN public.categories c ON ((c.id = ts.category_id)))
             LEFT JOIN public.tasker_service_offerings tso ON ((tso.tasker_service_id = ts.id)))
          GROUP BY ts.tasker_profile_id
        ), completed_jobs AS (
         SELECT b.tasker_profile_id,
            count(*) AS completed_jobs_count
           FROM public.bookings b
          WHERE (b.status = 'completed'::text)
          GROUP BY b.tasker_profile_id
        )
 SELECT tp.id AS tasker_profile_id,
    tp.user_id AS tasker_user_id,
    p.full_name AS tasker_name,
    p.avatar_url AS tasker_picture,
    tp.average_rating AS rating,
    tp.total_reviews AS reviews_count,
    COALESCE(cj.completed_jobs_count, (tp.total_jobs)::bigint, (0)::bigint) AS completed_jobs_count,
    tp.is_verified,
    tp.is_domo_diamond,
    COALESCE(tss.active_services_count, (0)::bigint) AS active_services_count,
    COALESCE(tss.category_tags, '{}'::text[]) AS category_tags,
    tss.starting_price,
    tss.cover_image
   FROM (((public.tasker_profiles tp
     JOIN public.profiles p ON ((p.id = tp.user_id)))
     LEFT JOIN tasker_service_summary tss ON ((tss.tasker_profile_id = tp.id)))
     LEFT JOIN completed_jobs cj ON ((cj.tasker_profile_id = tp.id)))
  WHERE ((tp.is_available = true) AND (COALESCE(tss.active_services_count, (0)::bigint) > 0))
  ORDER BY tp.average_rating DESC, tp.total_reviews DESC, COALESCE(cj.completed_jobs_count, (tp.total_jobs)::bigint, (0)::bigint) DESC
 LIMIT 10;
create or replace view "public"."service_cards" as  SELECT ts.id,
    ts.tasker_profile_id,
    tp.user_id AS tasker_user_id,
    c.id AS category_id,
    c.name AS category_name,
    c.slug AS category_icon_name,
    ts.is_active,
    COALESCE(avg(r.rating), (0)::numeric) AS rating,
    count(DISTINCT r.id) AS reviews_count,
    count(DISTINCT b.id) FILTER (WHERE (b.status = 'completed'::text)) AS completed_jobs_count,
    COALESCE(array_agg(DISTINCT s.name) FILTER (WHERE (s.id IS NOT NULL)), '{}'::text[]) AS specialized_subcategory_tags
   FROM ((((((public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
     JOIN public.categories c ON ((c.id = ts.category_id)))
     LEFT JOIN public.tasker_service_subcategories tss ON ((tss.tasker_service_id = ts.id)))
     LEFT JOIN public.subcategories s ON ((s.id = tss.subcategory_id)))
     LEFT JOIN public.bookings b ON (((b.tasker_profile_id = ts.tasker_profile_id) AND (b.category_id = ts.category_id))))
     LEFT JOIN public.reviews r ON ((r.booking_id = b.id)))
  GROUP BY ts.id, ts.tasker_profile_id, tp.user_id, c.id, c.name, c.slug, ts.is_active;
create or replace view "public"."service_details" as  SELECT ts.id,
    ts.tasker_profile_id,
    tp.user_id AS tasker_user_id,
    jsonb_build_object('id', c.id, 'name', c.name, 'slug', c.slug, 'description', c.description) AS category,
    COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', s.id, 'category_id', s.category_id, 'name', s.name, 'slug', s.slug, 'icon_key', s.icon_key, 'description', s.description, 'jobsDone', COALESCE(tss.jobs_done, 0))) FILTER (WHERE (s.id IS NOT NULL)), '[]'::jsonb) AS specialized_subcategories,
    ts.images,
    ts.experience,
    ts.knowledge,
    ts.working_areas,
    COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', tso.id, 'name', tso.name, 'description', tso.description, 'price', tso.price, 'estimated_time', tso.estimated_time, 'is_active', tso.is_active)) FILTER (WHERE (tso.id IS NOT NULL)), '[]'::jsonb) AS offerings,
    count(DISTINCT b.id) FILTER (WHERE (b.status = 'completed'::text)) AS jobs_done,
    COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', r.id, 'rating', r.rating, 'comment', r.comment, 'created_at', r.created_at)) FILTER (WHERE (r.id IS NOT NULL)), '[]'::jsonb) AS service_reviews,
    ts.is_active
   FROM (((((((public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
     JOIN public.categories c ON ((c.id = ts.category_id)))
     LEFT JOIN public.tasker_service_subcategories tss ON ((tss.tasker_service_id = ts.id)))
     LEFT JOIN public.subcategories s ON ((s.id = tss.subcategory_id)))
     LEFT JOIN public.tasker_service_offerings tso ON ((tso.tasker_service_id = ts.id)))
     LEFT JOIN public.bookings b ON (((b.tasker_profile_id = ts.tasker_profile_id) AND (b.category_id = ts.category_id))))
     LEFT JOIN public.reviews r ON ((r.booking_id = b.id)))
  GROUP BY ts.id, ts.tasker_profile_id, tp.user_id, c.id, c.name, c.slug, c.description, ts.images, ts.experience, ts.knowledge, ts.working_areas, ts.is_active;
create or replace view "public"."tasker_booking_cards" as  SELECT (b.id)::text AS booking_id,
    (b.client_id)::text AS client_id,
    (b.tasker_profile_id)::text AS tasker_id,
    (tp.user_id)::text AS user_id,
    s.name AS service_name,
    cp.avatar_url AS client_picture,
    cp.full_name AS client_name,
    c.name AS category_name,
    concat_ws(', '::text, b.address_line_1, b.city, b.state, b.country) AS address,
    b.scheduled_for AS date_time,
    b.status
   FROM ((((public.bookings b
     JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
     JOIN public.subcategories s ON ((s.id = b.subcategory_id)))
     JOIN public.categories c ON ((c.id = s.category_id)))
     JOIN public.profiles cp ON ((cp.id = b.client_id)));
create or replace view "public"."tasker_profile_info" as  WITH tasker_base AS (
         SELECT tp.id AS tasker_profile_id,
            tp.user_id AS tasker_user_id,
            p.full_name,
            p.avatar_url,
            tp.created_at AS tasker_profile_created_at,
            p.is_tasker,
            tp.is_verified,
            tp.is_domo_diamond
           FROM (public.tasker_profiles tp
             JOIN public.profiles p ON ((p.id = tp.user_id)))
        ), reviews_agg AS (
         SELECT r.reviewed_user_id AS tasker_user_id,
            (count(*))::integer AS review_count,
            COALESCE(round(avg(r.rating), 1), (0)::numeric) AS review_score
           FROM public.reviews r
          WHERE ((r.reviewed_user_id IS NOT NULL) AND (r.is_reviewer_tasker = false))
          GROUP BY r.reviewed_user_id
        ), completed_bookings AS (
         SELECT b.tasker_profile_id,
            (b.final_price)::numeric AS final_price,
            COALESCE(b.completed_at, b.created_at) AS completed_ts
           FROM public.bookings b
          WHERE (b.status = 'completed'::text)
        ), earnings_monthly AS (
         SELECT cb.tasker_profile_id,
            (date_trunc('month'::text, cb.completed_ts))::date AS month_start,
            sum(cb.final_price) AS monthly_earnings,
            (count(*))::integer AS monthly_task_count
           FROM completed_bookings cb
          GROUP BY cb.tasker_profile_id, (date_trunc('month'::text, cb.completed_ts))
        ), earnings_overall AS (
         SELECT cb.tasker_profile_id,
            COALESCE(sum(cb.final_price), (0)::numeric) AS overall_earnings,
            (count(*))::integer AS overall_task_count
           FROM completed_bookings cb
          GROUP BY cb.tasker_profile_id
        )
 SELECT tb.tasker_user_id AS id,
    tb.full_name,
    tb.avatar_url,
    COALESCE(ra.review_count, 0) AS review_count,
    COALESCE(ra.review_score, (0)::numeric) AS review_score,
    COALESCE(em.monthly_earnings, (0)::numeric) AS monthly_earnings,
    COALESCE(em_1.monthly_earnings, (0)::numeric) AS one_month_ago_earnings,
    COALESCE(em_2.monthly_earnings, (0)::numeric) AS two_months_ago_earnings,
    COALESCE(em_3.monthly_earnings, (0)::numeric) AS three_months_ago_earnings,
    COALESCE(em_4.monthly_earnings, (0)::numeric) AS four_months_ago_earnings,
    COALESCE(em_5.monthly_earnings, (0)::numeric) AS five_months_ago_earnings,
    COALESCE(em.monthly_task_count, 0) AS monthly_task_count,
    COALESCE(eo.overall_earnings, (0)::numeric) AS overall_earnings,
    COALESCE(eo.overall_task_count, 0) AS overall_task_count,
    tb.tasker_profile_created_at AS created_at,
    tb.is_verified,
    tb.is_domo_diamond
   FROM ((((((((tasker_base tb
     LEFT JOIN reviews_agg ra ON ((ra.tasker_user_id = tb.tasker_user_id)))
     LEFT JOIN earnings_overall eo ON ((eo.tasker_profile_id = tb.tasker_profile_id)))
     LEFT JOIN earnings_monthly em ON (((em.tasker_profile_id = tb.tasker_profile_id) AND (em.month_start = (date_trunc('month'::text, now()))::date))))
     LEFT JOIN earnings_monthly em_1 ON (((em_1.tasker_profile_id = tb.tasker_profile_id) AND (em_1.month_start = ((date_trunc('month'::text, now()))::date - '1 mon'::interval)))))
     LEFT JOIN earnings_monthly em_2 ON (((em_2.tasker_profile_id = tb.tasker_profile_id) AND (em_2.month_start = ((date_trunc('month'::text, now()))::date - '2 mons'::interval)))))
     LEFT JOIN earnings_monthly em_3 ON (((em_3.tasker_profile_id = tb.tasker_profile_id) AND (em_3.month_start = ((date_trunc('month'::text, now()))::date - '3 mons'::interval)))))
     LEFT JOIN earnings_monthly em_4 ON (((em_4.tasker_profile_id = tb.tasker_profile_id) AND (em_4.month_start = ((date_trunc('month'::text, now()))::date - '4 mons'::interval)))))
     LEFT JOIN earnings_monthly em_5 ON (((em_5.tasker_profile_id = tb.tasker_profile_id) AND (em_5.month_start = ((date_trunc('month'::text, now()))::date - '5 mons'::interval)))));
create or replace view "public"."tasker_review_cards" as  SELECT r.reviewed_user_id AS id,
    pr.full_name,
    pr.avatar_url,
    r.rating,
    r.comment,
    r.created_at
   FROM ((public.reviews r
     JOIN public.tasker_profiles tp ON ((tp.user_id = r.reviewed_user_id)))
     JOIN public.profiles pr ON ((pr.id = r.reviewer_id)))
  WHERE (r.is_reviewer_tasker = false);
create or replace view "public"."tasker_service_info" as  WITH specialized_subcategories AS (
         SELECT tss.tasker_service_id,
            COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', s.id, 'category_id', s.category_id, 'name', s.name, 'slug', s.slug, 'icon_key', s.icon_key, 'description', s.description, 'jobsDone', COALESCE(tss.jobs_done, 0))) FILTER (WHERE (s.id IS NOT NULL)), '[]'::jsonb) AS specialized_subcategories
           FROM (public.tasker_service_subcategories tss
             JOIN public.subcategories s ON ((s.id = tss.subcategory_id)))
          GROUP BY tss.tasker_service_id
        ), offerings AS (
         SELECT tso.tasker_service_id,
            COALESCE(jsonb_agg(jsonb_build_object('id', tso.id, 'name', tso.name, 'description', tso.description, 'price', tso.price, 'estimated_time', tso.estimated_time, 'is_active', tso.is_active) ORDER BY tso.price) FILTER (WHERE (tso.id IS NOT NULL)), '[]'::jsonb) AS offerings
           FROM public.tasker_service_offerings tso
          WHERE (tso.is_active = true)
          GROUP BY tso.tasker_service_id
        ), service_reviews AS (
         SELECT ts_1.id AS tasker_service_id,
            COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', r.id, 'rating', r.rating, 'comment', r.comment, 'created_at', r.created_at, 'reviewer', jsonb_build_object('id', reviewer.id, 'full_name', reviewer.full_name, 'avatar_url', reviewer.avatar_url))) FILTER (WHERE (r.id IS NOT NULL)), '[]'::jsonb) AS service_reviews,
            COALESCE(avg(r.rating), (0)::numeric) AS rating,
            count(DISTINCT r.id) AS reviews_count
           FROM (((public.tasker_services ts_1
             LEFT JOIN public.bookings b ON (((b.tasker_profile_id = ts_1.tasker_profile_id) AND (b.category_id = ts_1.category_id))))
             LEFT JOIN public.reviews r ON ((r.booking_id = b.id)))
             LEFT JOIN public.profiles reviewer ON ((reviewer.id = r.reviewer_id)))
          GROUP BY ts_1.id
        ), service_jobs AS (
         SELECT ts_1.id AS tasker_service_id,
            count(DISTINCT b.id) FILTER (WHERE (b.status = 'completed'::text)) AS jobs_done
           FROM (public.tasker_services ts_1
             LEFT JOIN public.bookings b ON (((b.tasker_profile_id = ts_1.tasker_profile_id) AND (b.category_id = ts_1.category_id))))
          GROUP BY ts_1.id
        )
 SELECT ts.id AS service_id,
    ts.tasker_profile_id,
    tp.user_id AS tasker_user_id,
    jsonb_build_object('id', c.id, 'name', c.name, 'slug', c.slug, 'description', c.description) AS category,
    jsonb_build_object('id', tp.id, 'user_id', tp.user_id, 'full_name', p.full_name, 'profile_image', p.avatar_url, 'bio', tp.bio, 'experience_years', tp.experience_years, 'average_rating', tp.average_rating, 'total_reviews', tp.total_reviews, 'total_jobs', tp.total_jobs, 'is_verified', tp.is_verified, 'is_domo_diamond', tp.is_domo_diamond) AS tasker,
    COALESCE(ss.specialized_subcategories, '[]'::jsonb) AS specialized_subcategories,
    COALESCE(ts.images, '{}'::text[]) AS images,
    ts.experience,
    ts.knowledge,
    COALESCE(ts.working_areas, '{}'::text[]) AS working_areas,
    COALESCE(o.offerings, '[]'::jsonb) AS offerings,
    COALESCE(sj.jobs_done, (0)::bigint) AS jobs_done,
    COALESCE(sr.rating, (0)::numeric) AS rating,
    COALESCE(sr.reviews_count, (0)::bigint) AS reviews_count,
    COALESCE(sr.service_reviews, '[]'::jsonb) AS service_reviews,
    ts.is_active,
    ts.created_at,
    ts.updated_at
   FROM (((((((public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
     JOIN public.profiles p ON ((p.id = tp.user_id)))
     JOIN public.categories c ON ((c.id = ts.category_id)))
     LEFT JOIN specialized_subcategories ss ON ((ss.tasker_service_id = ts.id)))
     LEFT JOIN offerings o ON ((o.tasker_service_id = ts.id)))
     LEFT JOIN service_reviews sr ON ((sr.tasker_service_id = ts.id)))
     LEFT JOIN service_jobs sj ON ((sj.tasker_service_id = ts.id)))
  WHERE (ts.is_active = true);
create or replace view "public"."taskers_by_category" as  WITH subcategory_tags AS (
         SELECT tss.tasker_service_id,
            COALESCE(array_agg(DISTINCT s.name) FILTER (WHERE (s.id IS NOT NULL)), '{}'::text[]) AS specialized_subcategory_tags
           FROM (public.tasker_service_subcategories tss
             JOIN public.subcategories s ON ((s.id = tss.subcategory_id)))
          GROUP BY tss.tasker_service_id
        ), offering_stats AS (
         SELECT tso.tasker_service_id,
            min(tso.price) AS starting_price
           FROM public.tasker_service_offerings tso
          WHERE (tso.is_active = true)
          GROUP BY tso.tasker_service_id
        ), service_stats AS (
         SELECT ts_1.id AS tasker_service_id,
            count(DISTINCT b.id) FILTER (WHERE (b.status = 'completed'::text)) AS completed_jobs_count,
            COALESCE(avg(r.rating), (0)::numeric) AS rating,
            count(DISTINCT r.id) AS reviews_count
           FROM ((public.tasker_services ts_1
             LEFT JOIN public.bookings b ON (((b.tasker_profile_id = ts_1.tasker_profile_id) AND (b.category_id = ts_1.category_id))))
             LEFT JOIN public.reviews r ON ((r.booking_id = b.id)))
          GROUP BY ts_1.id
        )
 SELECT ts.id AS service_id,
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
    COALESCE(ss.rating, (0)::numeric) AS rating,
    COALESCE(ss.reviews_count, (0)::bigint) AS reviews_count,
    COALESCE(ss.completed_jobs_count, (0)::bigint) AS completed_jobs_count,
    COALESCE(st.specialized_subcategory_tags, '{}'::text[]) AS specialized_subcategory_tags,
    os.starting_price,
        CASE
            WHEN (array_length(ts.images, 1) > 0) THEN ts.images[1]
            ELSE NULL::text
        END AS cover_image
   FROM ((((((public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
     JOIN public.profiles p ON ((p.id = tp.user_id)))
     JOIN public.categories c ON ((c.id = ts.category_id)))
     LEFT JOIN subcategory_tags st ON ((st.tasker_service_id = ts.id)))
     LEFT JOIN offering_stats os ON ((os.tasker_service_id = ts.id)))
     LEFT JOIN service_stats ss ON ((ss.tasker_service_id = ts.id)))
  WHERE (ts.is_active = true);
grant delete on table "public"."addresses" to "anon";
grant insert on table "public"."addresses" to "anon";
grant references on table "public"."addresses" to "anon";
grant select on table "public"."addresses" to "anon";
grant trigger on table "public"."addresses" to "anon";
grant truncate on table "public"."addresses" to "anon";
grant update on table "public"."addresses" to "anon";
grant delete on table "public"."addresses" to "authenticated";
grant insert on table "public"."addresses" to "authenticated";
grant references on table "public"."addresses" to "authenticated";
grant select on table "public"."addresses" to "authenticated";
grant trigger on table "public"."addresses" to "authenticated";
grant truncate on table "public"."addresses" to "authenticated";
grant update on table "public"."addresses" to "authenticated";
grant delete on table "public"."addresses" to "service_role";
grant insert on table "public"."addresses" to "service_role";
grant references on table "public"."addresses" to "service_role";
grant select on table "public"."addresses" to "service_role";
grant trigger on table "public"."addresses" to "service_role";
grant truncate on table "public"."addresses" to "service_role";
grant update on table "public"."addresses" to "service_role";
grant delete on table "public"."booking_payments" to "anon";
grant insert on table "public"."booking_payments" to "anon";
grant references on table "public"."booking_payments" to "anon";
grant select on table "public"."booking_payments" to "anon";
grant trigger on table "public"."booking_payments" to "anon";
grant truncate on table "public"."booking_payments" to "anon";
grant update on table "public"."booking_payments" to "anon";
grant delete on table "public"."booking_payments" to "authenticated";
grant insert on table "public"."booking_payments" to "authenticated";
grant references on table "public"."booking_payments" to "authenticated";
grant select on table "public"."booking_payments" to "authenticated";
grant trigger on table "public"."booking_payments" to "authenticated";
grant truncate on table "public"."booking_payments" to "authenticated";
grant update on table "public"."booking_payments" to "authenticated";
grant delete on table "public"."booking_payments" to "service_role";
grant insert on table "public"."booking_payments" to "service_role";
grant references on table "public"."booking_payments" to "service_role";
grant select on table "public"."booking_payments" to "service_role";
grant trigger on table "public"."booking_payments" to "service_role";
grant truncate on table "public"."booking_payments" to "service_role";
grant update on table "public"."booking_payments" to "service_role";
grant delete on table "public"."bookings" to "anon";
grant insert on table "public"."bookings" to "anon";
grant references on table "public"."bookings" to "anon";
grant select on table "public"."bookings" to "anon";
grant trigger on table "public"."bookings" to "anon";
grant truncate on table "public"."bookings" to "anon";
grant update on table "public"."bookings" to "anon";
grant delete on table "public"."bookings" to "authenticated";
grant insert on table "public"."bookings" to "authenticated";
grant references on table "public"."bookings" to "authenticated";
grant select on table "public"."bookings" to "authenticated";
grant trigger on table "public"."bookings" to "authenticated";
grant truncate on table "public"."bookings" to "authenticated";
grant update on table "public"."bookings" to "authenticated";
grant delete on table "public"."bookings" to "service_role";
grant insert on table "public"."bookings" to "service_role";
grant references on table "public"."bookings" to "service_role";
grant select on table "public"."bookings" to "service_role";
grant trigger on table "public"."bookings" to "service_role";
grant truncate on table "public"."bookings" to "service_role";
grant update on table "public"."bookings" to "service_role";
grant delete on table "public"."categories" to "anon";
grant insert on table "public"."categories" to "anon";
grant references on table "public"."categories" to "anon";
grant select on table "public"."categories" to "anon";
grant trigger on table "public"."categories" to "anon";
grant truncate on table "public"."categories" to "anon";
grant update on table "public"."categories" to "anon";
grant delete on table "public"."categories" to "authenticated";
grant insert on table "public"."categories" to "authenticated";
grant references on table "public"."categories" to "authenticated";
grant select on table "public"."categories" to "authenticated";
grant trigger on table "public"."categories" to "authenticated";
grant truncate on table "public"."categories" to "authenticated";
grant update on table "public"."categories" to "authenticated";
grant delete on table "public"."categories" to "service_role";
grant insert on table "public"."categories" to "service_role";
grant references on table "public"."categories" to "service_role";
grant select on table "public"."categories" to "service_role";
grant trigger on table "public"."categories" to "service_role";
grant truncate on table "public"."categories" to "service_role";
grant update on table "public"."categories" to "service_role";
grant delete on table "public"."favorite_taskers" to "anon";
grant insert on table "public"."favorite_taskers" to "anon";
grant references on table "public"."favorite_taskers" to "anon";
grant select on table "public"."favorite_taskers" to "anon";
grant trigger on table "public"."favorite_taskers" to "anon";
grant truncate on table "public"."favorite_taskers" to "anon";
grant update on table "public"."favorite_taskers" to "anon";
grant delete on table "public"."favorite_taskers" to "authenticated";
grant insert on table "public"."favorite_taskers" to "authenticated";
grant references on table "public"."favorite_taskers" to "authenticated";
grant select on table "public"."favorite_taskers" to "authenticated";
grant trigger on table "public"."favorite_taskers" to "authenticated";
grant truncate on table "public"."favorite_taskers" to "authenticated";
grant update on table "public"."favorite_taskers" to "authenticated";
grant delete on table "public"."favorite_taskers" to "service_role";
grant insert on table "public"."favorite_taskers" to "service_role";
grant references on table "public"."favorite_taskers" to "service_role";
grant select on table "public"."favorite_taskers" to "service_role";
grant trigger on table "public"."favorite_taskers" to "service_role";
grant truncate on table "public"."favorite_taskers" to "service_role";
grant update on table "public"."favorite_taskers" to "service_role";
grant delete on table "public"."payment_methods" to "anon";
grant insert on table "public"."payment_methods" to "anon";
grant references on table "public"."payment_methods" to "anon";
grant select on table "public"."payment_methods" to "anon";
grant trigger on table "public"."payment_methods" to "anon";
grant truncate on table "public"."payment_methods" to "anon";
grant update on table "public"."payment_methods" to "anon";
grant delete on table "public"."payment_methods" to "authenticated";
grant insert on table "public"."payment_methods" to "authenticated";
grant references on table "public"."payment_methods" to "authenticated";
grant select on table "public"."payment_methods" to "authenticated";
grant trigger on table "public"."payment_methods" to "authenticated";
grant truncate on table "public"."payment_methods" to "authenticated";
grant update on table "public"."payment_methods" to "authenticated";
grant delete on table "public"."payment_methods" to "service_role";
grant insert on table "public"."payment_methods" to "service_role";
grant references on table "public"."payment_methods" to "service_role";
grant select on table "public"."payment_methods" to "service_role";
grant trigger on table "public"."payment_methods" to "service_role";
grant truncate on table "public"."payment_methods" to "service_role";
grant update on table "public"."payment_methods" to "service_role";
grant delete on table "public"."profiles" to "anon";
grant insert on table "public"."profiles" to "anon";
grant references on table "public"."profiles" to "anon";
grant select on table "public"."profiles" to "anon";
grant trigger on table "public"."profiles" to "anon";
grant truncate on table "public"."profiles" to "anon";
grant update on table "public"."profiles" to "anon";
grant delete on table "public"."profiles" to "authenticated";
grant insert on table "public"."profiles" to "authenticated";
grant references on table "public"."profiles" to "authenticated";
grant select on table "public"."profiles" to "authenticated";
grant trigger on table "public"."profiles" to "authenticated";
grant truncate on table "public"."profiles" to "authenticated";
grant update on table "public"."profiles" to "authenticated";
grant delete on table "public"."profiles" to "service_role";
grant insert on table "public"."profiles" to "service_role";
grant references on table "public"."profiles" to "service_role";
grant select on table "public"."profiles" to "service_role";
grant trigger on table "public"."profiles" to "service_role";
grant truncate on table "public"."profiles" to "service_role";
grant update on table "public"."profiles" to "service_role";
grant delete on table "public"."reviews" to "anon";
grant insert on table "public"."reviews" to "anon";
grant references on table "public"."reviews" to "anon";
grant select on table "public"."reviews" to "anon";
grant trigger on table "public"."reviews" to "anon";
grant truncate on table "public"."reviews" to "anon";
grant update on table "public"."reviews" to "anon";
grant delete on table "public"."reviews" to "authenticated";
grant insert on table "public"."reviews" to "authenticated";
grant references on table "public"."reviews" to "authenticated";
grant select on table "public"."reviews" to "authenticated";
grant trigger on table "public"."reviews" to "authenticated";
grant truncate on table "public"."reviews" to "authenticated";
grant update on table "public"."reviews" to "authenticated";
grant delete on table "public"."reviews" to "service_role";
grant insert on table "public"."reviews" to "service_role";
grant references on table "public"."reviews" to "service_role";
grant select on table "public"."reviews" to "service_role";
grant trigger on table "public"."reviews" to "service_role";
grant truncate on table "public"."reviews" to "service_role";
grant update on table "public"."reviews" to "service_role";
grant delete on table "public"."subcategories" to "anon";
grant insert on table "public"."subcategories" to "anon";
grant references on table "public"."subcategories" to "anon";
grant select on table "public"."subcategories" to "anon";
grant trigger on table "public"."subcategories" to "anon";
grant truncate on table "public"."subcategories" to "anon";
grant update on table "public"."subcategories" to "anon";
grant delete on table "public"."subcategories" to "authenticated";
grant insert on table "public"."subcategories" to "authenticated";
grant references on table "public"."subcategories" to "authenticated";
grant select on table "public"."subcategories" to "authenticated";
grant trigger on table "public"."subcategories" to "authenticated";
grant truncate on table "public"."subcategories" to "authenticated";
grant update on table "public"."subcategories" to "authenticated";
grant delete on table "public"."subcategories" to "service_role";
grant insert on table "public"."subcategories" to "service_role";
grant references on table "public"."subcategories" to "service_role";
grant select on table "public"."subcategories" to "service_role";
grant trigger on table "public"."subcategories" to "service_role";
grant truncate on table "public"."subcategories" to "service_role";
grant update on table "public"."subcategories" to "service_role";
grant delete on table "public"."tasker_profiles" to "anon";
grant insert on table "public"."tasker_profiles" to "anon";
grant references on table "public"."tasker_profiles" to "anon";
grant select on table "public"."tasker_profiles" to "anon";
grant trigger on table "public"."tasker_profiles" to "anon";
grant truncate on table "public"."tasker_profiles" to "anon";
grant update on table "public"."tasker_profiles" to "anon";
grant delete on table "public"."tasker_profiles" to "authenticated";
grant insert on table "public"."tasker_profiles" to "authenticated";
grant references on table "public"."tasker_profiles" to "authenticated";
grant select on table "public"."tasker_profiles" to "authenticated";
grant trigger on table "public"."tasker_profiles" to "authenticated";
grant truncate on table "public"."tasker_profiles" to "authenticated";
grant update on table "public"."tasker_profiles" to "authenticated";
grant delete on table "public"."tasker_profiles" to "service_role";
grant insert on table "public"."tasker_profiles" to "service_role";
grant references on table "public"."tasker_profiles" to "service_role";
grant select on table "public"."tasker_profiles" to "service_role";
grant trigger on table "public"."tasker_profiles" to "service_role";
grant truncate on table "public"."tasker_profiles" to "service_role";
grant update on table "public"."tasker_profiles" to "service_role";
grant delete on table "public"."tasker_service_offerings" to "anon";
grant insert on table "public"."tasker_service_offerings" to "anon";
grant references on table "public"."tasker_service_offerings" to "anon";
grant select on table "public"."tasker_service_offerings" to "anon";
grant trigger on table "public"."tasker_service_offerings" to "anon";
grant truncate on table "public"."tasker_service_offerings" to "anon";
grant update on table "public"."tasker_service_offerings" to "anon";
grant delete on table "public"."tasker_service_offerings" to "authenticated";
grant insert on table "public"."tasker_service_offerings" to "authenticated";
grant references on table "public"."tasker_service_offerings" to "authenticated";
grant select on table "public"."tasker_service_offerings" to "authenticated";
grant trigger on table "public"."tasker_service_offerings" to "authenticated";
grant truncate on table "public"."tasker_service_offerings" to "authenticated";
grant update on table "public"."tasker_service_offerings" to "authenticated";
grant delete on table "public"."tasker_service_offerings" to "service_role";
grant insert on table "public"."tasker_service_offerings" to "service_role";
grant references on table "public"."tasker_service_offerings" to "service_role";
grant select on table "public"."tasker_service_offerings" to "service_role";
grant trigger on table "public"."tasker_service_offerings" to "service_role";
grant truncate on table "public"."tasker_service_offerings" to "service_role";
grant update on table "public"."tasker_service_offerings" to "service_role";
grant delete on table "public"."tasker_service_subcategories" to "anon";
grant insert on table "public"."tasker_service_subcategories" to "anon";
grant references on table "public"."tasker_service_subcategories" to "anon";
grant select on table "public"."tasker_service_subcategories" to "anon";
grant trigger on table "public"."tasker_service_subcategories" to "anon";
grant truncate on table "public"."tasker_service_subcategories" to "anon";
grant update on table "public"."tasker_service_subcategories" to "anon";
grant delete on table "public"."tasker_service_subcategories" to "authenticated";
grant insert on table "public"."tasker_service_subcategories" to "authenticated";
grant references on table "public"."tasker_service_subcategories" to "authenticated";
grant select on table "public"."tasker_service_subcategories" to "authenticated";
grant trigger on table "public"."tasker_service_subcategories" to "authenticated";
grant truncate on table "public"."tasker_service_subcategories" to "authenticated";
grant update on table "public"."tasker_service_subcategories" to "authenticated";
grant delete on table "public"."tasker_service_subcategories" to "service_role";
grant insert on table "public"."tasker_service_subcategories" to "service_role";
grant references on table "public"."tasker_service_subcategories" to "service_role";
grant select on table "public"."tasker_service_subcategories" to "service_role";
grant trigger on table "public"."tasker_service_subcategories" to "service_role";
grant truncate on table "public"."tasker_service_subcategories" to "service_role";
grant update on table "public"."tasker_service_subcategories" to "service_role";
grant delete on table "public"."tasker_services" to "anon";
grant insert on table "public"."tasker_services" to "anon";
grant references on table "public"."tasker_services" to "anon";
grant select on table "public"."tasker_services" to "anon";
grant trigger on table "public"."tasker_services" to "anon";
grant truncate on table "public"."tasker_services" to "anon";
grant update on table "public"."tasker_services" to "anon";
grant delete on table "public"."tasker_services" to "authenticated";
grant insert on table "public"."tasker_services" to "authenticated";
grant references on table "public"."tasker_services" to "authenticated";
grant select on table "public"."tasker_services" to "authenticated";
grant trigger on table "public"."tasker_services" to "authenticated";
grant truncate on table "public"."tasker_services" to "authenticated";
grant update on table "public"."tasker_services" to "authenticated";
grant delete on table "public"."tasker_services" to "service_role";
grant insert on table "public"."tasker_services" to "service_role";
grant references on table "public"."tasker_services" to "service_role";
grant select on table "public"."tasker_services" to "service_role";
grant trigger on table "public"."tasker_services" to "service_role";
grant truncate on table "public"."tasker_services" to "service_role";
grant update on table "public"."tasker_services" to "service_role";
grant delete on table "public"."tasker_subcategories" to "anon";
grant insert on table "public"."tasker_subcategories" to "anon";
grant references on table "public"."tasker_subcategories" to "anon";
grant select on table "public"."tasker_subcategories" to "anon";
grant trigger on table "public"."tasker_subcategories" to "anon";
grant truncate on table "public"."tasker_subcategories" to "anon";
grant update on table "public"."tasker_subcategories" to "anon";
grant delete on table "public"."tasker_subcategories" to "authenticated";
grant insert on table "public"."tasker_subcategories" to "authenticated";
grant references on table "public"."tasker_subcategories" to "authenticated";
grant select on table "public"."tasker_subcategories" to "authenticated";
grant trigger on table "public"."tasker_subcategories" to "authenticated";
grant truncate on table "public"."tasker_subcategories" to "authenticated";
grant update on table "public"."tasker_subcategories" to "authenticated";
grant delete on table "public"."tasker_subcategories" to "service_role";
grant insert on table "public"."tasker_subcategories" to "service_role";
grant references on table "public"."tasker_subcategories" to "service_role";
grant select on table "public"."tasker_subcategories" to "service_role";
grant trigger on table "public"."tasker_subcategories" to "service_role";
grant truncate on table "public"."tasker_subcategories" to "service_role";
grant update on table "public"."tasker_subcategories" to "service_role";
create policy "addresses_delete_own"
  on "public"."addresses"
  as permissive
  for delete
  to authenticated
using ((user_id = auth.uid()));
create policy "addresses_insert_own"
  on "public"."addresses"
  as permissive
  for insert
  to authenticated
with check ((user_id = auth.uid()));
create policy "addresses_select_own"
  on "public"."addresses"
  as permissive
  for select
  to authenticated
using ((user_id = auth.uid()));
create policy "addresses_update_own"
  on "public"."addresses"
  as permissive
  for update
  to authenticated
using ((user_id = auth.uid()))
with check ((user_id = auth.uid()));
create policy "payments_delete_none"
  on "public"."booking_payments"
  as permissive
  for delete
  to authenticated
using (false);
create policy "payments_insert_none"
  on "public"."booking_payments"
  as permissive
  for insert
  to authenticated
with check (false);
create policy "payments_select_participants"
  on "public"."booking_payments"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.bookings b
     LEFT JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
  WHERE ((b.id = booking_payments.booking_id) AND ((b.client_id = auth.uid()) OR (tp.user_id = auth.uid()))))));
create policy "payments_update_none"
  on "public"."booking_payments"
  as permissive
  for update
  to authenticated
using (false)
with check (false);
create policy "bookings_delete_client_pending"
  on "public"."bookings"
  as permissive
  for delete
  to authenticated
using (((auth.uid() IS NOT NULL) AND (client_id = auth.uid()) AND (status = 'pending'::text)));
create policy "bookings_insert_client"
  on "public"."bookings"
  as permissive
  for insert
  to authenticated
with check (((auth.uid() IS NOT NULL) AND (client_id = auth.uid())));
create policy "bookings_select_participants"
  on "public"."bookings"
  as permissive
  for select
  to authenticated
using (((auth.uid() IS NOT NULL) AND ((client_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = bookings.tasker_profile_id) AND (tp.user_id = auth.uid())))))));
create policy "bookings_update_participants"
  on "public"."bookings"
  as permissive
  for update
  to authenticated
using (((auth.uid() IS NOT NULL) AND ((client_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = bookings.tasker_profile_id) AND (tp.user_id = auth.uid())))))))
with check (((auth.uid() IS NOT NULL) AND ((client_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = bookings.tasker_profile_id) AND (tp.user_id = auth.uid())))))));
create policy "categories_select_public"
  on "public"."categories"
  as permissive
  for select
  to anon, authenticated
using ((is_active = true));
create policy "favorite_taskers_delete_own"
  on "public"."favorite_taskers"
  as permissive
  for delete
  to authenticated
using ((client_id = auth.uid()));
create policy "favorite_taskers_insert_own"
  on "public"."favorite_taskers"
  as permissive
  for insert
  to authenticated
with check ((client_id = auth.uid()));
create policy "favorite_taskers_select_own"
  on "public"."favorite_taskers"
  as permissive
  for select
  to authenticated
using ((client_id = auth.uid()));
create policy "payment_methods_delete_own"
  on "public"."payment_methods"
  as permissive
  for delete
  to authenticated
using ((user_id = auth.uid()));
create policy "payment_methods_insert_own"
  on "public"."payment_methods"
  as permissive
  for insert
  to authenticated
with check ((user_id = auth.uid()));
create policy "payment_methods_select_own"
  on "public"."payment_methods"
  as permissive
  for select
  to authenticated
using ((user_id = auth.uid()));
create policy "payment_methods_update_own"
  on "public"."payment_methods"
  as permissive
  for update
  to authenticated
using ((user_id = auth.uid()))
with check ((user_id = auth.uid()));
create policy "Enable read access for all users"
  on "public"."profiles"
  as permissive
  for select
  to public
using (true);
create policy "profiles_insert_own"
  on "public"."profiles"
  as permissive
  for insert
  to authenticated
with check (((auth.uid() IS NOT NULL) AND (auth.uid() = id)));
create policy "profiles_update_own"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using (((auth.uid() IS NOT NULL) AND (auth.uid() = id)))
with check (((auth.uid() IS NOT NULL) AND (auth.uid() = id)));
create policy "reviews_delete_reviewer"
  on "public"."reviews"
  as permissive
  for delete
  to authenticated
using ((reviewer_id = auth.uid()));
create policy "reviews_insert_booking_client_completed"
  on "public"."reviews"
  as permissive
  for insert
  to authenticated
with check (((reviewer_id = auth.uid()) AND ((EXISTS ( SELECT 1
   FROM (public.bookings b
     JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
  WHERE ((b.id = reviews.booking_id) AND (b.client_id = auth.uid()) AND (b.status = 'completed'::text) AND (reviews.reviewed_user_id = tp.user_id)))) OR (EXISTS ( SELECT 1
   FROM (public.bookings b
     JOIN public.tasker_profiles tp ON ((tp.id = b.tasker_profile_id)))
  WHERE ((b.id = reviews.booking_id) AND (tp.user_id = auth.uid()) AND (b.status = 'completed'::text) AND (reviews.reviewed_user_id = b.client_id)))))));
create policy "reviews_select_public"
  on "public"."reviews"
  as permissive
  for select
  to anon, authenticated
using (true);
create policy "reviews_update_reviewer"
  on "public"."reviews"
  as permissive
  for update
  to authenticated
using ((reviewer_id = auth.uid()))
with check ((reviewer_id = auth.uid()));
create policy "subcategories_select_public"
  on "public"."subcategories"
  as permissive
  for select
  to anon, authenticated
using ((is_active = true));
create policy "Enable read access for all users"
  on "public"."tasker_profiles"
  as permissive
  for select
  to public
using (true);
create policy "tasker_profiles_delete_own"
  on "public"."tasker_profiles"
  as permissive
  for delete
  to authenticated
using (((auth.uid() IS NOT NULL) AND (user_id = auth.uid())));
create policy "tasker_profiles_insert_own"
  on "public"."tasker_profiles"
  as permissive
  for insert
  to authenticated
with check (((auth.uid() IS NOT NULL) AND (user_id = auth.uid())));
create policy "tasker_profiles_update_own"
  on "public"."tasker_profiles"
  as permissive
  for update
  to authenticated
using (((auth.uid() IS NOT NULL) AND (user_id = auth.uid())))
with check (((auth.uid() IS NOT NULL) AND (user_id = auth.uid())));
create policy "tasker_service_offerings_delete_own"
  on "public"."tasker_service_offerings"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_offerings.tasker_service_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_service_offerings_insert_own"
  on "public"."tasker_service_offerings"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_offerings.tasker_service_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_service_offerings_select_public"
  on "public"."tasker_service_offerings"
  as permissive
  for select
  to anon, authenticated
using (((is_active = true) AND (EXISTS ( SELECT 1
   FROM public.tasker_services ts
  WHERE ((ts.id = tasker_service_offerings.tasker_service_id) AND (ts.is_active = true))))));
create policy "tasker_service_offerings_update_own"
  on "public"."tasker_service_offerings"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_offerings.tasker_service_id) AND (tp.user_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_offerings.tasker_service_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_service_subcategories_delete_own"
  on "public"."tasker_service_subcategories"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_subcategories.tasker_service_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_service_subcategories_insert_own"
  on "public"."tasker_service_subcategories"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM (public.tasker_services ts
     JOIN public.tasker_profiles tp ON ((tp.id = ts.tasker_profile_id)))
  WHERE ((ts.id = tasker_service_subcategories.tasker_service_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_service_subcategories_select_public"
  on "public"."tasker_service_subcategories"
  as permissive
  for select
  to anon, authenticated
using ((EXISTS ( SELECT 1
   FROM public.tasker_services ts
  WHERE ((ts.id = tasker_service_subcategories.tasker_service_id) AND (ts.is_active = true)))));
create policy "tasker_services_delete_own"
  on "public"."tasker_services"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_services.tasker_profile_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_services_insert_own"
  on "public"."tasker_services"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_services.tasker_profile_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_services_select_public"
  on "public"."tasker_services"
  as permissive
  for select
  to anon, authenticated
using ((is_active = true));
create policy "tasker_services_update_own"
  on "public"."tasker_services"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_services.tasker_profile_id) AND (tp.user_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_services.tasker_profile_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_subcategories_delete_own"
  on "public"."tasker_subcategories"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_subcategories.tasker_profile_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_subcategories_insert_own"
  on "public"."tasker_subcategories"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_subcategories.tasker_profile_id) AND (tp.user_id = auth.uid())))));
create policy "tasker_subcategories_select_public"
  on "public"."tasker_subcategories"
  as permissive
  for select
  to anon, authenticated
using ((is_active = true));
create policy "tasker_subcategories_update_own"
  on "public"."tasker_subcategories"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_subcategories.tasker_profile_id) AND (tp.user_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM public.tasker_profiles tp
  WHERE ((tp.id = tasker_subcategories.tasker_profile_id) AND (tp.user_id = auth.uid())))));
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
create policy "Anyone can upload an avatar."
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'avatars'::text));
create policy "Avatar images are publicly accessible."
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'avatars'::text));
