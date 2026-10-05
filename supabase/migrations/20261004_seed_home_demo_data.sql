-- Demo data for the redesigned home screen (Cobija, Pando).
--
-- Adds 10 active businesses with cover photos, opening hours, PRO/featured
-- flags, reviews from existing accounts and a handful of live offers, so every
-- section of the home page ("Ofertas cerca de ti", "Negocios cerca de ti",
-- "Negocios destacados") has something to show.
--
-- Run in the Supabase SQL editor. Safe to re-run: every row uses a fixed id
-- with ON CONFLICT (reviews skip existing business/user pairs), and offer dates
-- are refreshed so the carousel never goes empty.
--
-- Remove everything again with:
--   delete from public.businesses where id::text like 'b0000000-%';

-- Helper: same hours every day (wizard shape of `schedule`).
create or replace function pg_temp.seed_week(
  p_open text,
  p_close text,
  p_sunday boolean default true
) returns jsonb
language sql
as $$
  select jsonb_object_agg(
    d,
    jsonb_build_object(
      'is_open', case when d = 'sunday' then p_sunday else true end,
      'open', p_open,
      'close', p_close
    )
  )
  from unnest(array[
    'monday', 'tuesday', 'wednesday', 'thursday',
    'friday', 'saturday', 'sunday'
  ]) as d;
$$;

do $$
declare
  v_owner uuid;
