-- Account settings ("Configuración" screens).
--
--   * Editar perfil      -> public.users.full_name / phone
--   * Apariencia         -> public.users.preferred_theme ('system'|'light'|'dark')
--   * Notificaciones     -> new public.users.notify_* columns
--   * Correo electrónico -> Supabase auth email change; a trigger mirrors the
--                           confirmed address into public.users.email
--   * Contactar soporte  -> existing public.support_tickets
--
-- Safe to re-run.

-- ── Notification preferences ─────────────────────────────────────────────
alter table public.users
  add column if not exists notify_new_offers      boolean not null default true,
  add column if not exists notify_expiring_offers boolean not null default true,
  add column if not exists notify_app_messages    boolean not null default true;

-- ── Users may edit only their own row, and only these columns ────────────
-- Column-level grant so a client can't touch email, user_type, is_active...
revoke update on public.users from anon, authenticated;
grant update (
  full_name,
  phone,
  preferred_theme,
  notify_new_offers,
  notify_expiring_offers,
  notify_app_messages,
  updated_at
) on public.users to authenticated;

drop policy if exists users_update_own on public.users;
create policy users_update_own on public.users for update
  to authenticated
  using (auth.uid() = id) with check (auth.uid() = id);

-- ── Keep public.users.email in sync after a confirmed email change ───────
create or replace function public.handle_user_email_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.users
     set email = new.email,
         updated_at = now()
   where id = new.id;
  return new;
end;
$$;

drop trigger if exists on_auth_user_email_changed on auth.users;
create trigger on_auth_user_email_changed
  after update of email on auth.users
  for each row
  when (old.email is distinct from new.email)
  execute function public.handle_user_email_change();

-- ── Support tickets: users create and read their own ─────────────────────
alter table public.support_tickets alter column id set default gen_random_uuid();
alter table public.support_tickets alter column created_at set default now();

drop policy if exists support_tickets_insert_own on public.support_tickets;
create policy support_tickets_insert_own on public.support_tickets for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists support_tickets_select_own on public.support_tickets;
create policy support_tickets_select_own on public.support_tickets for select
  to authenticated
  using (auth.uid() = user_id);

notify pgrst, 'reload schema';
