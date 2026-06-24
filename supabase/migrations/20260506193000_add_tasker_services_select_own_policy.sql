do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'tasker_services'
      and policyname = 'tasker_services_select_own'
  ) then
    create policy "tasker_services_select_own"
    on "public"."tasker_services"
    as permissive
    for select
    to authenticated
    using (
      exists (
        select 1
        from public.tasker_profiles tp
        where tp.id = tasker_services.tasker_profile_id
          and tp.user_id = auth.uid()
      )
    );
  end if;
end;
$$;
