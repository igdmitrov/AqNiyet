create table public.room (
  id uuid default gen_random_uuid() primary key not null,
  advert_name text check (char_length(advert_name) > 0) not null,
  advert_id uuid not null,
  user_from uuid references auth.users not null,
  user_to uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.room enable row level security;

create policy "Users can insert their own messages."
  on room for insert
  with check ( auth.uid() = room.user_from );

create policy "Users can view only their messages" 
  on room for select
  using ( auth.uid() = room.user_from or auth.uid() = room.user_to );

create policy "Users can update their own messages."
  on room for update using (
    false
  );

create policy "Users can delete their own messages." 
  on room for
    delete using (
      false
    );