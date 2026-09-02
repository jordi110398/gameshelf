-- Afegeix les dates que faltaven per completar el seguiment de l'estat
-- d'un joc a la biblioteca: quan es va abandonar, quan es va posar en
-- pausa, i quan es va reprendre per última vegada (un sol valor cada
-- una, sobreescrit a cada canvi -- no es guarda un històric complet,
-- igual que ja passava amb started_at/completed_at).
alter table public.user_games
  add column dropped_at date,
  add column paused_at date,
  add column resumed_at date;
