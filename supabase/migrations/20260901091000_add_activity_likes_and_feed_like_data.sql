-- Likes a les activitats. Sense policy de SELECT (els comptadors només es
-- llegeixen a través de get_activity_feed(), com passa amb `activities`
-- mateix), però SÍ cal grant de SELECT: Postgres exigeix privilegi de
-- SELECT sobre qualsevol columna llegida en un WHERE/USING d'UPDATE/DELETE,
-- independentment de la RLS -- sense això, treure un like fallaria amb
-- "permission denied" abans que la RLS ni entrés en joc.

create table public.activity_likes (
  id uuid primary key default gen_random_uuid(),
  activity_id uuid not null references public.activities(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamp with time zone not null default now(),
  unique (activity_id, user_id)
);

create index activity_likes_activity_id_idx on public.activity_likes (activity_id);

alter table public.activity_likes enable row level security;

create policy "Users can like activities"
  on public.activity_likes
  for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "Users can unlike their own likes"
  on public.activity_likes
  for delete
  to authenticated
  using (user_id = auth.uid());

revoke all on public.activity_likes from anon;
revoke all on public.activity_likes from authenticated;

grant select, insert, delete on public.activity_likes to authenticated;

-- get_activity_feed() ara torna també like_count/liked_by_me. Com que
-- canvia el tipus de retorn (setof activities -> returns table), cal
-- drop + create -- "create or replace" no permet canviar el tipus de
-- retorn. drop function esborra tots els permisos existents: cal tornar a
-- aplicar el revoke/grant a sota, en aquesta mateixa migració.

drop function public.get_activity_feed(uuid, integer, timestamp with time zone);

create function public.get_activity_feed(
  viewer_id uuid,
  feed_limit integer default 30,
  feed_before timestamp with time zone default now()
) returns table (
  id uuid,
  user_id uuid,
  type public.activity_type,
  game_id bigint,
  game_title text,
  game_cover_url text,
  rating integer,
  review_snippet text,
  created_at timestamp with time zone,
  like_count bigint,
  liked_by_me boolean
)
  language sql stable security definer
  set search_path = public
as $$
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
$$;

revoke all on function public.get_activity_feed(uuid, integer, timestamp with time zone) from public;
revoke all on function public.get_activity_feed(uuid, integer, timestamp with time zone) from anon;
grant execute on function public.get_activity_feed(uuid, integer, timestamp with time zone) to authenticated;
