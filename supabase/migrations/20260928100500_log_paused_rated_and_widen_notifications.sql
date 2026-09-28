-- Registra activitat en pausar un joc, i en puntuar-lo quan aquesta
-- puntuació no ja queda recollida per una activitat "completed" o
-- "review" (per no duplicar-la dues vegades en la mateixa acció).
-- Amplia el trigger de notificacions perquè avisi els amics de
-- pràcticament qualsevol activitat -- no només abandonar un joc,
-- publicar una estanteria, escriure una review o afegir-lo -- excepte
-- `friendship_formed`, que ja té el seu propi avís via `friend_accepted`.

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

  return new;
end;
$$;

drop trigger if exists trg_notify_friends_of_activity on public.activities;

create or replace function public.notify_friends_of_activity() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  insert into notifications (
    user_id, actor_id, type, activity_id, game_title, shelf_id, shelf_title, rating
  )
  select
    case when f.requester_id = new.user_id then f.receiver_id else f.requester_id end,
    new.user_id,
    new.type::text::notification_type,
    new.id,
    new.game_title,
    new.shelf_id,
    new.shelf_title,
    new.rating
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
      'review', 'added_to_library', 'shelf_published'
    )
  )
  execute function public.notify_friends_of_activity();

revoke all on function public.log_user_game_activity() from public;
revoke all on function public.log_user_game_activity() from anon;
revoke all on function public.log_user_game_activity() from authenticated;

revoke all on function public.notify_friends_of_activity() from public;
revoke all on function public.notify_friends_of_activity() from anon;
revoke all on function public.notify_friends_of_activity() from authenticated;
