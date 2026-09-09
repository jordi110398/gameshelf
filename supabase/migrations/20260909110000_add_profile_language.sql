-- Idioma de l'app, preferència personal (com l'email) -- no s'afegeix a
-- profiles_public perquè no és rellevant pels altres usuaris.

alter table public.profiles
  add column language text not null default 'ca';

alter table public.profiles
  add constraint profiles_language_check
    check (language in ('ca', 'es', 'en'));
