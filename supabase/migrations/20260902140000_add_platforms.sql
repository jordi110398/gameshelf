-- Plataformes en què surt el joc (segons IGDB), i la plataforma concreta
-- en què l'usuari l'ha jugat (una de sola, triada de la llista anterior o
-- "No especificat").
alter table public.games
  add column platforms text[];

alter table public.user_games
  add column platform text;
