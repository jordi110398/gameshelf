-- Dos nous colors de fusta per a l'estètica de l'estanteria: lila (el
-- mateix lila de marca que ja fa servir l'app) i xiclet (rosa saturat).

alter table public.profiles
  drop constraint profiles_shelf_wood_color_check,
  add constraint profiles_shelf_wood_color_check
    check (shelf_wood_color in (
      'walnut', 'oak', 'ebony', 'cherry', 'birch', 'lilac', 'bubblegum'
    ));
