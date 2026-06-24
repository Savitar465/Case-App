-- Point reviews.user_id at Supabase's built-in auth.users table so the app's
-- authenticated user id (auth.uid()) is a valid reviewer. Run once.
--
-- If the table already has rows whose user_id is NOT a real auth user, the
-- ADD CONSTRAINT will fail validation. Either delete those rows first, or add
-- the constraint as NOT VALID (see the commented variant below).

alter table public.reviews
  drop constraint if exists reviews_user_id_fkey;

alter table public.reviews
  add constraint reviews_user_id_fkey
  foreign key (user_id) references auth.users (id) on delete cascade;

-- Variant if you have legacy rows and want to skip validating them:
--   alter table public.reviews
--     add constraint reviews_user_id_fkey
--     foreign key (user_id) references auth.users (id)
--     on delete cascade not valid;

notify pgrst, 'reload schema';
