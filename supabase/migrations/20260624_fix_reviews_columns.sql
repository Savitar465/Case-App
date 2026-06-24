-- The `public.reviews` table already existed with this project's audit
-- convention (status / created_by / updated_by) and NO author_name column.
-- The app code targets that schema directly, so no column changes are needed.
--
-- This script only makes sure row-level security lets a signed-in user manage
-- their own review (otherwise INSERT/UPDATE are rejected). Safe to re-run.

alter table public.reviews enable row level security;

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

-- Refresh PostgREST's cached schema.
notify pgrst, 'reload schema';
