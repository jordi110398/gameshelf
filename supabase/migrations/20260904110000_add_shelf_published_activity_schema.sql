-- #13: publicar una estanteria al llamp també genera una activitat al
-- resum d'activitats (mateix criteri de visibilitat que la resta:
-- amics/amics d'amics/populars/jocs compartits via get_activity_feed()).
--
-- El nou valor de l'enum no es pot fer servir dins la mateixa transacció
-- en què s'afegeix (mateix motiu pel qual 'friendship_formed' es va
-- afegir en una migració separada del seu trigger): el trigger que
-- l'utilitza va en una migració posterior.

alter type activity_type add value 'shelf_published';

-- Igual que game_title/game_cover_url per als tipus de joc, es
-- desnormalitzen el títol i les cobertes en el moment de publicar perquè
-- l'activitat sobrevisqui si l'estanteria es renombra o s'elimina.
alter table public.activities
  add column shelf_id uuid references public.shelves(id) on delete set null,
  add column shelf_title text,
  add column shelf_cover_urls text[];
