-- Safata de notificacions (sol·licituds d'amistat, acceptacions, likes).
-- Les files només les crearan triggers SECURITY DEFINER (properes
-- migracions), mai el client directament -- mateix patró que `activities`,
-- que tampoc accepta inserts del client.

create type public.notification_type as enum (
  'friend_request',
  'friend_accepted',
  'activity_like'
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  actor_id uuid not null references auth.users(id) on delete cascade,
  type public.notification_type not null,
  friendship_id uuid references public.friendships(id) on delete cascade,
  activity_id uuid references public.activities(id) on delete cascade,
  -- Copiat en el moment de crear la notificació: `activities` no té SELECT
  -- directe, així que un join des de `notifications` no el podria llegir.
  game_title text,
  read_at timestamp with time zone,
  created_at timestamp with time zone not null default now()
);

create index notifications_user_id_created_at_idx
  on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;

create policy "Users can view their own notifications"
  on public.notifications
  for select
  to authenticated
  using (user_id = auth.uid());

-- El WITH CHECK evita que es reassigni user_id/actor_id; el grant de sota
-- limita a més quines columnes es poden tocar (només read_at).
create policy "Users can mark their own notifications as read"
  on public.notifications
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

revoke all on public.notifications from anon;
revoke all on public.notifications from authenticated;

grant select on public.notifications to authenticated;
grant update (read_at) on public.notifications to authenticated;
