-- Permet activar/desactivar l'estil de coberta "cartutx" (i deixa la
-- porta oberta a futures variants) com a quarta preferència pública
-- d'estètica, al costat de fusta, llums i decoració.

alter table public.profiles
  add column shelf_cover_style text not null default 'cartridge';

alter table public.profiles
  add constraint profiles_shelf_cover_style_check
    check (shelf_cover_style in ('plain', 'cartridge'));

create or replace view public.profiles_public as
  select id, nickname, avatar_url, bio, created_at,
         shelf_light_style, shelf_wood_color, shelf_decoration,
         shelf_cover_style
  from public.profiles;

grant select on public.profiles_public to authenticated;
