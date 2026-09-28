-- Amplia activity_type amb 'paused' (encara no generava cap activitat en
-- pausar un joc) i 'rated' (puntuar sense necessàriament escriure'n una
-- review ni completar-lo). Amplia notification_type perquè "jugant",
-- "completat", "pausat" i "valorat" també notifiquin als amics, no només
-- "abandonat". Migració separada del trigger que les fa servir pel
-- mateix motiu que la resta d'ampliacions d'aquests enums.

alter type activity_type add value 'paused';
alter type activity_type add value 'rated';

alter type notification_type add value 'started_playing';
alter type notification_type add value 'completed';
alter type notification_type add value 'paused';
alter type notification_type add value 'rated';

alter table public.notifications
  add column rating integer;
