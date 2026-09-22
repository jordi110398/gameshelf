-- Dos nous estils de llumets per a l'estanteria: estrelles i nadal
-- (verd/vermell/blanc), al costat del neó i les bombetes clàssiques.

alter table public.profiles
  drop constraint profiles_shelf_light_style_check,
  add constraint profiles_shelf_light_style_check
    check (shelf_light_style in ('neon', 'bulbs', 'stars', 'christmas'));
