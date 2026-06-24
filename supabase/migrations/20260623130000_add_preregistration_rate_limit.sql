create table public.preregistration_rate_limit_events (
  id bigint generated always as identity primary key,
  ip_hash text not null check (ip_hash ~ '^[a-f0-9]{64}$'),
  created_at timestamptz not null default now()
);

create index preregistration_rate_limit_events_lookup_idx
  on public.preregistration_rate_limit_events (ip_hash, created_at desc);

create index preregistration_rate_limit_events_cleanup_idx
  on public.preregistration_rate_limit_events (created_at);

alter table public.preregistration_rate_limit_events enable row level security;

revoke all on table public.preregistration_rate_limit_events
  from anon, authenticated;

create or replace function public.consume_preregistration_rate_limit(
  p_ip_hash text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  short_window_count integer;
  daily_count integer;
begin
  if p_ip_hash !~ '^[a-f0-9]{64}$' then
    raise exception 'Invalid IP hash';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(p_ip_hash, 0));

  delete from public.preregistration_rate_limit_events
  where created_at < now() - interval '48 hours';

  select
    count(*) filter (where created_at >= now() - interval '15 minutes'),
    count(*) filter (where created_at >= now() - interval '24 hours')
  into short_window_count, daily_count
  from public.preregistration_rate_limit_events
  where ip_hash = p_ip_hash
    and created_at >= now() - interval '24 hours';

  if daily_count >= 20 then
    return jsonb_build_object('allowed', false, 'reason', 'daily');
  end if;

  if short_window_count >= 5 then
    return jsonb_build_object('allowed', false, 'reason', 'short_window');
  end if;

  insert into public.preregistration_rate_limit_events (ip_hash)
  values (p_ip_hash);

  return jsonb_build_object('allowed', true);
end;
$$;

revoke all on function public.consume_preregistration_rate_limit(text)
  from public, anon, authenticated;

grant execute on function public.consume_preregistration_rate_limit(text)
  to service_role;
