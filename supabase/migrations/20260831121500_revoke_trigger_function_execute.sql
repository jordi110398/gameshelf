-- handle_new_user / log_user_game_activity / rls_auto_enable each had an
-- explicit "GRANT ALL ... TO anon/authenticated" in addition to the implicit
-- PUBLIC grant. Revoking PUBLIC alone (previous migration) doesn't remove a
-- separate, explicit grant to a named role - the advisor confirmed these
-- three were still listed as executable by anon and authenticated. None of
-- them are meant to be called directly (two are trigger functions, one is an
-- event trigger function), so revoke both roles outright.

revoke all on function public.handle_new_user() from anon, authenticated;
revoke all on function public.log_user_game_activity() from anon, authenticated;
revoke all on function public.rls_auto_enable() from anon, authenticated;
