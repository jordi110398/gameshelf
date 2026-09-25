-- Notificació a tots els amics (accepted) quan algú deixa de jugar un
-- joc, publica una estanteria, escriu una review o afegeix un joc a la
-- biblioteca. SECURITY DEFINER perquè necessita llegir `friendships`
-- (sense SELECT directe pel client) i escriure a `notifications` (sense
-- INSERT pel client).

create or replace function public.notify_friends_of_activity() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  insert into notifications (
    user_id, actor_id, type, activity_id, game_title, shelf_id, shelf_title
  )
  select
    case when f.requester_id = new.user_id then f.receiver_id else f.requester_id end,
    new.user_id,
    new.type::text::notification_type,
    new.id,
    new.game_title,
    new.shelf_id,
    new.shelf_title
  from friendships f
  where f.status = 'accepted'
    and (f.requester_id = new.user_id or f.receiver_id = new.user_id);

  return new;
end;
$$;

create trigger trg_notify_friends_of_activity
  after insert on public.activities
  for each row
  when (new.type in ('dropped', 'shelf_published', 'review', 'added_to_library'))
  execute function public.notify_friends_of_activity();

revoke all on function public.notify_friends_of_activity() from public;
revoke all on function public.notify_friends_of_activity() from anon;
revoke all on function public.notify_friends_of_activity() from authenticated;
