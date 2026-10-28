-- "Editar perfil": username (@handle) and profile photo.
--
-- * public.users.username: unique (case-insensitive), 3-30 chars of
--   [a-z0-9._]. Existing users get one derived from their email.
-- * public.users.avatar_url already existed; it now stores the storage path
--   of the photo (bucket `vikus`, folder avatars/<user id>/).
-- * New users get a username from handle_new_user().

alter table public.users
  add column if not exists username varchar(30);

alter table public.users
  drop constraint if exists users_username_format;
alter table public.users
  add constraint users_username_format
  check (username is null or username ~ '^[a-z0-9._]{3,30}$');

create unique index if not exists users_username_lower_key
  on public.users (lower(username));

-- Picks a free username from [seed] (usually the email local part), adding
-- digits when the base is taken.
create or replace function public.generate_username(seed text)
returns text
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  base text;
  candidate text;
begin
  base := left(regexp_replace(lower(coalesce(seed, '')), '[^a-z0-9._]', '', 'g'), 24);
  if length(base) < 3 then
    base := 'usuario';
  end if;
  candidate := base;
  while exists (select 1 from public.users where lower(username) = candidate) loop
    candidate := base || (floor(random() * 9000) + 100)::int;
  end loop;
  return candidate;
end;
$$;

-- Only the trigger below needs it; keep it off the public RPC surface.
revoke execute on function public.generate_username(text) from public, anon, authenticated;

-- One statement per row so each generated name sees the previous ones.
do $$
declare
  r record;
begin
  for r in select id, email from public.users where username is null loop
    update public.users
       set username = public.generate_username(split_part(r.email, '@', 1))
     where id = r.id;
  end loop;
end;
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $$
begin
  insert into public.users (
    id,
    email,
    full_name,
    username,
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
    public.generate_username(split_part(new.email, '@', 1)),
    'personal',
    now(),
    now()
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

-- Column-level grant, same approach as 20261006_account_settings.sql.
grant update (username, avatar_url) on public.users to authenticated;

-- Avatars live in vikus/avatars/<uid>/. Uploads already pass the bucket-wide
-- insert policy; these let a user replace and clean up only their own photos.
drop policy if exists "avatars_update_own" on storage.objects;
create policy "avatars_update_own" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'vikus'
    and (storage.foldername(name))[1] = 'avatars'
    and (storage.foldername(name))[2] = auth.uid()::text
  );

drop policy if exists "avatars_delete_own" on storage.objects;
create policy "avatars_delete_own" on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'vikus'
    and (storage.foldername(name))[1] = 'avatars'
    and (storage.foldername(name))[2] = auth.uid()::text
  );
