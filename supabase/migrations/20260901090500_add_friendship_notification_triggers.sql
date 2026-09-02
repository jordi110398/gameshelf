-- Notificacions generades automàticament pels canvis a `friendships`.
-- SECURITY DEFINER perquè cal escriure a `notifications`, on el client no
-- té cap grant d'INSERT -- mateix patró que `log_user_game_activity()`.

create or replace function public.notify_friend_request() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  insert into notifications (user_id, actor_id, type, friendship_id)
  values (new.receiver_id, new.requester_id, 'friend_request', new.id);

  return new;
end;
$$;

create trigger trg_notify_friend_request
  after insert on public.friendships
  for each row
  execute function public.notify_friend_request();

create or replace function public.notify_friend_accepted() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  insert into notifications (user_id, actor_id, type, friendship_id)
  values (new.requester_id, new.receiver_id, 'friend_accepted', new.id);

  return new;
end;
$$;

create trigger trg_notify_friend_accepted
  after update on public.friendships
  for each row
  when (old.status is distinct from new.status and new.status = 'accepted')
  execute function public.notify_friend_accepted();

-- Cap d'aquestes dues funcions s'ha de poder cridar directament com a RPC.
revoke all on function public.notify_friend_request() from public;
revoke all on function public.notify_friend_request() from anon;
revoke all on function public.notify_friend_request() from authenticated;

revoke all on function public.notify_friend_accepted() from public;
revoke all on function public.notify_friend_accepted() from anon;
revoke all on function public.notify_friend_accepted() from authenticated;
