-- Permet desar hores amb decimals (p. ex. 12.5h), no només enters.

alter table public.user_games
  alter column hours_played type numeric(6, 1)
  using hours_played::numeric(6, 1);

alter table public.user_games
  alter column hours_played set default 0;
