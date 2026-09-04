import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/library_game.dart';
import '../models/game.dart';
import '../models/user_game.dart';
import '../models/game_status.dart';
import 'library_repository.dart';

class SupabaseLibraryRepository implements LibraryRepository {
  final SupabaseClient client;

  SupabaseLibraryRepository(this.client);

  // ─────────────────────────────────────────────
  // BIBLIOTECA DE L'USUARI ACTUAL
  // ─────────────────────────────────────────────

  @override
  Future<List<LibraryGame>> getLibrary() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    final response = await client
        .from('user_games')
        .select('''
          *,
          games(*)
        ''')
        .eq('user_id', user.id);

    return response.map((row) {
      final game = Game.fromMap(row['games'] as Map<String, dynamic>);

      final userGame = UserGame.fromMap(row);

      return LibraryGame(game: game, userGame: userGame);
    }).toList();
  }

  // ─────────────────────────────────────────────
  // AFEGIR JOC
  // ─────────────────────────────────────────────

  @override
  Future<void> addGame(LibraryGame game) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await client.from('user_games').insert({
      ...game.userGame.toMap(),
      'user_id': user.id,
    });
  }

  // ─────────────────────────────────────────────
  // ELIMINAR JOC
  // ─────────────────────────────────────────────

  @override
  Future<void> removeGame(int igdbId) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await client
        .from('user_games')
        .delete()
        .eq('user_id', user.id)
        .eq('igdb_id', igdbId);
  }

  // ─────────────────────────────────────────────
  // GUARDAR JOC A LA TAULA games
  // ─────────────────────────────────────────────

  Future<void> saveGame(Game game) async {
    final response = await client.functions.invoke(
      'save-game',
      body: game.toMap(),
    );

    if (response.status != 200) {
      throw Exception('No s\'ha pogut desar el joc');
    }
  }

  // ─────────────────────────────────────────────
  // AFEGIR JOC A LA BIBLIOTECA
  // ─────────────────────────────────────────────

  Future<void> addToLibrary(
    Game game, {
    GameStatus status = GameStatus.wantToPlay,
    String? platform,
    int? rating,
    String? review,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? droppedAt,
    DateTime? pausedAt,
  }) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await saveGame(game);

    await client.from('user_games').insert({
      'user_id': user.id,
      'igdb_id': game.igdbId,
      'status': status.databaseValue,
      'rating': rating,
      'hours_played': 0,
      'favorite': false,
      'review': review,
      'platform': platform,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'dropped_at': droppedAt?.toIso8601String(),
      'paused_at': pausedAt?.toIso8601String(),
    });
  }

  // ─────────────────────────────────────────────
  // ACTUALITZAR JOC DE L'USUARI
  // ─────────────────────────────────────────────

  Future<void> updateUserGame(UserGame userGame) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await client
        .from('user_games')
        .update(userGame.toMap())
        .eq('user_id', user.id)
        .eq('igdb_id', userGame.igdbId);
  }

  // ─────────────────────────────────────────────
  // OBTENIR UN JOC DE L'USUARI ACTUAL
  // ─────────────────────────────────────────────

  Future<UserGame?> getUserGame(int igdbId) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    final response = await client
        .from('user_games')
        .select()
        .eq('user_id', user.id)
        .eq('igdb_id', igdbId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserGame.fromMap(response);
  }

  // ─────────────────────────────────────────────
  // BIBLIOTECA D'UN ALTRE USUARI
  // ─────────────────────────────────────────────

  Future<List<LibraryGame>> getUserLibrary(String userId) async {
    final response = await client
        .from('user_games')
        .select('''
          *,
          games(*)
          ''')
        .eq('user_id', userId);

    return response.map((row) {
      final game = Game.fromMap(row['games'] as Map<String, dynamic>);

      final userGame = UserGame.fromMap(row);

      return LibraryGame(game: game, userGame: userGame);
    }).toList();
  }
}
