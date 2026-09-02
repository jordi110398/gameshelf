-- `games` is a read-only local cache of IGDB catalog data. It currently has
-- 3 overlapping permissive policies predating this project's tracked RLS
-- work (created directly against the DB, never migrated) that together let
-- any authenticated client insert/update/delete rows with
-- USING(true)/WITH CHECK(true), plus this project's default blanket
-- GRANT ALL to anon/authenticated left over from table creation. All writes
-- now go exclusively through the `save-game` edge function (service_role,
-- bypasses RLS) after validating the caller's JWT there. Replace all of the
-- above with a single read-only policy, matching the read pattern already
-- used for profiles_public.

drop policy if exists "Authenticated users can manage games" on public.games;
drop policy if exists "Users autentificats INSERT games" on public.games;
drop policy if exists "Users autentificats SELECT games" on public.games;

revoke all on public.games from anon;
revoke all on public.games from authenticated;

grant select on public.games to authenticated;

create policy "Authenticated users can view games"
  on public.games
  for select
  to authenticated
  using (true);
