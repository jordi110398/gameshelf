-- Registra activitat en actualitzar les hores jugades d'un joc (p. ex.
-- "@User ha jugat 5 hores a 'Joc'"), sense necessitat de completar-lo.
-- No es dispara si les hores es fixen alhora que es marca com a
-- completat: aquella acció ja queda coberta per la pròpia activitat
-- "completed".
--
-- get_activity_feed() també passa a retornar hours_played -- cal
-- drop + create perquè canvia el tipus de retorn.

create or replace function public.log_user_game_activity() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  if (tg_op = 'INSERT') then
    insert into activities (user_id, type, game_id, game_title, game_cover_url)
    select new.user_id, 'added_to_library', new.igdb_id, g.title, g.cover_url
    from games g where g.igdb_id = new.igdb_id;
  end if;

  if (tg_op = 'UPDATE' and new.status is distinct from old.status) then
    if new.status = 'playing' then
      insert into activities (user_id, type, game_id, game_title, game_cover_url)
      select new.user_id, 'started_playing', new.igdb_id, g.title, g.cover_url
      from games g where g.igdb_id = new.igdb_id;
    elsif new.status = 'completed' then
      insert into activities (user_id, type, game_id, game_title, game_cover_url, rating)
      select new.user_id, 'completed', new.igdb_id, g.title, g.cover_url, new.rating
      from games g where g.igdb_id = new.igdb_id;
    elsif new.status = 'dropped' then
      insert into activities (user_id, type, game_id, game_title, game_cover_url)
      select new.user_id, 'dropped', new.igdb_id, g.title, g.cover_url
      from games g where g.igdb_id = new.igdb_id;
    elsif new.status = 'paused' then
      insert into activities (user_id, type, game_id, game_title, game_cover_url)
      select new.user_id, 'paused', new.igdb_id, g.title, g.cover_url
      from games g where g.igdb_id = new.igdb_id;
    end if;
  end if;

  if (tg_op = 'UPDATE' and new.review is distinct from old.review
      and new.review is not null and trim(new.review) <> '') then
    insert into activities (user_id, type, game_id, game_title, game_cover_url, rating, review_snippet)
    select
      new.user_id, 'review', new.igdb_id, g.title, g.cover_url, new.rating,
      case
        when length(new.review) > 140 then left(new.review, 140) || '…'
        else new.review
      end
    from games g where g.igdb_id = new.igdb_id;
  end if;

  -- Puntuació sense review ni acabat de completar en el mateix moment
  -- (aquests dos casos ja porten la puntuació enganxada a la seva pròpia
  -- activitat, més amunt).
  if (tg_op = 'UPDATE' and new.rating is distinct from old.rating
      and new.rating is not null
      and not (new.status is distinct from old.status and new.status = 'completed')
      and not (new.review is distinct from old.review
        and new.review is not null and trim(new.review) <> '')) then
    insert into activities (user_id, type, game_id, game_title, game_cover_url, rating)
    select new.user_id, 'rated', new.igdb_id, g.title, g.cover_url, new.rating
    from games g where g.igdb_id = new.igdb_id;
  end if;

  -- Hores jugades actualitzades, tret que sigui perquè s'acaba de marcar
  -- com a completat en la mateixa acció (ja ho explica l'activitat
  -- "completed").
  if (tg_op = 'UPDATE' and new.hours_played is distinct from old.hours_played
      and new.hours_played is not null and new.hours_played > 0
      and not (new.status is distinct from old.status and new.status = 'completed')) then
    insert into activities (user_id, type, game_id, game_title, game_cover_url, hours_played)
    select new.user_id, 'hours_logged', new.igdb_id, g.title, g.cover_url, new.hours_played
    from games g where g.igdb_id = new.igdb_id;
  end if;

  return new;
end;
$$;

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
  hours_played numeric,
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
    a.hours_played,
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

drop trigger if exists trg_notify_friends_of_activity on public.activities;

create or replace function public.notify_friends_of_activity() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  insert into notifications (
    user_id, actor_id, type, activity_id, game_title, shelf_id, shelf_title,
    rating, hours_played
  )
  select
    case when f.requester_id = new.user_id then f.receiver_id else f.requester_id end,
    new.user_id,
    new.type::text::notification_type,
    new.id,
    new.game_title,
    new.shelf_id,
    new.shelf_title,
    new.rating,
    new.hours_played
  from friendships f
  where f.status = 'accepted'
    and (f.requester_id = new.user_id or f.receiver_id = new.user_id);

  return new;
end;
$$;

create trigger trg_notify_friends_of_activity
  after insert on public.activities
  for each row
  when (
    new.type in (
      'started_playing', 'completed', 'dropped', 'paused', 'rated',
      'hours_logged', 'review', 'added_to_library', 'shelf_published'
    )
  )
  execute function public.notify_friends_of_activity();

revoke all on function public.log_user_game_activity() from public;
revoke all on function public.log_user_game_activity() from anon;
revoke all on function public.log_user_game_activity() from authenticated;

revoke all on function public.notify_friends_of_activity() from public;
revoke all on function public.notify_friends_of_activity() from anon;
revoke all on function public.notify_friends_of_activity() from authenticated;
