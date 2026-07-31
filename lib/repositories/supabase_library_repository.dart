import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/library_game.dart';
import '../models/game.dart';
import '../models/user_game.dart';
import 'library_repository.dart';

class SupabaseLibraryRepository implements LibraryRepository {
  final SupabaseClient client;
  SupabaseLibraryRepository(this.client);

  @override
  Future<List<LibraryGame>> getLibrary() async {
    final response = await client.from('user_games').select('''
        *,
        games(*)
      ''');

    return response.map((row) {
      final game = Game.fromMap(row['games'] as Map<String, dynamic>);

      final userGame = UserGame.fromMap(row);

      return LibraryGame(game: game, userGame: userGame);
    }).toList();
  }

  @override
  Future<void> addGame(LibraryGame game) async {
    final userId = client.auth.currentUser!.id;

    await client.from('user_games').insert({
      ...game.userGame.toMap(),
      'user_id': userId,
    });
  }

  @override
  Future<void> removeGame(int igdbId) async {
    await client.from('user_games').delete().eq('igdb_id', igdbId);
  }

  Future<void> saveGame(Game game) async {
    await client.from("games").upsert(game.toMap(), onConflict: "igdb_id");
  }

  Future<void> addToLibrary(Game game) async {
    await saveGame(game);

    await client.from("user_games").insert({
      "user_id": client.auth.currentUser!.id,
      "igdb_id": game.igdbId,
      "status": "backlog",
      "rating": null,
      "hours_played": 0,
      "favorite": false,
      "review": null,
      "started_at": null,
      "completed_at": null,
    });
  }

  Future<void> updateUserGame(UserGame userGame) async {
    await client
        .from("user_games")
        .update(userGame.toMap())
        .eq("user_id", client.auth.currentUser!.id)
        .eq("igdb_id", userGame.igdbId);
  }

  Future<UserGame?> getUserGame(int igdbId) async {
    final userId = client.auth.currentUser!.id;

    final response = await client
        .from("user_games")
        .select()
        .eq("user_id", userId)
        .eq("igdb_id", igdbId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserGame.fromMap(response);
  }
}
