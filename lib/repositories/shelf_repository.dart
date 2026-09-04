import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/models/shelf.dart';

typedef ShelfFeedItem = ({Shelf shelf, Profile profile, List<Game> games});

const _shelfSelect = '*, shelf_games(igdb_id, position)';

class ShelfRepository {
  final SupabaseClient client;

  const ShelfRepository(this.client);

  String get _userId {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    return user.id;
  }

  // ─────────────────────────────────────────────
  // LES MEVES ESTANTERIES
  // ─────────────────────────────────────────────

  Future<List<Shelf>> getMyShelves() async {
    final response = await client
        .from('shelves')
        .select(_shelfSelect)
        .eq('user_id', _userId)
        .order('updated_at', ascending: false);

    return (response as List)
        .map((row) => Shelf.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  // ─────────────────────────────────────────────
  // ESTANTERIA FIXADA D'UN USUARI (propi o d'un altre)
  // ─────────────────────────────────────────────

  Future<Shelf?> getPinnedShelf(String userId) async {
    final response = await client
        .from('shelves')
        .select(_shelfSelect)
        .eq('user_id', userId)
        .eq('is_pinned', true)
        .maybeSingle();

    if (response == null) return null;

    return Shelf.fromMap(response);
  }

  // ─────────────────────────────────────────────
  // CRUD D'ESTANTERIES
  // ─────────────────────────────────────────────

  Future<Shelf> createShelf(String title) async {
    final response = await client
        .from('shelves')
        .insert({'user_id': _userId, 'title': title})
        .select(_shelfSelect)
        .single();

    return Shelf.fromMap(response);
  }

  Future<void> renameShelf(String shelfId, String title) async {
    await client
        .from('shelves')
        .update({'title': title})
        .eq('id', shelfId)
        .eq('user_id', _userId);
  }

  Future<void> deleteShelf(String shelfId) async {
    await client
        .from('shelves')
        .delete()
        .eq('id', shelfId)
        .eq('user_id', _userId);
  }

  // ─────────────────────────────────────────────
  // FIXAR / PUBLICAR
  // ─────────────────────────────────────────────

  /// Com que només pot haver-hi una estanteria fixada per usuari (garantit
  /// a la BD amb un índex únic parcial), primer es desfixa la que hi
  /// hagués i després es fixa la sol·licitada.
  Future<void> setPinned(String shelfId) async {
    await client
        .from('shelves')
        .update({'is_pinned': false})
        .eq('user_id', _userId)
        .eq('is_pinned', true);

    await client
        .from('shelves')
        .update({'is_pinned': true})
        .eq('id', shelfId)
        .eq('user_id', _userId);
  }

  Future<void> unpin(String shelfId) async {
    await client
        .from('shelves')
        .update({'is_pinned': false})
        .eq('id', shelfId)
        .eq('user_id', _userId);
  }

  Future<void> setPublished(String shelfId, bool published) async {
    await client
        .from('shelves')
        .update({'is_published': published})
        .eq('id', shelfId)
        .eq('user_id', _userId);
  }

  // ─────────────────────────────────────────────
  // JOCS D'UNA ESTANTERIA
  // ─────────────────────────────────────────────

  Future<void> addGame(String shelfId, int igdbId, int position) async {
    await client.from('shelf_games').insert({
      'shelf_id': shelfId,
      'igdb_id': igdbId,
      'position': position,
    });
  }

  Future<void> removeGame(String shelfId, int igdbId) async {
    await client
        .from('shelf_games')
        .delete()
        .eq('shelf_id', shelfId)
        .eq('igdb_id', igdbId);
  }

  // ─────────────────────────────────────────────
  // JOCS PER IGDB_ID (helper compartit)
  // ─────────────────────────────────────────────

  Future<List<Game>> getGamesByIds(List<int> igdbIds) async {
    if (igdbIds.isEmpty) return [];

    final response = await client
        .from('games')
        .select()
        .inFilter('igdb_id', igdbIds);

    return (response as List)
        .map((row) => Game.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  // ─────────────────────────────────────────────
  // FEED DEL LLAMP: ESTANTERIES PUBLICADES PELS AMICS
  // ─────────────────────────────────────────────

  Future<List<ShelfFeedItem>> getLlampFeed({int limit = 20}) async {
    final rows = await client.rpc(
      'get_llamp_feed',
      params: {'viewer_id': _userId, 'feed_limit': limit},
    );

    final feedRows = rows as List;
    if (feedRows.isEmpty) return [];

    final userIds = feedRows.map((r) => r['user_id'] as String).toSet();

    final allGameIds = feedRows
        .expand((r) => (r['game_ids'] as List).cast<int>())
        .toSet()
        .toList();

    final profilesResponse = await client
        .from('profiles_public')
        .select('id, nickname, avatar_url')
        .inFilter('id', userIds.toList());

    final profileById = {
      for (final p in profilesResponse as List)
        p['id'] as String: Profile.fromMap(p as Map<String, dynamic>),
    };

    final games = await getGamesByIds(allGameIds);
    final gameById = {for (final g in games) g.igdbId: g};

    return feedRows.map((row) {
      final gameIds = (row['game_ids'] as List).cast<int>();

      final shelf = Shelf(
        id: row['shelf_id'] as String,
        userId: row['user_id'] as String,
        title: row['title'] as String,
        isPinned: false,
        isPublished: true,
        updatedAt: DateTime.parse(row['updated_at'] as String),
        gameIds: gameIds,
      );

      return (
        shelf: shelf,
        profile: profileById[shelf.userId]!,
        games: gameIds
            .map((id) => gameById[id])
            .whereType<Game>()
            .toList(),
      );
    }).toList();
  }

  // ─────────────────────────────────────────────
  // RECOMANACIONS PERSONALITZADES
  // ─────────────────────────────────────────────

  Future<List<Game>> getRecommendations({int limit = 12}) async {
    final rows = await client.rpc(
      'get_recommendations',
      params: {'viewer_id': _userId, 'rec_limit': limit},
    );

    final recRows = rows as List;
    if (recRows.isEmpty) return [];

    final igdbIds = recRows.map((r) => r['igdb_id'] as int).toList();
    final games = await getGamesByIds(igdbIds);
    final gameById = {for (final g in games) g.igdbId: g};

    return igdbIds.map((id) => gameById[id]).whereType<Game>().toList();
  }
}
