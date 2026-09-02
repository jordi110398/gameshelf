-- Notificació quan algú dona like a una activitat (llevat que sigui la
-- pròpia). SECURITY DEFINER perquè necessita llegir `activities` (sense
-- SELECT directe) i escriure a `notifications` (sense INSERT per al client).

create or replace function public.notify_activity_like() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
declare
  activity_owner uuid;
  activity_game_title text;
begin
  select user_id, game_title
  into activity_owner, activity_game_title
  from activities
  where id = new.activity_id;

  if activity_owner is not null and activity_owner <> new.user_id then
    insert into notifications (user_id, actor_id, type, activity_id, game_title)
    values (activity_owner, new.user_id, 'activity_like', new.activity_id, activity_game_title);
  end if;

  return new;
end;
$$;

create trigger trg_notify_activity_like
  after insert on public.activity_likes
  for each row
  execute function public.notify_activity_like();

revoke all on function public.notify_activity_like() from public;
revoke all on function public.notify_activity_like() from anon;
revoke all on function public.notify_activity_like() from authenticated;
