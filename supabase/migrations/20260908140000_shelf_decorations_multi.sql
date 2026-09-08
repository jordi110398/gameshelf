-- Permet triar més d'una planta alhora com a decoració de l'estanteria
-- (abans només se'n podia triar una). Substitueix la columna singular
-- `shelf_decoration` per un array `shelf_decorations`.

alter table public.profiles
  add column shelf_decorations text[] not null default '{}';

update public.profiles
set shelf_decorations = case
  when shelf_decoration = 'none' then '{}'::text[]
  else array[shelf_decoration]
end;

-- Cal redefinir la vista abans d'esborrar la columna vella: encara hi
-- depèn. `create or replace` no permet canviar el nom d'una columna
-- existent, cal esborrar-la i tornar-la a crear.
drop view if exists public.profiles_public;

create view public.profiles_public as
  select id, nickname, avatar_url, bio, created_at,
         shelf_light_style, shelf_wood_color, shelf_decorations,
         shelf_cover_style
  from public.profiles;

grant select on public.profiles_public to authenticated;

alter table public.profiles
  drop constraint if exists profiles_shelf_decoration_check;

alter table public.profiles
  drop column shelf_decoration;

alter table public.profiles
  add constraint profiles_shelf_decorations_check
    check (shelf_decorations <@ array['poppy', 'cactus', 'azalea']::text[]);
