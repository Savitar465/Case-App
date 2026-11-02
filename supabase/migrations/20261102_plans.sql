-- Plans table for ViKuS Pro subscriptions and business boosting.
-- Safe to re-run.

create table if not exists public.plans (
  id uuid primary key default gen_random_uuid(),
  name character varying not null unique,
  price numeric not null,
  is_active boolean default true
);

-- RLS: allow authenticated and anon users to read active plans
alter table public.plans enable row level security;

drop policy if exists plans_select_all on public.plans;
create policy plans_select_all on public.plans for select
  to anon, authenticated
  using (is_active = true);

-- Seed initial plans if table is empty
insert into public.plans (name, price, is_active)
values
  ('Mensual', 15, true),
  ('Trimestral', 42, true),
  ('Anual', 150, true)
on conflict (name) do nothing;

notify pgrst, 'reload schema';

