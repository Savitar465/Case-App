-- Owner-only write access to business photos (edit business flow).
--
-- Before this migration `business_images` only had a permissive INSERT
-- (any authenticated user, any business) and no UPDATE/DELETE, so owners
-- could not remove, reorder or re-cover their photos. Storage objects under
-- `vikus/<business_id>/...` could be uploaded but never replaced or removed.

-- ── business_images ────────────────────────────────────────────────────────
alter table public.business_images enable row level security;

drop policy if exists "Enable insert for authenticated users only"
  on public.business_images;

drop policy if exists business_images_insert_owner on public.business_images;
create policy business_images_insert_owner on public.business_images
  for insert with check (public.owns_business(business_id));

drop policy if exists business_images_update_owner on public.business_images;
create policy business_images_update_owner on public.business_images
  for update using (public.owns_business(business_id))
  with check (public.owns_business(business_id));

drop policy if exists business_images_delete_owner on public.business_images;
create policy business_images_delete_owner on public.business_images
  for delete using (public.owns_business(business_id));

-- ── storage: vikus/<business_id>/... ───────────────────────────────────────
drop policy if exists business_photos_update_owner on storage.objects;
create policy business_photos_update_owner on storage.objects
  for update using (
    bucket_id = 'vikus'
    and exists (
      select 1 from public.businesses b
      where b.id::text = (storage.foldername(name))[1]
        and b.owner_id = auth.uid()
    )
  );

drop policy if exists business_photos_delete_owner on storage.objects;
create policy business_photos_delete_owner on storage.objects
  for delete using (
    bucket_id = 'vikus'
    and exists (
      select 1 from public.businesses b
      where b.id::text = (storage.foldername(name))[1]
        and b.owner_id = auth.uid()
    )
  );
