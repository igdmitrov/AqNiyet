create table public.country (
  id text unique primary key check (char_length(id) >= 2) not null,
  name text check (char_length(code) > 0) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

insert into public.country (id, name)
values 
('kz', 'Kazakhstan');

alter table country enable row level security;

create policy "Users can create it." on public.country for
    insert with check (false);

create policy "Users can view it." on public.country for
    select using (true);

create policy "Users can update it." on public.country for
    update using (false);

create policy "Users can delete it." on public.country for
    delete using (false);