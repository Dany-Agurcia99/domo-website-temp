create extension if not exists "pgcrypto";

create table if not exists public.preregistrations (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  email text not null,
  phone text not null,
  department text not null,
  platform text not null,
  interest_role text not null,
  created_at timestamptz not null default now()
);

create unique index if not exists preregistrations_email_unique_idx
  on public.preregistrations (lower(trim(email)));

create unique index if not exists preregistrations_phone_unique_idx
  on public.preregistrations (phone);

create index if not exists preregistrations_created_at_idx
  on public.preregistrations (created_at desc);

alter table public.preregistrations enable row level security;

revoke all on table public.preregistrations from anon, authenticated;
grant select, insert on table public.preregistrations to service_role;
