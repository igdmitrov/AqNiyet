create table public.image (
  id uuid default gen_random_uuid() primary key,
  image_name text check (char_length(image_name) > 0) not null,
  advert_id uuid references public.advert not null,
  primary boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_by uuid references auth.users not null
);

alter table public.image enable row level security;

create policy "Users can insert their own images."
  on image for insert
  with check ( auth.uid() = image.created_by );

create policy "All users can view images" 
  on image for select
  using ( true );

create policy "Users can update their own images."
  on image for update using (
    auth.uid() = image.created_by
  );

create policy "Users can delete their own images." 
  on image for
    delete using (
      auth.uid() = image.created_by
    );