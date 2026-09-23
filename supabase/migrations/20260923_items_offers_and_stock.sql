-- Catalog items (products / services) created from the register-business
-- wizard. `public.items`, `public.item_images` and `public.offers` already
-- exist; this adds:
--   * items.stock                 -> "Cantidad disponible" (null = unlimited)
--   * offers.item_id / start_time / end_time / repeat_days
--                                 -> "Oferta flash" tied to a single item
--   * owner-scoped RLS so a business owner can write their own catalog.
-- Existing business-wide offers keep item_id = null. Safe to re-run.

-- ── Stock ────────────────────────────────────────────────────────────────
alter table public.items
  add column if not exists stock integer check (stock is null or stock >= 0);

-- ── Flash offers on public.offers ────────────────────────────────────────
alter table public.offers
  add column if not exists item_id uuid
    references public.items (id) on delete cascade,
  -- Daily window the offer is live, within start_date..end_date.
  add column if not exists start_time time,
  add column if not exists end_time time,
  -- ISO weekdays the offer repeats on (1 = Monday … 7 = Sunday).
  add column if not exists repeat_days smallint[] not null default '{}';

create index if not exists offers_item_id_idx on public.offers (item_id);

-- ── RLS ──────────────────────────────────────────────────────────────────
-- Helper: does the signed-in user own this business?
create or replace function public.owns_business(p_business_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.businesses b
    where b.id = p_business_id and b.owner_id = auth.uid()
  );
$$;

-- Helper: does the signed-in user own the business of this item?
create or replace function public.owns_item(p_item_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.items i
    join public.businesses b on b.id = i.business_id
    where i.id = p_item_id and b.owner_id = auth.uid()
  );
$$;

-- items
alter table public.items enable row level security;

drop policy if exists items_select_all on public.items;
create policy items_select_all on public.items for select using (true);

drop policy if exists items_write_owner on public.items;
create policy items_write_owner on public.items for all
  using (public.owns_business(business_id))
  with check (public.owns_business(business_id));

-- item_images
alter table public.item_images enable row level security;

drop policy if exists item_images_select_all on public.item_images;
create policy item_images_select_all on public.item_images for select
  using (true);

drop policy if exists item_images_write_owner on public.item_images;
create policy item_images_write_owner on public.item_images for all
  using (public.owns_item(item_id))
  with check (public.owns_item(item_id));

-- offers
alter table public.offers enable row level security;

drop policy if exists offers_select_all on public.offers;
create policy offers_select_all on public.offers for select using (true);

drop policy if exists offers_write_owner on public.offers;
create policy offers_write_owner on public.offers for all
  using (public.owns_business(business_id))
  with check (
    public.owns_business(business_id)
    and (item_id is null or public.owns_item(item_id))
  );

-- Refresh PostgREST's cached schema.
notify pgrst, 'reload schema';
