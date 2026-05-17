create table if not exists cars (
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

alter table cars enable row level security;

drop policy if exists "public read cars" on cars;
drop policy if exists "public insert cars" on cars;
drop policy if exists "public update cars" on cars;
drop policy if exists "public delete cars" on cars;

create policy "public read cars" on cars for select using (true);
create policy "public insert cars" on cars for insert with check (true);
create policy "public update cars" on cars for update using (true);
create policy "public delete cars" on cars for delete using (true);

insert into storage.buckets (id, name, public)
values ('car-images', 'car-images', true)
on conflict (id) do update set public = true;

drop policy if exists "public read car images" on storage.objects;
drop policy if exists "public insert car images" on storage.objects;
drop policy if exists "public update car images" on storage.objects;
drop policy if exists "public delete car images" on storage.objects;

create policy "public read car images"
on storage.objects for select
using (bucket_id = 'car-images');

create policy "public insert car images"
on storage.objects for insert
with check (bucket_id = 'car-images');

create policy "public update car images"
on storage.objects for update
using (bucket_id = 'car-images');

create policy "public delete car images"
on storage.objects for delete
using (bucket_id = 'car-images');
