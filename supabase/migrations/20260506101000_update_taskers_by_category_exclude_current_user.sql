create or replace view "public"."taskers_by_category" as
with subcategory_tags as (
  select
    tss.tasker_service_id,
    coalesce(array_agg(distinct s.name) filter (where (s.id is not null)), '{}'::text[]) as specialized_subcategory_tags
  from public.tasker_service_subcategories tss
  join public.subcategories s on s.id = tss.subcategory_id
  group by tss.tasker_service_id
), offering_stats as (
  select
    tso.tasker_service_id,
    min(tso.price) as starting_price
  from public.tasker_service_offerings tso
  where tso.is_active = true
  group by tso.tasker_service_id
), service_stats as (
  select
    ts_1.id as tasker_service_id,
    count(distinct b.id) filter (where (b.status = 'completed'::text)) as completed_jobs_count,
    coalesce(avg(r.rating), 0::numeric) as rating,
    count(distinct r.id) as reviews_count
  from public.tasker_services ts_1
  left join public.bookings b
    on b.tasker_profile_id = ts_1.tasker_profile_id
   and b.category_id = ts_1.category_id
  left join public.reviews r on r.booking_id = b.id
  group by ts_1.id
)
select
  ts.id as service_id,
  ts.category_id,
  c.name as category_name,
  c.slug as category_icon_name,
  ts.tasker_profile_id,
  tp.user_id as tasker_user_id,
  p.full_name as tasker_name,
  p.avatar_url as tasker_picture,
  tp.is_verified as is_tasker_verified,
  tp.is_domo_diamond,
  ts.is_active,
  coalesce(ss.rating, 0::numeric) as rating,
  coalesce(ss.reviews_count, 0::bigint) as reviews_count,
  coalesce(ss.completed_jobs_count, 0::bigint) as completed_jobs_count,
  coalesce(st.specialized_subcategory_tags, '{}'::text[]) as specialized_subcategory_tags,
  os.starting_price,
  case
    when array_length(ts.images, 1) > 0 then ts.images[1]
    else null::text
  end as cover_image
from public.tasker_services ts
join public.tasker_profiles tp on tp.id = ts.tasker_profile_id
join public.profiles p on p.id = tp.user_id
join public.categories c on c.id = ts.category_id
left join subcategory_tags st on st.tasker_service_id = ts.id
left join offering_stats os on os.tasker_service_id = ts.id
left join service_stats ss on ss.tasker_service_id = ts.id
where ts.is_active = true
  and (auth.uid() is null or tp.user_id <> auth.uid());
