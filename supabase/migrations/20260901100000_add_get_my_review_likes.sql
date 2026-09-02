-- Permet a un usuari consultar els likes de les SEVES PRÒPIES reviews
-- (per mostrar-los al seu perfil i a la pàgina de detall del joc). Cal una
-- funció dedicada perquè `activities` no té SELECT directe i
-- `get_activity_feed()` exclou expressament les pròpies activitats
-- (`a.user_id <> auth.uid()`), ja que està pensada per veure les dels
-- altres. `auth.uid()` es fa servir directament (no un paràmetre de
-- l'usuari), així que mai es pot consultar la review d'un altre.

create function public.get_my_review_likes(game_ids bigint[])
returns table (
  game_id bigint,
  like_count bigint,
  liked_by_me boolean
)
  language sql stable security definer
  set search_path = public
as $$
  with my_reviews as (
    select distinct on (a.game_id)
      a.id,
      a.game_id
    from activities a
    where a.user_id = auth.uid()
      and a.type = 'review'
      and a.game_id = any(game_ids)
    order by a.game_id, a.created_at desc
  )
  select
    mr.game_id,
    coalesce(lc.like_count, 0) as like_count,
    (ml.user_id is not null) as liked_by_me
  from my_reviews mr
  left join (
    select activity_id, count(*) as like_count
    from activity_likes
    group by activity_id
  ) lc on lc.activity_id = mr.id
  left join activity_likes ml
    on ml.activity_id = mr.id and ml.user_id = auth.uid();
$$;

revoke all on function public.get_my_review_likes(bigint[]) from public;
revoke all on function public.get_my_review_likes(bigint[]) from anon;
grant execute on function public.get_my_review_likes(bigint[]) to authenticated;
