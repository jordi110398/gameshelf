-- Nou tipus d'activitat per anunciar al feed quan dos usuaris es fan amics.
alter type activity_type add value 'friendship_formed';

-- Les activitats de tipus 'friendship_formed' no tenen cap joc associat.
alter table public.activities
  alter column game_id drop not null,
  alter column game_title drop not null;

-- Segona persona implicada en l'activitat (només s'omple per a
-- 'friendship_formed': l'altre membre de l'amistat).
alter table public.activities
  add column friend_id uuid references auth.users(id) on delete cascade;
