-- Postgres grants EXECUTE to PUBLIC by default when a function is created,
-- regardless of any later "REVOKE ... FROM anon". The Supabase security
-- advisor confirmed get_activity_feed was still callable by anon through
-- that PUBLIC grant. Revoke PUBLIC explicitly and re-grant only what's
-- actually needed.

revoke all on function public.get_activity_feed(uuid, integer, timestamp with time zone) from public;
grant execute on function public.get_activity_feed(uuid, integer, timestamp with time zone) to authenticated;

-- handle_new_user / log_user_game_activity are trigger functions and
-- rls_auto_enable is an event trigger function: none of them are meant to be
-- called directly as an RPC. Postgres's implicit PUBLIC EXECUTE grant
-- currently exposes them via PostgREST anyway (harmlessly, since calling a
-- trigger function outside of trigger context errors out) - revoke that
-- exposure for defense in depth.

revoke all on function public.handle_new_user() from public;
revoke all on function public.log_user_game_activity() from public;
revoke all on function public.rls_auto_enable() from public;

-- log_user_game_activity is SECURITY DEFINER without a pinned search_path,
-- unlike the other SECURITY DEFINER functions in this schema. Fix the same
-- search-path-hijacking gap the advisor flags on it.

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
    end if;
  end if;

  if (tg_op = 'UPDATE' and new.review is distinct from old.review
      and new.review is not null and trim(new.review) <> '') then
    insert into activities (user_id, type, game_id, game_title, game_cover_url, rating, review_snippet)
    select new.user_id, 'review', new.igdb_id, g.title, g.cover_url, new.rating, left(new.review, 140)
    from games g where g.igdb_id = new.igdb_id;
  end if;

  return new;
end;
$$;
