import 'package:gameshelf/models/user_game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGameService {
  final _supabase = Supabase.instance.client;

  /// Retorna tota la biblioteca de l'usuari actual
  Future<List<UserGame>> getLibrary() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("L'usuari no ha iniciat sessió.");
    }

    final response = await _supabase
        .from("user_games")
        .select()
        .eq("user_id", user.id);

    return (response as List).map((json) => UserGame.fromMap(json)).toList();
  }

  /// Afegeix un joc a la biblioteca
  Future<void> addGame(UserGame game) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("L'usuari no ha iniciat sessió.");
    }

    await _supabase.from("user_games").insert({
      ...game.toMap(),
      "user_id": user.id,
    });
  }

  /// Actualitza la informació d'un joc
  Future<void> updateGame(UserGame game) async {
    await _supabase
        .from("user_games")
        .update(game.toMap())
        .eq("igdb_id", game.igdbId);
        final user = _supabase.auth.currentUser;
        if (user == null) {
          throw Exception("L'usuari no ha iniciat sessió.");
        }
        await _supabase
            .from("user_games")
            .update(game.toMap())
            .eq("user_id", user.id)
            .eq("igdb_id", game.igdbId);
  }

  /// Elimina un joc de la biblioteca
  Future<void> removeGame(int igdbId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("L'usuari no ha iniciat sessió.");
    }

    await _supabase
        .from("user_games")
        .delete()
        .eq("user_id", user.id)
        .eq("igdb_id", igdbId);
  }

  /// Comprova si un joc ja és a la biblioteca
  Future<bool> exists(int igdbId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return false;
    }

    final response = await _supabase
        .from("user_games")
        .select("igdb_id")
        .eq("user_id", user.id)
        .eq("igdb_id", igdbId)
        .maybeSingle();

    return response != null;
  }
}
