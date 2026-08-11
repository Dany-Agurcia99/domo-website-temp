alter table public.preregistrations
  alter column phone drop not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'preregistrations_honduras_phone_check'
      and conrelid = 'public.preregistrations'::regclass
  ) then
    alter table public.preregistrations
      add constraint preregistrations_honduras_phone_check
      check (phone is null or phone ~ '^\+504[0-9]{8}$');
  end if;
end
$$;
