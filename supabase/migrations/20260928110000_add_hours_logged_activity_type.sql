-- Nou tipus d'activitat/notificació per registrar hores jugades sense
-- necessàriament completar el joc (p. ex. "@User ha jugat 5 hores a
-- 'Joc'"). Migració separada del trigger que el fa servir, pel mateix
-- motiu que la resta d'ampliacions d'aquests enums.

alter type activity_type add value 'hours_logged';
alter type notification_type add value 'hours_logged';

alter table public.activities
  add column hours_played numeric(6, 1);

alter table public.notifications
  add column hours_played numeric(6, 1);
