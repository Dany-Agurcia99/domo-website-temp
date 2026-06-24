alter table "public"."tasker_service_offerings"
add column if not exists "image_url" text;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
	(
		'tasker-service-images',
		'tasker-service-images',
		true,
		52428800,
		array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
	),
	(
		'tasker-offering-images',
		'tasker-offering-images',
		true,
		52428800,
		array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
	)
on conflict (id) do update
set
	public = excluded.public,
	file_size_limit = excluded.file_size_limit,
	allowed_mime_types = excluded.allowed_mime_types;
do $$
begin
	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_service_images_select_public'
	) then
		create policy "tasker_service_images_select_public"
		on "storage"."objects"
		as permissive
		for select
		to public
		using ((bucket_id = 'tasker-service-images'::text));
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_service_images_insert_authenticated'
	) then
		create policy "tasker_service_images_insert_authenticated"
		on "storage"."objects"
		as permissive
		for insert
		to authenticated
		with check (
			(bucket_id = 'tasker-service-images'::text)
			and (auth.role() = 'authenticated'::text)
		);
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_service_images_update_owner'
	) then
		create policy "tasker_service_images_update_owner"
		on "storage"."objects"
		as permissive
		for update
		to authenticated
		using (
			(bucket_id = 'tasker-service-images'::text)
			and (owner = auth.uid())
		)
		with check (
			(bucket_id = 'tasker-service-images'::text)
			and (owner = auth.uid())
		);
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_service_images_delete_owner'
	) then
		create policy "tasker_service_images_delete_owner"
		on "storage"."objects"
		as permissive
		for delete
		to authenticated
		using (
			(bucket_id = 'tasker-service-images'::text)
			and (owner = auth.uid())
		);
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_offering_images_select_public'
	) then
		create policy "tasker_offering_images_select_public"
		on "storage"."objects"
		as permissive
		for select
		to public
		using ((bucket_id = 'tasker-offering-images'::text));
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_offering_images_insert_authenticated'
	) then
		create policy "tasker_offering_images_insert_authenticated"
		on "storage"."objects"
		as permissive
		for insert
		to authenticated
		with check (
			(bucket_id = 'tasker-offering-images'::text)
			and (auth.role() = 'authenticated'::text)
		);
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_offering_images_update_owner'
	) then
		create policy "tasker_offering_images_update_owner"
		on "storage"."objects"
		as permissive
		for update
		to authenticated
		using (
			(bucket_id = 'tasker-offering-images'::text)
			and (owner = auth.uid())
		)
		with check (
			(bucket_id = 'tasker-offering-images'::text)
			and (owner = auth.uid())
		);
	end if;

	if not exists (
		select 1
		from pg_policies
		where schemaname = 'storage'
			and tablename = 'objects'
			and policyname = 'tasker_offering_images_delete_owner'
	) then
		create policy "tasker_offering_images_delete_owner"
		on "storage"."objects"
		as permissive
		for delete
		to authenticated
		using (
			(bucket_id = 'tasker-offering-images'::text)
			and (owner = auth.uid())
		);
	end if;
end;
$$;
create or replace view "public"."service_details" as
select
	ts.id,
	ts.tasker_profile_id,
	tp.user_id as tasker_user_id,
	jsonb_build_object(
		'id', c.id,
		'name', c.name,
		'slug', c.slug,
		'description', c.description
	) as category,
	coalesce(
		jsonb_agg(
			distinct jsonb_build_object(
				'id', s.id,
				'category_id', s.category_id,
				'name', s.name,
				'slug', s.slug,
				'icon_key', s.icon_key,
				'description', s.description,
				'jobsDone', coalesce(tss.jobs_done, 0)
			)
		) filter (where (s.id is not null)),
		'[]'::jsonb
	) as specialized_subcategories,
	ts.images,
	ts.experience,
	ts.knowledge,
	ts.working_areas,
	coalesce(
		jsonb_agg(
			distinct jsonb_build_object(
				'id', tso.id,
				'name', tso.name,
				'description', tso.description,
				'price', tso.price,
				'estimated_time', tso.estimated_time,
				'image_url', tso.image_url,
				'is_active', tso.is_active
			)
		) filter (where (tso.id is not null)),
		'[]'::jsonb
	) as offerings,
	count(distinct b.id) filter (where (b.status = 'completed'::text)) as jobs_done,
	coalesce(
		jsonb_agg(
			distinct jsonb_build_object(
				'id', r.id,
				'rating', r.rating,
				'comment', r.comment,
				'created_at', r.created_at
			)
		) filter (where (r.id is not null)),
		'[]'::jsonb
	) as service_reviews,
	ts.is_active
from ((((((("public"."tasker_services" ts
	join "public"."tasker_profiles" tp on ((tp.id = ts.tasker_profile_id)))
	join "public"."categories" c on ((c.id = ts.category_id)))
	left join "public"."tasker_service_subcategories" tss on ((tss.tasker_service_id = ts.id)))
	left join "public"."subcategories" s on ((s.id = tss.subcategory_id)))
	left join "public"."tasker_service_offerings" tso on ((tso.tasker_service_id = ts.id)))
	left join "public"."bookings" b on (((b.tasker_profile_id = ts.tasker_profile_id) and (b.category_id = ts.category_id))))
	left join "public"."reviews" r on ((r.booking_id = b.id)))
