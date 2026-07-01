begin;

delete from public.transmissions;

-- Thread 1
with t1 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('Tillie', 'i need this on netflix asap thx', false, now() - interval '2 hours')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t1.id, v.created_at
from t1,
  (values
    ('The Judith', 'Working on it :)', true, now() - interval '90 minutes'),
    ('David Lev', 'same here', false, now() - interval '60 minutes')
  ) as v(name, body, is_admin, created_at);

-- Thread 2
with t2 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('Phil Cohen', 'lol lol and more lol. great work guys! following.', false, now() - interval '1 day')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t2.id, v.created_at
from t2,
  (values
    ('The Judith', 'thanks phil! stick around, more content will be available soon.', true, now() - interval '23 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 3
with t3 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('free palestine', 'a show about jews, yeah that''s what we need right now…', false, now() - interval '2 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t3.id, v.created_at
from t3,
  (values
    ('The Judith', 'we finally agree on something :)', true, now() - interval '47 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 4
with t4 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('oron levy', 'don''t mind the haters! it looks cool!!!! more jewish content please!!!!', false, now() - interval '3 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t4.id, v.created_at
from t4,
  (values
    ('The Judith', 'we''re on it 💪', true, now() - interval '71 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 5 (no reply)
insert into public.transmissions (name, body, is_admin, created_at)
values ('Lina', 'Because of people like you Jews want to run away to outer space.', false, now() - interval '4 days');

-- Thread 6
with t6 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('dana', 'wow! we just watched the promo. it is supposed to be like a Jewish Rick & Morty?', false, now() - interval '5 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t6.id, v.created_at
from t6,
  (values
    ('The Judith', 'It''s supposed to be the Jewish The Judith 😂but love the comparison. follow us to stay in the loop.', true, now() - interval '119 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 7
with t7 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('just a jew', 'when will the first episode be available and where?', false, now() - interval '6 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t7.id, v.created_at
from t7,
  (values
    ('The Judith', 'The pilot episode "In Our Image" will be available right here on this site on July 29th.', true, now() - interval '143 hours'),
    ('Tillie', 'yeyyyyyy!!!', false, now() - interval '142 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 8
with t8 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('paul', 'looks good', false, now() - interval '7 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t8.id, v.created_at
from t8,
  (values
    ('The Judith', 'Thanks Paul! sign up to the website to stay informed!', true, now() - interval '167 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 9
with t9 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('Lina', 'A Robot. lol.', false, now() - interval '8 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t9.id, v.created_at
from t9,
  (values
    ('The Judith', '😂yeah we like him. small, yet effective.', true, now() - interval '191 hours')
  ) as v(name, body, is_admin, created_at);

-- Thread 10
with t10 as (
  insert into public.transmissions (name, body, is_admin, created_at)
  values ('Ksenia', 'WOW!!! waiting to the first episode 🙂', false, now() - interval '9 days')
  returning id
)
insert into public.transmissions (name, body, is_admin, parent_id, created_at)
select v.name, v.body, v.is_admin, t10.id, v.created_at
from t10,
  (values
    ('The Judith', 'Yes!! thanks Ksenia! the first one will be available right here on the website on July 29th. can''t wait to hear what you think about it.', true, now() - interval '215 hours')
  ) as v(name, body, is_admin, created_at);

commit;
