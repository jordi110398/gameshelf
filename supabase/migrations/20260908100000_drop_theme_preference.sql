-- S'elimina el selector de tema separat (Clar/Fosc/GBA): el color de la
-- fusta de l'estanteria ja determina el tema visual de tota l'app, així
-- que queda tot més homogeni amb una sola preferència en lloc de dues.

alter table public.profiles
  drop constraint if exists profiles_theme_preference_check;

alter table public.profiles
  drop column if exists theme_preference;