group by
	ts.id,
	ts.tasker_profile_id,
	tp.user_id,
	c.id,
	c.name,
	c.slug,
	c.description,
	ts.images,
	ts.experience,
	ts.knowledge,
	ts.working_areas,
	ts.is_active;
create or replace view "public"."tasker_service_info" as
with specialized_subcategories as (
	select
		tss.tasker_service_id,
		coalesce(
			jsonb_agg(
				distinct jsonb_build_object(
					'id', s.id,
					'category_id', s.category_id,
					'name', s.name,
					'slug', s.slug,
					'icon_key', s.icon_key,
					'description', s.description,
					'jobsDone', coalesce(tss.jobs_done, 0)
				)
			) filter (where (s.id is not null)),
			'[]'::jsonb
		) as specialized_subcategories
	from ("public"."tasker_service_subcategories" tss
		join "public"."subcategories" s on ((s.id = tss.subcategory_id)))
	group by tss.tasker_service_id
), offerings as (
	select
		tso.tasker_service_id,
		coalesce(
			jsonb_agg(
				jsonb_build_object(
					'id', tso.id,
					'name', tso.name,
					'description', tso.description,
					'price', tso.price,
					'estimated_time', tso.estimated_time,
					'image_url', tso.image_url,
					'is_active', tso.is_active
				)
				order by tso.price
			) filter (where (tso.id is not null)),
			'[]'::jsonb
		) as offerings
	from "public"."tasker_service_offerings" tso
	where (tso.is_active = true)
	group by tso.tasker_service_id
), service_reviews as (
	select
		ts_1.id as tasker_service_id,
		coalesce(
			jsonb_agg(
				distinct jsonb_build_object(
					'id', r.id,
					'rating', r.rating,
					'comment', r.comment,
					'created_at', r.created_at,
					'reviewer', jsonb_build_object(
						'id', reviewer.id,
						'full_name', reviewer.full_name,
						'avatar_url', reviewer.avatar_url
					)
				)
			) filter (where (r.id is not null)),
			'[]'::jsonb
		) as service_reviews,
		coalesce(avg(r.rating), (0)::numeric) as rating,
		count(distinct r.id) as reviews_count
	from ((("public"."tasker_services" ts_1
		left join "public"."bookings" b on (((b.tasker_profile_id = ts_1.tasker_profile_id) and (b.category_id = ts_1.category_id))))
		left join "public"."reviews" r on ((r.booking_id = b.id)))
		left join "public"."profiles" reviewer on ((reviewer.id = r.reviewer_id)))
	group by ts_1.id
), service_jobs as (
	select
		ts_1.id as tasker_service_id,
		count(distinct b.id) filter (where (b.status = 'completed'::text)) as jobs_done
	from ("public"."tasker_services" ts_1
		left join "public"."bookings" b on (((b.tasker_profile_id = ts_1.tasker_profile_id) and (b.category_id = ts_1.category_id))))
	group by ts_1.id
)
select
	ts.id as service_id,
	ts.tasker_profile_id,
	tp.user_id as tasker_user_id,
	jsonb_build_object(
		'id', c.id,
		'name', c.name,
		'slug', c.slug,
		'description', c.description
	) as category,
	jsonb_build_object(
		'id', tp.id,
		'user_id', tp.user_id,
		'full_name', p.full_name,
		'profile_image', p.avatar_url,
		'bio', tp.bio,
		'experience_years', tp.experience_years,
		'average_rating', tp.average_rating,
		'total_reviews', tp.total_reviews,
		'total_jobs', tp.total_jobs,
		'is_verified', tp.is_verified,
		'is_domo_diamond', tp.is_domo_diamond
	) as tasker,
	coalesce(ss.specialized_subcategories, '[]'::jsonb) as specialized_subcategories,
	coalesce(ts.images, '{}'::text[]) as images,
	ts.experience,
	ts.knowledge,
	coalesce(ts.working_areas, '{}'::text[]) as working_areas,
	coalesce(o.offerings, '[]'::jsonb) as offerings,
	coalesce(sj.jobs_done, (0)::bigint) as jobs_done,
	coalesce(sr.rating, (0)::numeric) as rating,
	coalesce(sr.reviews_count, (0)::bigint) as reviews_count,
	coalesce(sr.service_reviews, '[]'::jsonb) as service_reviews,
	ts.is_active,
	ts.created_at,
	ts.updated_at
from ((((((("public"."tasker_services" ts
	join "public"."tasker_profiles" tp on ((tp.id = ts.tasker_profile_id)))
	join "public"."profiles" p on ((p.id = tp.user_id)))
	join "public"."categories" c on ((c.id = ts.category_id)))
	left join specialized_subcategories ss on ((ss.tasker_service_id = ts.id)))
	left join offerings o on ((o.tasker_service_id = ts.id)))
	left join service_reviews sr on ((sr.tasker_service_id = ts.id)))
	left join service_jobs sj on ((sj.tasker_service_id = ts.id)))
where (ts.is_active = true);
