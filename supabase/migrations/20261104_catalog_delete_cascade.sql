-- Let business owners delete a product/service from the owner dashboard.
--
-- `item_images.item_id` and `favorites.item_id` referenced `items` without an
-- ON DELETE action, so deleting an item failed as soon as it had a photo or
-- any user had favorited it (and owners cannot delete other users'
-- favorites under RLS). `offers.item_id` already cascades.

alter table public.item_images
  drop constraint if exists item_images_item_id_fkey,
  add constraint item_images_item_id_fkey
    foreign key (item_id) references public.items(id)
    on delete cascade deferrable;

alter table public.favorites
  drop constraint if exists favorites_item_id_fkey,
  add constraint favorites_item_id_fkey
    foreign key (item_id) references public.items(id)
    on delete cascade deferrable;
