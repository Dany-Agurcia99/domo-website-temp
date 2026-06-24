alter table public.preregistrations
  alter column phone drop not null;

alter table public.preregistrations
  add constraint preregistrations_honduras_phone_check
  check (phone is null or phone ~ '^\+504[0-9]{8}$');
