-- get_llamp_feed() ha de tornar l'emoji de l'estanteria perquè el feed
-- d'amics el pugui mostrar davant del nom, igual que la resta de
-- pantalles. Canvia el tipus de retorn -> cal drop + create.

drop function public.get_llamp_feed(uuid, integer);

create function public.get_llamp_feed(
  viewer_id uuid,
  feed_limit integer default 20
)
returns table (
  shelf_id uuid,
  user_id uuid,
  title text,
  emoji text,
  updated_at timestamp with time zone,
  game_ids integer[]
)
  language sql stable security definer
  set search_path = public
as $$
  select
    s.id,
    s.user_id,
    s.title,
    s.emoji,
    s.updated_at,
    coalesce(
      array_agg(sg.igdb_id order by sg.position) filter (where sg.igdb_id is not null),
      '{}'
    )
  from shelves s
  join friendships f
    on f.status = 'accepted'
    and (
      (f.requester_id = viewer_id and f.receiver_id = s.user_id)
      or (f.receiver_id = viewer_id and f.requester_id = s.user_id)
    )
  left join shelf_games sg on sg.shelf_id = s.id
  where s.is_published
    and s.user_id <> viewer_id
  group by s.id
  order by s.updated_at desc
  limit feed_limit;
$$;

revoke all on function public.get_llamp_feed(uuid, integer) from public;
revoke all on function public.get_llamp_feed(uuid, integer) from anon;
grant execute on function public.get_llamp_feed(uuid, integer) to authenticated;
