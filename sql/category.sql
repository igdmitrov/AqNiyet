create table public.category (
  id uuid default gen_random_uuid() primary key not null,
  name text check (char_length(code) > 0) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

insert into public.category (name)
values 
('Toys'),
('Clothes'),
('Books');

alter table category enable row level security;

create policy "Users can create it." on public.category for
    insert with check (false);

create policy "Users can view it." on public.category for
    select using (true);

create policy "Users can update it." on public.category for
    update using (false);

create policy "Users can delete it." on public.category for
    delete using (false);