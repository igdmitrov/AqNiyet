create table public.message_metadata (
  id uuid default gen_random_uuid() primary key not null,
  message_id uuid references public.message not null,
  mark_as_read boolean default true not null, 
  created_by uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.message_metadata enable row level security;

create policy "Users can insert their own message metadata."
  on message_metadata for insert
  with check ( auth.uid() = message_metadata.created_by );

create policy "Users can view all message metadata." 
  on message_metadata for select
  using ( true );

create policy "Users can update their own  message metadata."
  on message_metadata for update using (
    false
  );

create policy "Users can delete their own message metadata." 
  on message_metadata for
    delete using (
      false
    );