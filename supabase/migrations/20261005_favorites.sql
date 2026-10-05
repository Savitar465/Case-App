-- Favorites ("Favoritos" tab).
--
--   * Negocios favoritos  -> existing public.business_follows (the heart on
--                            business cards already writes there)
--   * Servicios/Productos -> existing public.favorites (id, user_id, item_id,
--                            created_at); items.type decides the bucket
--   * Ofertas favoritas   -> new public.offer_favorites
--
-- Also seeds a demo catalog (services + products) for the businesses created
-- by 20261004_seed_home_demo_data.sql and a few favorites for existing
-- accounts so the screen has something to show.
--
-- Run in the Supabase SQL editor after 20261004. Safe to re-run.

-- ── Tables ───────────────────────────────────────────────────────────────
-- public.favorites already exists. Give it the defaults the app relies on
-- and one row per (user, item). The unique index fails if duplicates exist;
-- delete them first in that case.
alter table public.favorites alter column id set default gen_random_uuid();
alter table public.favorites alter column created_at set default now();
create unique index if not exists favorites_user_item_key
  on public.favorites (user_id, item_id);

create table if not exists public.offer_favorites (
  user_id    uuid        not null references auth.users (id) on delete cascade,
  offer_id   uuid        not null references public.offers (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, offer_id)
);

-- ── RLS: each user sees and manages only their own rows ──────────────────
alter table public.favorites       enable row level security;
alter table public.offer_favorites enable row level security;

drop policy if exists favorites_own on public.favorites;
create policy favorites_own on public.favorites for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists offer_favorites_own on public.offer_favorites;
create policy offer_favorites_own on public.offer_favorites for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ── Demo catalog + favorites ─────────────────────────────────────────────
do $$
declare
  v_owner text;
