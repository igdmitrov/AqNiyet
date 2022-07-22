create table public.phonecode (
  id uuid default gen_random_uuid() primary key not null,
  code text check (char_length(code) > 0) not null,
  country_id text references public.country not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

insert into public.phonecode (code, country_id)
values 
('+7', 'kz');

alter table phonecode enable row level security;

create policy "Users can create it." on public.phonecode for
    insert with check (false);

create policy "Users can view it." on public.phonecode for
    select using (true);

create policy "Users can update it." on public.phonecode for
    update using (false);

create policy "Users can delete it." on public.phonecode for
    delete using (false);