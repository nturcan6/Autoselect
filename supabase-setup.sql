create table if not exists public.cars (
  id uuid primary key default gen_random_uuid(),
  title text,
  price integer,
  year integer,
  km integer,
  power integer,
  engine integer,
  fuel text,
  gear text,
  status text,
  images jsonb,
  description text,
  created_at timestamp with time zone default timezone('utc', now())
);

alter table public.cars enable row level security;

grant select on table public.cars to anon, authenticated;
grant insert, update, delete on table public.cars to authenticated;
revoke insert, update, delete on table public.cars from anon;

drop policy if exists "public read cars" on public.cars;
drop policy if exists "public insert cars" on public.cars;
drop policy if exists "public update cars" on public.cars;
drop policy if exists "public delete cars" on public.cars;
drop policy if exists "authenticated insert cars" on public.cars;
drop policy if exists "authenticated update cars" on public.cars;
drop policy if exists "authenticated delete cars" on public.cars;

create policy "public read cars"
on public.cars for select
to anon, authenticated
using (true);

create policy "authenticated insert cars"
on public.cars for insert
to authenticated
with check (true);

create policy "authenticated update cars"
on public.cars for update
to authenticated
using (true)
with check (true);

create policy "authenticated delete cars"
on public.cars for delete
to authenticated
using (true);

insert into storage.buckets (id, name, public)
values ('car-images', 'car-images', true)
on conflict (id) do update set public = true;

drop policy if exists "public read car images" on storage.objects;
drop policy if exists "public insert car images" on storage.objects;
drop policy if exists "public update car images" on storage.objects;
drop policy if exists "public delete car images" on storage.objects;
drop policy if exists "authenticated insert car images" on storage.objects;
drop policy if exists "authenticated update car images" on storage.objects;
drop policy if exists "authenticated delete car images" on storage.objects;

create policy "public read car images"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'car-images');

create policy "authenticated insert car images"
on storage.objects for insert
to authenticated
with check (bucket_id = 'car-images');

create policy "authenticated update car images"
on storage.objects for update
to authenticated
using (bucket_id = 'car-images')
with check (bucket_id = 'car-images');

create policy "authenticated delete car images"
on storage.objects for delete
to authenticated
using (bucket_id = 'car-images');