begin
  select created_by into v_owner from public.businesses
   where id = 'b0000000-0000-4000-8000-000000000001';
  if v_owner is null then
    raise notice 'Demo businesses not found; run 20261004 first. Skipping seed.';
    return;
  end if;

  insert into public.items (
    id, business_id, type, name, description, price, currency, duration,
    category_id, is_active, created_by, created_at
  )
  select i.id::uuid, i.business_id::uuid, i.type, i.name, i.description,
         i.price, 'BOB', i.duration,
         (select b.category_id from public.businesses b
           where b.id = i.business_id::uuid),
         true, v_owner, now()
  from (values
    ('e0000000-0000-4000-8000-000000000101', 'b0000000-0000-4000-8000-000000000001', 'service', 'Mensualidad libre', 'Acceso ilimitado a sala de pesas y cardio.', 150, null),
    ('e0000000-0000-4000-8000-000000000102', 'b0000000-0000-4000-8000-000000000001', 'service', 'Entrenamiento personalizado', 'Sesión 1 a 1 con entrenador.', 80, 60),
    ('e0000000-0000-4000-8000-000000000103', 'b0000000-0000-4000-8000-000000000001', 'product', 'Proteína Whey 2 lb', 'Sabor chocolate.', 320, null),
    ('e0000000-0000-4000-8000-000000000201', 'b0000000-0000-4000-8000-000000000002', 'product', 'Pizza pepperoni familiar', '8 porciones, masa delgada.', 85, null),
    ('e0000000-0000-4000-8000-000000000202', 'b0000000-0000-4000-8000-000000000002', 'product', 'Pizza hawaiana mediana', 'Jamón y piña.', 60, null),
    ('e0000000-0000-4000-8000-000000000301', 'b0000000-0000-4000-8000-000000000003', 'product', 'Smash burger doble', 'Doble carne, cheddar y salsa de la casa.', 45, null),
    ('e0000000-0000-4000-8000-000000000302', 'b0000000-0000-4000-8000-000000000003', 'product', 'Papas con cheddar', 'Porción grande.', 20, null),
    ('e0000000-0000-4000-8000-000000000401', 'b0000000-0000-4000-8000-000000000004', 'product', 'Capuccino', 'Café de altura con leche espumada.', 18, null),
    ('e0000000-0000-4000-8000-000000000402', 'b0000000-0000-4000-8000-000000000004', 'product', 'Cheesecake de maracuyá', 'Porción individual.', 22, null),
    ('e0000000-0000-4000-8000-000000000501', 'b0000000-0000-4000-8000-000000000005', 'service', 'Limpieza dental', 'Profilaxis y revisión general.', 150, 45),
    ('e0000000-0000-4000-8000-000000000502', 'b0000000-0000-4000-8000-000000000005', 'service', 'Blanqueamiento', 'Blanqueamiento LED en consultorio.', 600, 90),
    ('e0000000-0000-4000-8000-000000000601', 'b0000000-0000-4000-8000-000000000006', 'product', 'Botiquín de primeros auxilios', 'Kit completo para el hogar.', 90, null),
    ('e0000000-0000-4000-8000-000000000701', 'b0000000-0000-4000-8000-000000000007', 'service', 'Curso de inglés básico', '3 meses, grupos de 8 personas.', 350, null),
    ('e0000000-0000-4000-8000-000000000801', 'b0000000-0000-4000-8000-000000000008', 'product', 'Combo pipocas + gaseosa', 'Pipocas grandes y gaseosa 500 ml.', 40, null),
    ('e0000000-0000-4000-8000-000000000901', 'b0000000-0000-4000-8000-000000000009', 'service', 'Clase de yoga', 'Clase grupal de 60 minutos.', 40, 60),
    ('e0000000-0000-4000-8000-000000000902', 'b0000000-0000-4000-8000-000000000009', 'service', 'Pilates mensual', '12 clases al mes.', 250, null),
    ('e0000000-0000-4000-8000-000000001001', 'b0000000-0000-4000-8000-000000000010', 'service', 'Cambio de pantalla', 'Incluye repuesto y garantía de 3 meses.', 250, 120),
    ('e0000000-0000-4000-8000-000000001002', 'b0000000-0000-4000-8000-000000000010', 'product', 'Audífonos bluetooth', 'Cancelación de ruido, 30 h de batería.', 120, null)
  ) as i(id, business_id, type, name, description, price, duration)
  on conflict (id) do nothing;

  insert into public.item_images (id, item_id, url, display_order)
  select ('f' || substr(i.item_id, 2))::uuid, i.item_id::uuid,
         'https://images.unsplash.com/photo-' || i.photo || '?w=400&q=70', 0
  from (values
    ('e0000000-0000-4000-8000-000000000101', '1540497077202-7c8a3999166f'),
    ('e0000000-0000-4000-8000-000000000102', '1571019613454-1cb2f99b2d8b'),
    ('e0000000-0000-4000-8000-000000000103', '1593095948071-474c5cc2989d'),
    ('e0000000-0000-4000-8000-000000000201', '1628840042765-356cda07504e'),
    ('e0000000-0000-4000-8000-000000000202', '1565299624946-b28f40a0ae38'),
    ('e0000000-0000-4000-8000-000000000301', '1568901346375-23c9450c58cd'),
    ('e0000000-0000-4000-8000-000000000302', '1573080496219-bb080dd4f877'),
    ('e0000000-0000-4000-8000-000000000401', '1572442388796-11668a67e53d'),
    ('e0000000-0000-4000-8000-000000000402', '1533134242443-d4fd215305ad'),
    ('e0000000-0000-4000-8000-000000000501', '1606811971618-4486d14f3f99'),
    ('e0000000-0000-4000-8000-000000000502', '1588776814546-1ffcf47267a5'),
    ('e0000000-0000-4000-8000-000000000601', '1603398938378-e54eab446dde'),
    ('e0000000-0000-4000-8000-000000000701', '1503676260728-1c00da094a0b'),
    ('e0000000-0000-4000-8000-000000000801', '1585647347483-22b66260dfff'),
    ('e0000000-0000-4000-8000-000000000901', '1544367567-0f2fcb009e0b'),
    ('e0000000-0000-4000-8000-000000000902', '1518611012118-696072aa579a'),
    ('e0000000-0000-4000-8000-000000001001', '1512499617640-c74ae3a79d37'),
    ('e0000000-0000-4000-8000-000000001002', '1505740420928-5e560c06d30e')
  ) as i(item_id, photo)
  on conflict (id) do nothing;

  -- Favorites for up to 6 existing accounts: 4 businesses, 3 services,
  -- 2 products and 2 offers each.
  insert into public.business_follows (user_id, business_id)
  select u.id, b.id::uuid
  from (select id from auth.users order by created_at limit 6) u
  cross join (values
    ('b0000000-0000-4000-8000-000000000001'),
    ('b0000000-0000-4000-8000-000000000002'),
    ('b0000000-0000-4000-8000-000000000004'),
    ('b0000000-0000-4000-8000-000000000008')
  ) as b(id)
  where not exists (
    select 1 from public.business_follows f
     where f.user_id = u.id and f.business_id = b.id::uuid
  );

  -- favorites.user_id points at public.users (mirrors auth.users).
  insert into public.favorites (id, user_id, item_id, created_at)
  select gen_random_uuid(), u.id, i.id::uuid, now()
  from (
    select pu.id from public.users pu
    join auth.users au on au.id = pu.id
    order by au.created_at limit 6
  ) u
  cross join (values
    ('e0000000-0000-4000-8000-000000000101'),
    ('e0000000-0000-4000-8000-000000000501'),
    ('e0000000-0000-4000-8000-000000000901'),
    ('e0000000-0000-4000-8000-000000000201'),
    ('e0000000-0000-4000-8000-000000000301')
  ) as i(id)
  on conflict do nothing;

  insert into public.offer_favorites (user_id, offer_id)
  select u.id, o.id::uuid
  from (select id from auth.users order by created_at limit 6) u
  cross join (values
    ('d0000000-0000-4000-8000-000000000001'),
    ('d0000000-0000-4000-8000-000000000004')
  ) as o(id)
  where exists (select 1 from public.offers x where x.id = o.id::uuid)
  on conflict do nothing;
end;
$$;

notify pgrst, 'reload schema';
