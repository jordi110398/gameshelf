-- Correcció trobada en provar el flux real: sense CAP policy de SELECT,
-- Postgres no pot resoldre quines files existeixen per a un DELETE (calia
-- per "unlike"), tot i que la policy USING del propi DELETE ja restringeix
-- correctament a `user_id = auth.uid()`. Provat directament: amb només
-- INSERT+DELETE, `delete from activity_likes where user_id = auth.uid()`
-- no esborrava cap fila (0 files afectades, sense error); afegint aquesta
-- policy de SELECT, el DELETE torna a funcionar com s'esperava.
--
-- Aquesta policy només permet a cada usuari veure ELS SEUS PROPIS likes
-- (mai els d'altres usuaris, ni el recompte agregat d'una activitat) --
-- no suposa cap fuga de dades: ja saps què has donat like tu mateix, i el
-- comptador públic (`like_count`) es continua servint només a través de
-- get_activity_feed().

create policy "Users can view their own likes"
  on public.activity_likes
  for select
  to authenticated
  using (user_id = auth.uid());
