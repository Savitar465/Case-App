-- Reviews ("Opiniones") and follows ("Seguir") for the business profile.
-- Run this in the Supabase SQL editor (or via `supabase db push`).
--
-- Adds:
--   * public.reviews            – one review per user per business (1..5 stars)
--   * public.business_follows   – per-user follow rows
--   * a trigger keeping businesses.followers_count in sync
--   * row-level-security policies

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
-- NOTE: in the live project `public.reviews` already existed with this shape
-- (audit columns status/created_by/updated_by, no author_name). This mirrors
-- it for fresh installs. The app derives the author label client-side.
create table if not exists public.reviews (
  id          uuid        primary key default gen_random_uuid(),
  business_id uuid        not null references public.businesses(id) on delete cascade,
  user_id     uuid        not null references auth.users(id) on delete cascade,
  rating      int         not null check (rating between 1 and 5),
  comment     text,
  status      varchar     not null default 'active',
  created_by  varchar,
  updated_by  varchar,
  created_at  timestamp   not null default now(),
  updated_at  timestamp,
  unique (business_id, user_id)
);

create index if not exists reviews_business_id_idx on public.reviews (business_id);

create table if not exists public.business_follows (
  user_id     uuid        not null references auth.users(id) on delete cascade,
  business_id uuid        not null references public.businesses(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, business_id)
);

create index if not exists business_follows_business_id_idx
  on public.business_follows (business_id);

-- (The app computes the rating average/count client-side from review rows,
-- so no aggregate view is required.)

-- ---------------------------------------------------------------------------
-- Keep businesses.followers_count in sync with business_follows
-- ---------------------------------------------------------------------------
create or replace function public.sync_followers_count()
returns trigger
language plpgsql
security definer
as $$
begin
  if (tg_op = 'INSERT') then
    update public.businesses
       set followers_count = coalesce(followers_count, 0) + 1
     where id = new.business_id;
  elsif (tg_op = 'DELETE') then
    update public.businesses
       set followers_count = greatest(coalesce(followers_count, 0) - 1, 0)
     where id = old.business_id;
  end if;
  return null;
end;
$$;

drop trigger if exists trg_sync_followers_count on public.business_follows;
create trigger trg_sync_followers_count
  after insert or delete on public.business_follows
  for each row execute function public.sync_followers_count();

-- ---------------------------------------------------------------------------
-- Row level security
-- ---------------------------------------------------------------------------
alter table public.reviews          enable row level security;
alter table public.business_follows enable row level security;

-- Reviews: world-readable, each user manages only their own row.
drop policy if exists reviews_select_all on public.reviews;
create policy reviews_select_all
  on public.reviews for select using (true);

drop policy if exists reviews_insert_own on public.reviews;
create policy reviews_insert_own
  on public.reviews for insert with check (auth.uid() = user_id);

drop policy if exists reviews_update_own on public.reviews;
create policy reviews_update_own
  on public.reviews for update using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists reviews_delete_own on public.reviews;
create policy reviews_delete_own
  on public.reviews for delete using (auth.uid() = user_id);

-- Follows: a user only sees and manages their own follow rows.
drop policy if exists follows_select_own on public.business_follows;
create policy follows_select_own
  on public.business_follows for select using (auth.uid() = user_id);

drop policy if exists follows_insert_own on public.business_follows;
create policy follows_insert_own
  on public.business_follows for insert with check (auth.uid() = user_id);

drop policy if exists follows_delete_own on public.business_follows;
create policy follows_delete_own
  on public.business_follows for delete using (auth.uid() = user_id);
