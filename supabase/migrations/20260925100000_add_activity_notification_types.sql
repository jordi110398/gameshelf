-- Amplia notification_type perquè els esdeveniments d'activitat (deixar
-- de jugar, publicar una estanteria, escriure una review, afegir un joc
-- a la biblioteca) també generin notificació als amics, no només les
-- sol·licituds d'amistat i els likes. El trigger que les genera va en
-- una migració posterior: un valor nou d'enum no es pot fer servir dins
-- la mateixa transacció en què s'afegeix (mateix motiu pel qual
-- 'shelf_published' es va afegir a activity_type en una migració a part
-- del seu trigger).

alter type notification_type add value 'dropped';
alter type notification_type add value 'shelf_published';
alter type notification_type add value 'review';
alter type notification_type add value 'added_to_library';

-- Denormalitzats igual que game_title, perquè la notificació sobrevisqui
-- si l'estanteria es renombra o s'elimina.
alter table public.notifications
  add column shelf_id uuid references public.shelves(id) on delete set null,
  add column shelf_title text;
