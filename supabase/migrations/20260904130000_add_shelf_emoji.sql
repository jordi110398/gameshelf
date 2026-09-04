-- #13: emoji opcional per identificar visualment una estanteria, triat
-- en crear-la.

alter table public.shelves
  add column emoji text;
