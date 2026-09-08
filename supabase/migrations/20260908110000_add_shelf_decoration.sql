-- Element decoratiu opcional (planta) a l'extrem de l'estanteria, com a
-- tercera preferència pública d'estètica al costat de la fusta i els
-- llums.

alter table public.profiles
  add column shelf_decoration text not null default 'none';

alter table public.profiles
  add constraint profiles_shelf_decoration_check
    check (shelf_decoration in ('none', 'poppy', 'cactus', 'azalea'));

create or replace view public.profiles_public as
  select id, nickname, avatar_url, bio, created_at,
         shelf_light_style, shelf_wood_color, shelf_decoration
  from public.profiles;

grant select on public.profiles_public to authenticated;
