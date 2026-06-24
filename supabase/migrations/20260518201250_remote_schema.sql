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
