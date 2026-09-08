-- Configuració: tema de l'app (personal) + estètica de l'estanteria
-- (pública, com el banner generat pels tags -- els altres usuaris la
-- veuen en visitar el perfil).

alter table public.profiles
  add column shelf_light_style text not null default 'neon',
  add column shelf_wood_color text not null default 'walnut',
  add column theme_preference text not null default 'dark';

alter table public.profiles
  add constraint profiles_shelf_light_style_check
    check (shelf_light_style in ('neon', 'bulbs')),
  add constraint profiles_shelf_wood_color_check
    check (shelf_wood_color in ('walnut', 'oak', 'ebony', 'cherry', 'birch')),
  add constraint profiles_theme_preference_check
    check (theme_preference in ('light', 'dark', 'gba'));

-- shelf_light_style/shelf_wood_color són públics (com nickname/avatar);
-- theme_preference és personal i es queda fora d'aquesta vista.
create or replace view public.profiles_public as
  select id, nickname, avatar_url, bio, created_at,
         shelf_light_style, shelf_wood_color
  from public.profiles;

grant select on public.profiles_public to authenticated;
