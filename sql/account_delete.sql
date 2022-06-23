create table public.account_delete (
  id uuid default gen_random_uuid() primary key,
  created_by uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.account_delete enable row level security;

create policy "Users can create it." on public.account_delete for
    insert with check (
      auth.uid() = account_delete.created_by
    );

create policy "Users can view it." on public.account_delete for
  select using (auth.uid() = account_delete.created_by);

create policy "Users can edit it." on public.account_delete for
  update using (false);

create policy "Users can delete it." on public.account_delete for
  delete using (false);