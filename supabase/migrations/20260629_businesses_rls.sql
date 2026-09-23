-- The `public.businesses` table already exists in the remote project but had
-- RLS enabled with no INSERT policy, so the register-business flow failed with
-- "new row violates row-level security policy for table business".
--
-- This script adds owner-scoped policies so a signed-in user can create and
-- manage their own business, while everyone can read the catalog. Safe to re-run.

alter table public.businesses enable row level security;

drop policy if exists businesses_select_all on public.businesses;
create policy businesses_select_all
  on public.businesses for select using (true);

drop policy if exists businesses_insert_own on public.businesses;
create policy businesses_insert_own
  on public.businesses for insert with check (auth.uid() = owner_id);

drop policy if exists businesses_update_own on public.businesses;
create policy businesses_update_own
  on public.businesses for update using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

drop policy if exists businesses_delete_own on public.businesses;
create policy businesses_delete_own
  on public.businesses for delete using (auth.uid() = owner_id);

-- Refresh PostgREST's cached schema.
notify pgrst, 'reload schema';
