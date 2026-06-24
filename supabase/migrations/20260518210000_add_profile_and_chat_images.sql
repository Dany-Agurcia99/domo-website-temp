-- ============================================================
-- Profile images bucket + Chat images bucket
-- send_image_message RPC + update_profile_avatar RPC
-- ============================================================

-- ----------------------------------------------------------
-- 1. Storage buckets
-- ----------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'profile-images',
    'profile-images',
    true,
    10485760,  -- 10 MB
    array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
  ),
  (
    'booking-chat-images',
    'booking-chat-images',
    true,
    10485760,  -- 10 MB
    array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
  )
on conflict (id) do update
set
  public             = excluded.public,
  file_size_limit    = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;
-- ----------------------------------------------------------
-- 2. Storage policies — profile-images
-- ----------------------------------------------------------
do $$
begin
  -- Public read
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'profile_images_select_public'
  ) then
    create policy "profile_images_select_public"
      on storage.objects as permissive for select to public
      using (bucket_id = 'profile-images');
  end if;

  -- Authenticated user inserts into their own folder
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'profile_images_insert_own'
  ) then
    create policy "profile_images_insert_own"
      on storage.objects as permissive for insert to authenticated
      with check (
        bucket_id = 'profile-images'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;

  -- Owner can update
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'profile_images_update_own'
  ) then
    create policy "profile_images_update_own"
      on storage.objects as permissive for update to authenticated
      using (
        bucket_id = 'profile-images'
        and owner = auth.uid()
      )
      with check (
        bucket_id = 'profile-images'
        and owner = auth.uid()
      );
  end if;

  -- Owner can delete
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'profile_images_delete_own'
  ) then
    create policy "profile_images_delete_own"
      on storage.objects as permissive for delete to authenticated
      using (
        bucket_id = 'profile-images'
        and owner = auth.uid()
      );
  end if;
end;
$$;
-- ----------------------------------------------------------
-- 3. Storage policies — booking-chat-images
-- ----------------------------------------------------------
do $$
begin
  -- Public read
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'chat_images_select_public'
  ) then
    create policy "chat_images_select_public"
      on storage.objects as permissive for select to public
      using (bucket_id = 'booking-chat-images');
  end if;

  -- Booking participants can upload (folder = booking_id)
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'chat_images_insert_participant'
  ) then
    create policy "chat_images_insert_participant"
      on storage.objects as permissive for insert to authenticated
      with check (
        bucket_id = 'booking-chat-images'
        and is_booking_participant((storage.foldername(name))[1]::uuid)
      );
  end if;

  -- Owner can delete own uploads
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'chat_images_delete_own'
  ) then
    create policy "chat_images_delete_own"
      on storage.objects as permissive for delete to authenticated
      using (
        bucket_id = 'booking-chat-images'
        and owner = auth.uid()
      );
  end if;
end;
$$;
-- ----------------------------------------------------------
-- 4. Extend booking_messages to allow 'image' type
-- ----------------------------------------------------------
alter table booking_messages
  drop constraint if exists booking_messages_message_type_check;
alter table booking_messages
  add constraint booking_messages_message_type_check
  check (message_type in ('text', 'interactive_card', 'system', 'image'));
-- ----------------------------------------------------------
-- 5. RPC: send_image_message
--    Same status gates as send_text_message.
--    body = public URL of the uploaded image.
-- ----------------------------------------------------------
create or replace function send_image_message(
  p_booking_id uuid,
  p_image_url  text
)
returns uuid
language plpgsql
security definer
as $$
declare
  v_message_id   uuid;
  v_status       text;
  v_completed_at timestamptz;
begin
  select status, completed_at
  into   v_status, v_completed_at
  from   bookings
  where  id = p_booking_id;

  if v_status not in ('booked', 'in_progress')
     and not (v_status = 'completed' and v_completed_at > now() - interval '3 days') then
    raise exception 'Image messages not allowed in current booking state';
  end if;

  if not is_booking_participant(p_booking_id) then
    raise exception 'Not authorized';
  end if;

  insert into booking_messages (booking_id, sender_id, message_type, body)
  values (p_booking_id, auth.uid(), 'image', p_image_url)
  returning id into v_message_id;

  return v_message_id;
end;
$$;
-- ----------------------------------------------------------
-- 6. RPC: update_profile_avatar
--    Updates the caller's own avatar_url in profiles.
-- ----------------------------------------------------------
create or replace function update_profile_avatar(
  p_avatar_url text
)
returns void
language plpgsql
security definer
as $$
begin
  update profiles
  set    avatar_url = p_avatar_url
  where  id = auth.uid();

  if not found then
    raise exception 'Profile not found';
  end if;
end;
$$;
