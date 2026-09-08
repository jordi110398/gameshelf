-- Pestanya del llamp (#13): estanteries/col·leccions personalitzables
-- (fins a 8 jocs, fixables al perfil i publicables com a "llistes" pels
-- amics) + recomanacions personalitzades. Mateix patró de seguretat que
-- la resta del projecte: aquest projecte no auto-exposa taules noves a
-- la Data API, així que cal revoke/grant explícits a més de la RLS; els
-- feeds agregats es fan amb funcions `security definer` i `search_path`
-- fixat (mateix estil que `get_activity_feed`/`get_my_review_likes`).

-- ─────────────────────────────────────────────
-- TAULA: shelves (estanteries/col·leccions)
-- ─────────────────────────────────────────────

create table public.shelves (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  is_pinned boolean not null default false,
  is_published boolean not null default false,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now()
);

-- Com a molt una estanteria fixada per usuari.
create unique index shelves_one_pinned_per_user
  on public.shelves (user_id)
  where is_pinned;

create index shelves_user_id_idx on public.shelves (user_id);

alter table public.shelves enable row level security;

create policy "Users manage own shelves"
  on public.shelves
  for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Una estanteria fixada té la mateixa visibilitat que la resta del
-- perfil/biblioteca d'un usuari (ja públic per a qualsevol autenticat,
-- vegeu la policy "Users can view friend's games" de user_games).
create policy "Pinned shelves are visible to any authenticated user"
  on public.shelves
  for select
  to authenticated
  using (is_pinned);

-- Publicar-la al llamp, en canvi, només l'ensenya als amics (mateix
-- criteri d'amistat que get_activity_feed).
create policy "Friends can view published shelves"
  on public.shelves
  for select
  to authenticated
  using (
    is_published
    and exists (
      select 1
      from public.friendships f
      where f.status = 'accepted'
        and (
          (f.requester_id = auth.uid() and f.receiver_id = shelves.user_id)
          or (f.receiver_id = auth.uid() and f.requester_id = shelves.user_id)
        )
    )
  );

revoke all on public.shelves from anon;
revoke all on public.shelves from authenticated;

grant select, insert, update, delete on public.shelves to authenticated;

-- ─────────────────────────────────────────────
-- TAULA: shelf_games (jocs dins d'una estanteria)
-- ─────────────────────────────────────────────

create table public.shelf_games (
  id uuid primary key default gen_random_uuid(),
  shelf_id uuid not null references public.shelves(id) on delete cascade,
  igdb_id integer not null references public.games(igdb_id) on delete cascade,
  position smallint not null default 0,
  created_at timestamp with time zone not null default now(),
  unique (shelf_id, igdb_id)
);

create index shelf_games_shelf_id_idx on public.shelf_games (shelf_id);

alter table public.shelf_games enable row level security;

create policy "Users manage games in own shelves"
  on public.shelf_games
  for all
  to authenticated
  using (
    exists (
      select 1 from public.shelves s
      where s.id = shelf_games.shelf_id and s.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.shelves s
      where s.id = shelf_games.shelf_id and s.user_id = auth.uid()
    )
  );

create policy "Anyone can view games of pinned shelves"
  on public.shelf_games
  for select
  to authenticated
  using (
    exists (
      select 1 from public.shelves s
      where s.id = shelf_games.shelf_id and s.is_pinned
    )
  );

create policy "Friends can view games of published shelves"
  on public.shelf_games
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.shelves s
      where s.id = shelf_games.shelf_id
        and s.is_published
        and exists (
          select 1
          from public.friendships f
          where f.status = 'accepted'
            and (
              (f.requester_id = auth.uid() and f.receiver_id = s.user_id)
              or (f.receiver_id = auth.uid() and f.requester_id = s.user_id)
            )
        )
    )
  );

revoke all on public.shelf_games from anon;
revoke all on public.shelf_games from authenticated;

grant select, insert, update, delete on public.shelf_games to authenticated;

-- ─────────────────────────────────────────────
-- MÀXIM 8 JOCS PER ESTANTERIA (trigger, font de veritat a la BD)
-- ─────────────────────────────────────────────

create function public.enforce_shelf_max_games() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  if (select count(*) from shelf_games where shelf_id = new.shelf_id) >= 8 then
    raise exception 'Una estanteria pot tenir com a màxim 8 jocs';
  end if;

  return new;
end;
$$;

revoke all on function public.enforce_shelf_max_games() from public;

create trigger shelf_games_max_8
  before insert on public.shelf_games
  for each row execute function public.enforce_shelf_max_games();

-- ─────────────────────────────────────────────
-- ACTUALITZAR shelves.updated_at EN TOCAR ELS SEUS JOCS
-- (perquè el feed del llamp ordeni per activitat recent)
-- ─────────────────────────────────────────────

create function public.touch_shelf_updated_at() returns trigger
  language plpgsql security definer
  set search_path = public
as $$
begin
  update shelves
  set updated_at = now()
  where id = coalesce(new.shelf_id, old.shelf_id);

  return coalesce(new, old);
end;
$$;

revoke all on function public.touch_shelf_updated_at() from public;

create trigger shelf_games_touch_shelf
  after insert or update or delete on public.shelf_games
  for each row execute function public.touch_shelf_updated_at();

-- ─────────────────────────────────────────────
-- RPC: get_llamp_feed -- estanteries publicades pels amics
-- ─────────────────────────────────────────────

create function public.get_llamp_feed(
  viewer_id uuid,
  feed_limit integer default 20
)
returns table (
  shelf_id uuid,
  user_id uuid,
  title text,
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

-- ─────────────────────────────────────────────
-- RPC: get_recommendations -- gèneres propis + biblioteques d'amics
-- ─────────────────────────────────────────────

create function public.get_recommendations(
  viewer_id uuid,
  rec_limit integer default 12
)
returns table (
  igdb_id integer,
  score numeric
)
  language sql stable security definer
  set search_path = public
as $$
  with my_top_genres as (
    select unnest(g.genres) as genre, count(*) as weight
    from user_games ug
    join games g on g.igdb_id = ug.igdb_id
    where ug.user_id = viewer_id
      and (ug.rating >= 4 or ug.status = 'completed' or ug.favorite)
      and g.genres is not null
    group by genre
    order by weight desc
    limit 5
  ),

  my_games as (
    select igdb_id from user_games where user_id = viewer_id
  ),

  friend_ids as (
    select
      case when requester_id = viewer_id then receiver_id else requester_id end as friend_id
    from friendships
    where status = 'accepted'
      and (requester_id = viewer_id or receiver_id = viewer_id)
  ),

  candidates as (
    select
      ug.igdb_id,
      count(distinct ug.user_id) as friend_count,
      max(coalesce(mtg.weight, 0)) as genre_weight
    from user_games ug
    join friend_ids fr on fr.friend_id = ug.user_id
    join games g on g.igdb_id = ug.igdb_id
    left join lateral (
      select t.weight
      from my_top_genres t
      where t.genre = any(g.genres)
      order by t.weight desc
      limit 1
    ) mtg on true
    where ug.igdb_id not in (select igdb_id from my_games)
    group by ug.igdb_id
  )

  select
    igdb_id,
    (friend_count * 10 + genre_weight)::numeric as score
  from candidates
  order by score desc, igdb_id
  limit rec_limit;
$$;

revoke all on function public.get_recommendations(uuid, integer) from public;
revoke all on function public.get_recommendations(uuid, integer) from anon;
grant execute on function public.get_recommendations(uuid, integer) to authenticated;
