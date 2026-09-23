-- The register-business flow failed with
--   insert or update on table "businesses" violates foreign key constraint
--   "businesses_owner_id_fkey"
-- because businesses.owner_id references public.users(id), but the app only
-- ever creates the auth.users record at signup -- it never creates the matching
-- public.users profile row. So owner_id = auth.uid() has nothing to point at.
--
-- Fix: mirror every auth.users row into public.users automatically (trigger),
-- and backfill the auth users that already exist. Safe to re-run.

-- 1) Function that creates the profile row for a new auth user.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (
    id,
    email,
    full_name,
    user_type,
    created_at,
    updated_at
  )
  values (
    new.id,
    new.email,
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name',
      split_part(new.email, '@', 1)
    ),
    'personal',          -- default user_type; adjust to your vocabulary
    now(),
    now()
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

-- 2) Fire it after each new auth user is created.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3) Backfill auth users that have no profile row yet (covers your current
--    logged-in account so you can publish immediately).
insert into public.users (id, email, full_name, user_type, created_at, updated_at)
select
  au.id,
  au.email,
  coalesce(
    au.raw_user_meta_data ->> 'full_name',
    au.raw_user_meta_data ->> 'name',
    split_part(au.email, '@', 1)
  ),
  'personal',
  now(),
  now()
from auth.users au
left join public.users pu on pu.id = au.id
where pu.id is null;

notify pgrst, 'reload schema';
