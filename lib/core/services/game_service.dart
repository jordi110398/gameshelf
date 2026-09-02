import 'package:gameshelf/models/game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameService {
  final _supabase = Supabase.instance.client;

  Future<Game?> getGame(int igdbId) async {
    final response = await _supabase
        .from("games")
        .select()
        .eq("igdb_id", igdbId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Game.fromMap(response);
  }

  Future<void> insertGame(Game game) async {
    await _supabase
        .from("games")
        .insert(game.toMap());
  }
}