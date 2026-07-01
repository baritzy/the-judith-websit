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
    is_admin = true or (
      regexp_replace(lower(name), '[^a-z0-9]', '', 'g') <> 'thejudith'
      and regexp_replace(lower(name), '[^a-z0-9]', '', 'g') <> 'judith'
    )
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
-- OWNER: this is a starter list of common hate slurs blocked at the DB level.
-- Add or remove terms as you see fit. Keep them lowercase, separated by | (pipe).
-- Word boundaries (\y ... \y) mean normal words are not caught. The ~* match is case-insensitive.
-- Example: '\y(word1|word2|word3|word4)\y'
create or replace function public.block_profanity()
returns trigger language plpgsql as $$
begin
  if new.body ~* '\y(kike|kikes|yid|yids|heeb|hymie|sheeny|nigger|niggers|nigga|chink|spic|wetback|faggot|fag|tranny)\y'
     or new.name ~* '\y(kike|kikes|yid|yids|heeb|hymie|sheeny|nigger|niggers|nigga|chink|spic|wetback|faggot|fag|tranny)\y' then
    raise exception 'blocked content';
  end if;
  return new;
end $$;

create trigger trg_block_profanity
before insert on public.transmissions
for each row execute function public.block_profanity();

-- ===== SEEDS =====
-- Seed data for the Guest Transmissions board.
-- Runnable in a single paste. Inserts 7 fan messages + 3 admin replies from The Judith.
-- Admin replies (is_admin = true) are inserted via a superuser/service context so they
-- bypass the anon RLS insert policy. Run this in the Supabase SQL editor (which runs as
-- the table owner), not through the anon client.
-- No em dashes anywhere. Timestamps staggered across the last ~3 weeks.

with p1 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'mordyfromqueens',
    'Just watched the promo three times in a row. My wife thinks something is wrong with me. Something is. This show.',
    false,
    now() - interval '19 days'
  )
  returning id
),
p2 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'Rachel_K',
    'ok but Schtempepper is unhinged and I would die for him',
    false,
    now() - interval '16 days'
  )
  returning id
),
p3 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'DAVID FROM THE INTERNET',
    'WHY DOES EPISODE 2 HAVE A LOCK ON IT. I HAVE BEEN SITTING HERE FOR TWENTY MINUTES. I DEMAND EPISODE 2. RELEASE THE ASSES.',
    false,
    now() - interval '13 days'
  )
  returning id
),
p4 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'quiet_lurker',
    'Honestly did not expect to feel things about a cartoon spaceship. Then Boris happened. Not okay. Well done.',
    false,
    now() - interval '10 days'
  )
  returning id
),
p5 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'Tova',
    'The animation looks incredible. One note: the tagline on the front page has a lowercase b after the period. My grandmother, an editor, will not rest until it is fixed. Neither will I. Otherwise, chef kiss.',
    false,
    now() - interval '8 days'
  )
  returning id
),
p6 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'noam.b',
    'saw this on a friends phone and now the algorithm shows me nothing else. no complaints. bring on the rest of season 1.',
    false,
    now() - interval '5 days'
  )
  returning id
),
p7 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values (
    'skeptical_sam',
    'Was ready to hate this. The whole AI animation thing usually looks cheap. This does not. Fine. You win. I am invested.',
    false,
    now() - interval '2 days'
  )
  returning id
),
-- The Judith replies to a few. In character: cynical, tired, funny, on brand.
r1 as (
  insert into public.transmissions (name, body, is_admin, parent_id, created_at)
  select
    'The Judith',
    'Your wife is correct. Seek help. Then watch it a fourth time.',
    true,
    p1.id,
    now() - interval '18 days'
  from p1
  returning id
),
r2 as (
  insert into public.transmissions (name, body, is_admin, parent_id, created_at)
  select
    'The Judith',
    'You would die for him. He would not notice. This is the healthiest relationship on the ship.',
    true,
    p2.id,
    now() - interval '15 days'
  from p2
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select
  'The Judith',
  'Noted. The tagline has been reported to the Captain, who filed it, lost it, and took credit for finding it. Your grandmother is a stronger editor than anyone on this crew.',
  true,
  p5.id,
  now() - interval '7 days'
from p5;
