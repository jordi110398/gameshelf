-- Registra una activitat per a cada membre de l'amistat quan es passa a
-- 'accepted', perquè als amics mutus de qualsevol dels dos els aparegui
-- "@A i @B ara són amics!" al feed (get_activity_feed() ja decideix la
-- visibilitat per `user_id`, així que dues files -- una per banda -- fan
-- que funcioni sense tocar la lògica de rànquing del feed).
create or replace function public.log_friendship_activity()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into activities (user_id, type, friend_id)
  values (new.requester_id, 'friendship_formed', new.receiver_id);

  insert into activities (user_id, type, friend_id)
  values (new.receiver_id, 'friendship_formed', new.requester_id);

  return new;
end;
$$;

revoke all on function public.log_friendship_activity() from public, anon, authenticated;

create trigger trg_log_friendship_activity
  after update on public.friendships
  for each row
  when (old.status is distinct from new.status and new.status = 'accepted')
  execute function public.log_friendship_activity();
