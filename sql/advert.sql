create table public.advert (
  id uuid default gen_random_uuid() primary key,
  category_id uuid references public.category not null,
  name text check (char_length(name) > 0) not null,
  description text check (char_length(description) > 0) not null,
  country_id text references public.country not null,
  city_id text references public.city not null,
  address text check (char_length(address) > 0) not null,
  phonecode_id uuid references public.phonecode not null,
  phone text check (char_length(phone) > 0) not null,
  enabled boolean default true,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_by uuid references auth.users not null
);

alter table public.advert enable row level security;

create policy "Users can insert their own adverts."
  on advert for insert
  with check ( auth.uid() = advert.created_by );

create policy "All users can view adverts" on advert for
  on advert for select
  using ( advert.enabled = true or auth.uid() = advert.created_by );

create policy "Users can update their own adverts."
  on advert for update using (
    auth.uid() = advert.created_by
  );

create policy "Users can delete their own adverts." on advert for
    delete using (
      auth.uid() = advert.created_by
    );