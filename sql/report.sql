create table public.report (
  id uuid default gen_random_uuid() primary key,
  advert_id uuid not null,
  email text check (char_length(email) >= 0) not null,
  description text check (char_length(description) >= 0) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.report enable row level security;

create policy "Users can create it." on public.report for
    insert with check (
      '' != report.advert_id
    );

create policy "Users can view it." on public.report for
  select using (false);

create policy "Users can edit it." on public.report for
  update using (false);

create policy "Users can delete it." on public.report for
  delete using (false);