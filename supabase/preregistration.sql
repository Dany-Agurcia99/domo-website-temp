create extension if not exists "pgcrypto";

create table if not exists public.preregistrations (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  email text not null,
  phone text not null,
  city text not null,
  service_type text not null,
  lead_source text not null,
  details text,
  created_at timestamptz not null default now()
);

create index if not exists preregistrations_created_at_idx
  on public.preregistrations (created_at desc);

create index if not exists preregistrations_email_idx
  on public.preregistrations (email);