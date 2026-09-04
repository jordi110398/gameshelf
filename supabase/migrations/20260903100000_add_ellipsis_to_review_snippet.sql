-- El fragment de review que es desa a activities.review_snippet es
-- retallava a 140 caràcters sense cap indicació visual de tall, fent
-- que semblés una frase completa. Afegim "…" quan realment es talla.
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
    select
      new.user_id, 'review', new.igdb_id, g.title, g.cover_url, new.rating,
      case
        when length(new.review) > 140 then left(new.review, 140) || '…'
        else new.review
      end
    from games g where g.igdb_id = new.igdb_id;
  end if;

  return new;
end;
$$;
