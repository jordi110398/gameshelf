-- Afegeix `friend_id` al retorn de get_activity_feed() perquè el client
-- pugui mostrar les dues persones implicades en una activitat de tipus
-- 'friendship_formed'. Canvia el tipus de retorn -> cal drop + create
-- (no funciona amb `create or replace`), i per tant cal tornar a aplicar
-- els grants perquè `drop function` els esborra.
drop function public.get_activity_feed(uuid, integer, timestamp with time zone);

create function public.get_activity_feed(
  viewer_id uuid,
  feed_limit integer default 30,
  feed_before timestamp with time zone default now()
)
returns table(
  id uuid,
  user_id uuid,
  type activity_type,
  game_id bigint,
  game_title text,
  game_cover_url text,
  rating integer,
  review_snippet text,
  friend_id uuid,
  created_at timestamp with time zone,
  like_count bigint,
  liked_by_me boolean
)
language sql
stable
security definer
set search_path = public
as $function$
  with my_friends as (
    select distinct
      case
        when requester_id = auth.uid() then receiver_id
        else requester_id
      end as friend_id
    from friendships
    where status = 'accepted'
      and (requester_id = auth.uid() or receiver_id = auth.uid())
  ),

  mutual_friends as (
    select
      case
        when f.requester_id = mf.friend_id then f.receiver_id
        else f.requester_id
      end as user_id,
      count(distinct mf.friend_id) as mutual_count
    from friendships f
    join my_friends mf
      on mf.friend_id = f.requester_id
      or mf.friend_id = f.receiver_id
    where f.status = 'accepted'
      and f.requester_id <> auth.uid()
      and f.receiver_id <> auth.uid()
    group by
      case
        when f.requester_id = mf.friend_id then f.receiver_id
        else f.requester_id
      end
  ),

  friend_counts as (
    select
      user_id,
      count(*) as friend_count
    from (
      select requester_id as user_id
      from friendships
      where status = 'accepted'

      union all

      select receiver_id as user_id
      from friendships
      where status = 'accepted'
    ) f
    group by user_id
  ),

  popular_users as (
    select user_id
    from friend_counts
    where friend_count >= 15
  ),

  my_games as (
    select distinct igdb_id
    from user_games
    where user_id = auth.uid()
  ),

  shared_games as (
    select
      ug.user_id,
      count(distinct ug.igdb_id) as shared_game_count
    from user_games ug
    join my_games mg
      on mg.igdb_id = ug.igdb_id
    where ug.user_id <> auth.uid()
    group by ug.user_id
  ),

  ranked_activities as (
    select
      a.id,

      (
        case
          when a.user_id in (
            select friend_id
            from my_friends
          )
          then 100
          else 0
        end

        +

        coalesce(
          (
            select mutual_count * 20
            from mutual_friends mf
            where mf.user_id = a.user_id
          ),
          0
        )

        +

        case
          when a.user_id in (
            select user_id
            from popular_users
          )
          then 10
          else 0
        end

        +

        coalesce(
          (
            select least(shared_game_count * 5, 25)
            from shared_games sg
            where sg.user_id = a.user_id
          ),
          0
        )

        +

        greatest(
          0,
          20 - floor(
            extract(
              epoch from (now() - a.created_at)
            ) / 3600
          )::int
        )
      ) as relevance_score

    from activities a

    where a.created_at < feed_before
      and a.user_id <> auth.uid()

      and (
        a.user_id in (
          select friend_id
          from my_friends
        )

        or a.user_id in (
          select user_id
          from mutual_friends
        )

        or a.user_id in (
          select user_id
          from popular_users
        )

        or a.user_id in (
          select user_id
          from shared_games
        )
      )
  )

  select
    a.id,
    a.user_id,
    a.type,
    a.game_id,
    a.game_title,
    a.game_cover_url,
    a.rating,
    a.review_snippet,
    a.friend_id,
    a.created_at,
    coalesce(lc.like_count, 0) as like_count,
    (ml.user_id is not null) as liked_by_me
  from activities a
  join ranked_activities r
    on r.id = a.id
  left join (
    select activity_id, count(*) as like_count
    from activity_likes
    group by activity_id
  ) lc on lc.activity_id = a.id
  left join activity_likes ml
    on ml.activity_id = a.id and ml.user_id = auth.uid()
  order by
    r.relevance_score desc,
    a.created_at desc
  limit feed_limit;
$function$;

revoke all on function public.get_activity_feed(uuid, integer, timestamp with time zone) from public, anon;
grant execute on function public.get_activity_feed(uuid, integer, timestamp with time zone) to authenticated;
