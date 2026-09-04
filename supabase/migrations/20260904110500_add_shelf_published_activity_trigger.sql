-- Trigger que registra l'activitat en publicar una estanteria, i
-- actualització de get_activity_feed() perquè la retorni.

create function public.log_shelf_published_activity() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
declare
  cover_urls text[];
begin
  select coalesce(array_agg(cover_url order by position), '{}')
    into cover_urls
  from (
    select g.cover_url, sg.position
    from shelf_games sg
    join games g on g.igdb_id = sg.igdb_id
    where sg.shelf_id = new.id and g.cover_url is not null
    order by sg.position
    limit 4
  ) covers;

  insert into activities (user_id, type, shelf_id, shelf_title, shelf_cover_urls)
  values (new.user_id, 'shelf_published', new.id, new.title, cover_urls);

  return new;
end;
$$;

revoke all on function public.log_shelf_published_activity() from public;

create trigger shelves_log_published_activity
  after insert or update of is_published on public.shelves
  for each row
  when (new.is_published)
  execute function public.log_shelf_published_activity();

-- get_activity_feed() canvia de tipus de retorn -> cal drop + create, i
-- per tant tornar a aplicar el revoke/grant (drop function els esborra).

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
  shelf_id uuid,
  shelf_title text,
  shelf_cover_urls text[],
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
        when requester_id = viewer_id then receiver_id
        else requester_id
      end as friend_id
    from friendships
    where status = 'accepted'
      and (requester_id = viewer_id or receiver_id = viewer_id)
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
      and f.requester_id <> viewer_id
      and f.receiver_id <> viewer_id
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
    where user_id = viewer_id
  ),

  shared_games as (
    select
      ug.user_id,
      count(distinct ug.igdb_id) as shared_game_count
    from user_games ug
    join my_games mg
      on mg.igdb_id = ug.igdb_id
    where ug.user_id <> viewer_id
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
      and a.user_id <> viewer_id

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
    a.shelf_id,
    a.shelf_title,
    a.shelf_cover_urls,
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
