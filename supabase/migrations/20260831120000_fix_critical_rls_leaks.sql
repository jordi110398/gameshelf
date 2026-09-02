-- Fix 1: "activities" was readable in full by any authenticated user via
-- "USING (true)", bypassing the friends/relevance logic in get_activity_feed().
-- get_activity_feed() already computes friend/mutual/popular/shared visibility
-- itself, so make it SECURITY DEFINER and remove the direct-read policy so the
-- table can only be read through that function.

drop policy if exists "Authenticated users can read activities" on public.activities;

create or replace function public.get_activity_feed(
  viewer_id uuid,
  feed_limit integer default 30,
  feed_before timestamp with time zone default now()
) returns setof public.activities
  language sql stable security definer
  set search_path = public
as $$
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

  select a.*
  from activities a
  join ranked_activities r
    on r.id = a.id
  order by
    r.relevance_score desc,
    a.created_at desc
  limit feed_limit;
$$;

-- Fix 2: "Profiles are public" had no `TO` clause, so it applied to the
-- default PUBLIC role - including anon - exposing every user's email
-- (a required, non-null column) to unauthenticated requests. Restrict the
-- base table to the owner's own row, and expose a public view with the
-- non-sensitive columns for search / other-profile lookups.

drop policy if exists "Profiles are public" on public.profiles;

create policy "Users can view own profile"
  on public.profiles
  for select
  to authenticated
  using (auth.uid() = id);

create or replace view public.profiles_public as
  select id, nickname, avatar_url, bio, created_at
  from public.profiles;

alter view public.profiles_public owner to postgres;

grant select on public.profiles_public to authenticated;
