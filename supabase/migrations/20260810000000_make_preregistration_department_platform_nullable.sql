alter table public.preregistrations
  alter column department drop not null,
  alter column platform drop not null;