begin
  -- Owner of the demo businesses: the existing business account, otherwise
  -- the oldest profile.
  select id into v_owner from public.users
   where email = 'somebusiness@gmail.com';
  if v_owner is null then
    select id into v_owner from public.users order by created_at limit 1;
  end if;
  if v_owner is null then
    raise exception 'public.users is empty: create an account first';
  end if;

  -- ── Businesses ─────────────────────────────────────────────────────────
  insert into public.businesses (
    id, owner_id, name, description, category_id, address,
    latitude, longitude, whatsapp, schedule,
    is_pro, is_featured, status, views_count, created_by, created_at
  )
  select
    b.id::uuid, v_owner, b.name, b.description,
    (select c.id from public.categories c where c.name = b.category),
    b.address, b.lat, b.lng, b.whatsapp, b.schedule,
    b.is_pro, b.is_featured, 'active', b.views, v_owner::text, now()
  from (values
    ('b0000000-0000-4000-8000-000000000001', 'Body Xtreme',
     'Gym con atención cercana y precios accesibles.', 'sports',
     'Av. Pando', -11.0262, -68.7688, '+59172900001',
     pg_temp.seed_week('6:00', '22:00', false), true, true, 340),
    ('b0000000-0000-4000-8000-000000000002', 'Pizza Center',
     'Pizzas artesanales al horno de leña.', 'food',
     'Av. 9 de Febrero', -11.0281, -68.7702, '+59172900002',
     pg_temp.seed_week('11:00', '23:00'), true, false, 512),
    ('b0000000-0000-4000-8000-000000000003', 'Burger Amazonas',
     'Hamburguesas smash y papas caseras.', 'food',
     'Calle Beni', -11.0249, -68.7671, '+59172900003',
     pg_temp.seed_week('12:00', '0:30'), false, false, 221),
    ('b0000000-0000-4000-8000-000000000004', 'Café del Acre',
     'Café de altura, postres y desayunos.', 'food',
     'Plaza Germán Busch', -11.0270, -68.7695, null,
     pg_temp.seed_week('7:00', '21:00'), false, true, 188),
    ('b0000000-0000-4000-8000-000000000005', 'Clínica Dental Sonrisa',
     'Ortodoncia, limpiezas y blanqueamiento.', 'health',
     'Av. Internacional', -11.0302, -68.7720, '+59172900005',
     '{"monday":[{"open":"08:00","close":"12:00"},{"open":"14:00","close":"19:00"}],
       "tuesday":[{"open":"08:00","close":"12:00"},{"open":"14:00","close":"19:00"}],
       "wednesday":[{"open":"08:00","close":"12:00"},{"open":"14:00","close":"19:00"}],
       "thursday":[{"open":"08:00","close":"12:00"},{"open":"14:00","close":"19:00"}],
       "friday":[{"open":"08:00","close":"12:00"},{"open":"14:00","close":"19:00"}],
       "saturday":[{"open":"09:00","close":"13:00"}]}'::jsonb,
     true, true, 97),
    ('b0000000-0000-4000-8000-000000000006', 'Farmacia Pando 24h',
     'Medicamentos y atención las 24 horas.', 'health',
     'Calle Cornejo', -11.0255, -68.7660, '+59172900006',
     pg_temp.seed_week('0:00', '24:00'), false, false, 143),
    ('b0000000-0000-4000-8000-000000000007', 'Instituto Amazónico de Idiomas',
     'Inglés y portugués para todas las edades.', 'education',
     'Av. Tcnl. Cornejo', -11.0315, -68.7735, '+59172900007',
     pg_temp.seed_week('8:00', '20:00', false), false, false, 64),
    ('b0000000-0000-4000-8000-000000000008', 'Cine Cobija',
     'Estrenos, combos y funciones de trasnoche.', 'entertainment',
     'Av. Fernández Molina', -11.0231, -68.7650, null,
     pg_temp.seed_week('15:00', '23:30'), true, false, 430),
    ('b0000000-0000-4000-8000-000000000009', 'Yoga Selva Studio',
     'Clases de yoga y pilates en grupos reducidos.', 'sports',
     'Barrio Mapajo', -11.0340, -68.7610, '+59172900009',
     pg_temp.seed_week('7:00', '21:00', false), false, true, 75),
    ('b0000000-0000-4000-8000-000000000010', 'TecnoCell Pando',
     'Celulares, accesorios y servicio técnico.', 'technology',
     'Av. 16 de Julio', -11.0222, -68.7712, '+59172900010',
     pg_temp.seed_week('9:00', '20:00', false), false, false, 156)
  ) as b(id, name, description, category, address, lat, lng, whatsapp,
         schedule, is_pro, is_featured, views)
  on conflict (id) do nothing;

  -- ── Photos (cover first) ───────────────────────────────────────────────
  insert into public.business_images (
    id, business_id, url, is_cover, display_order, created_at
  )
  select i.id::uuid, i.business_id::uuid,
         'https://images.unsplash.com/photo-' || i.photo || '?w=800&q=70',
         i.display_order = 0, i.display_order, now()
  from (values
    ('c0000000-0000-4000-8000-000000000101', 'b0000000-0000-4000-8000-000000000001', '1534438327276-14e5300c3a48', 0),
    ('c0000000-0000-4000-8000-000000000102', 'b0000000-0000-4000-8000-000000000001', '1571019613454-1cb2f99b2d8b', 1),
    ('c0000000-0000-4000-8000-000000000201', 'b0000000-0000-4000-8000-000000000002', '1513104890138-7c749659a591', 0),
    ('c0000000-0000-4000-8000-000000000202', 'b0000000-0000-4000-8000-000000000002', '1565299624946-b28f40a0ae38', 1),
    ('c0000000-0000-4000-8000-000000000301', 'b0000000-0000-4000-8000-000000000003', '1568901346375-23c9450c58cd', 0),
    ('c0000000-0000-4000-8000-000000000302', 'b0000000-0000-4000-8000-000000000003', '1550547660-d9450f859349', 1),
    ('c0000000-0000-4000-8000-000000000401', 'b0000000-0000-4000-8000-000000000004', '1495474472287-4d71bcdd2085', 0),
    ('c0000000-0000-4000-8000-000000000402', 'b0000000-0000-4000-8000-000000000004', '1509042239860-f550ce710b93', 1),
    ('c0000000-0000-4000-8000-000000000501', 'b0000000-0000-4000-8000-000000000005', '1606811971618-4486d14f3f99', 0),
    ('c0000000-0000-4000-8000-000000000502', 'b0000000-0000-4000-8000-000000000005', '1588776814546-1ffcf47267a5', 1),
    ('c0000000-0000-4000-8000-000000000601', 'b0000000-0000-4000-8000-000000000006', '1587854692152-cbe660dbde88', 0),
    ('c0000000-0000-4000-8000-000000000602', 'b0000000-0000-4000-8000-000000000006', '1576602976047-174e57a47881', 1),
    ('c0000000-0000-4000-8000-000000000701', 'b0000000-0000-4000-8000-000000000007', '1503676260728-1c00da094a0b', 0),
    ('c0000000-0000-4000-8000-000000000702', 'b0000000-0000-4000-8000-000000000007', '1524178232363-1fb2b075b655', 1),
    ('c0000000-0000-4000-8000-000000000801', 'b0000000-0000-4000-8000-000000000008', '1489599849927-2ee91cede3ba', 0),
    ('c0000000-0000-4000-8000-000000000802', 'b0000000-0000-4000-8000-000000000008', '1517604931442-7e0c8ed2963c', 1),
    ('c0000000-0000-4000-8000-000000000901', 'b0000000-0000-4000-8000-000000000009', '1544367567-0f2fcb009e0b', 0),
    ('c0000000-0000-4000-8000-000000000902', 'b0000000-0000-4000-8000-000000000009', '1506126613408-eca07ce68773', 1),
    ('c0000000-0000-4000-8000-000000001001', 'b0000000-0000-4000-8000-000000000010', '1511707171634-5f897ff02aa9', 0),
    ('c0000000-0000-4000-8000-000000001002', 'b0000000-0000-4000-8000-000000000010', '1519389950473-47ba0277781c', 1)
  ) as i(id, business_id, photo, display_order)
  on conflict (id) do nothing;

  -- ── Reviews: up to 6 existing accounts rate every demo business 3–5 ★ ──
  -- The live table has no defaults for id / created_at, so set them here.
  insert into public.reviews (
    id, business_id, user_id, rating, comment, status, created_by, created_at
  )
  select gen_random_uuid(), b.id, u.id,
         3 + abs(hashtext(b.id::text || u.id::text)) % 3,
         (array[
           'Muy buena atención, volveré.',
           'Buenos precios y el lugar es cómodo.',
           'Excelente servicio, lo recomiendo.',
           'Todo bien, aunque a veces hay que esperar.'
         ])[1 + abs(hashtext(u.id::text || b.id::text)) % 4],
         'active', u.id::text, now()
  from public.businesses b
  cross join (select id from auth.users order by created_at limit 6) u
  where b.id::text like 'b0000000-%'
    -- The live table has no unique (business_id, user_id), so ON CONFLICT
    -- can't be used; skip pairs that already have a review instead.
    and not exists (
      select 1 from public.reviews r
       where r.business_id = b.id and r.user_id = u.id
    );

  -- ── Offers (dates relative to today so they stay live) ────────────────
  insert into public.offers (
    id, business_id, title, description, discount_type, discount_value,
    start_date, end_date, start_time, end_time, image_url, is_active,
    created_by, created_at
  )
  values
    ('d0000000-0000-4000-8000-000000000001', 'b0000000-0000-4000-8000-000000000002',
     '2x1 Pizzas', 'Dos pizzas medianas al precio de una.', 'percentage', 50,
     date_trunc('day', now()), date_trunc('day', now()) + interval '23 hours 59 minutes',
     '11:00', '23:00',
     'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=70',
     true, v_owner::text, now()),
    ('d0000000-0000-4000-8000-000000000002', 'b0000000-0000-4000-8000-000000000003',
     '2x1 Hamburguesas', 'Todos los martes y jueves.', 'percentage', 50,
     date_trunc('day', now()), now() + interval '14 days',
     null, null,
     'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=70',
     true, v_owner::text, now()),
    ('d0000000-0000-4000-8000-000000000003', 'b0000000-0000-4000-8000-000000000001',
     'Mensualidad', 'Primer mes con descuento para nuevos socios.', 'percentage', 30,
     date_trunc('day', now()), now() + interval '30 days',
     null, null,
     'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=70',
     true, v_owner::text, now()),
    ('d0000000-0000-4000-8000-000000000004', 'b0000000-0000-4000-8000-000000000004',
     'Café + postre', 'Combo de café americano y porción de torta.', 'fixed_amount', 10,
     date_trunc('day', now()), now() + interval '7 days',
     '15:00', '19:00',
     'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=70',
     true, v_owner::text, now()),
    ('d0000000-0000-4000-8000-000000000005', 'b0000000-0000-4000-8000-000000000008',
     '2x1 Entradas', 'Miércoles de cine: dos entradas al precio de una.', 'percentage', 50,
     date_trunc('day', now()), now() + interval '21 days',
     null, null,
     'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600&q=70',
     true, v_owner::text, now())
  on conflict (id) do update
    set start_date = excluded.start_date,
        end_date   = excluded.end_date,
        is_active  = true;
end;
$$;

notify pgrst, 'reload schema';
