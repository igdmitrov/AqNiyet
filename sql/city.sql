create table public.city (
  id text unique primary key check (char_length(id) >= 2) not null,
  name text check (char_length(name) > 3) not null,
  country_id text references public.country not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

insert into public.city (id, name, country_id)
values 
('almaty', 'Almaty', 'kz');

alter table city enable row level security;

create policy "Users can create it." on public.city for
    insert with check (false);

create policy "Users can view it." on public.city for
    select using (true);

create policy "Users can update it." on public.city for
    update using (false);

create policy "Users can delete it." on public.city for
    delete using (false);