create extension if not exists pgcrypto;

create table public.transmissions (
  id         uuid        primary key default gen_random_uuid(),
  name       text        not null default 'Anonymous',
  body       text        not null,
  is_admin   boolean     not null default false,
  hidden     boolean     not null default false,
  parent_id  uuid        references public.transmissions(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint name_len check (char_length(name) between 1 and 40),
  constraint body_len check (char_length(body) between 1 and 2000),
  constraint no_owner_name check (
    regexp_replace(lower(name), '[^a-z0-9]', '', 'g') <> 'thejudith'
    and regexp_replace(lower(name), '[^a-z0-9]', '', 'g') <> 'judith'
  )
);

create index transmissions_created_at_idx on public.transmissions (created_at desc);
create index transmissions_parent_idx on public.transmissions (parent_id);

alter table public.transmissions enable row level security;

create policy "anon can read visible transmissions"
on public.transmissions for select to anon
using ( hidden = false );

create policy "anon can insert non-admin"
on public.transmissions for insert to anon
with check ( is_admin = false and hidden = false );

-- server-side profanity/hate blocklist
-- OWNER: replace slur1|slur2|slur3 below with the real terms you want blocked.
-- Keep them lowercase, separated by | (pipe). The ~* match is case-insensitive.
-- Example: '\y(word1|word2|word3|word4)\y'
create or replace function public.block_profanity()
returns trigger language plpgsql as $$
begin
  if new.body ~* '\y(slur1|slur2|slur3)\y' or new.name ~* '\y(slur1|slur2|slur3)\y' then
    raise exception 'blocked content';
  end if;
  return new;
end $$;

create trigger trg_block_profanity
before insert on public.transmissions
for each row execute function public.block_profanity();
