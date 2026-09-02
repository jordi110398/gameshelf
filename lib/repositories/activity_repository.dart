import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:flutter/foundation.dart';

typedef ReviewLikes = ({int likeCount, bool likedByMe});

class ActivityRepository {
  final SupabaseClient client;

  const ActivityRepository(this.client);

  /// Carrega el feed (paginat cap enrere amb [before]).
  Future<List<ActivityItem>> getFeed({DateTime? before, int limit = 30}) async {
    final viewerId = client.auth.currentUser?.id;
    debugPrint('🔍 viewerId: $viewerId');
    if (viewerId == null) return [];

    final response = await client.rpc(
      'get_activity_feed',
      params: {
        'viewer_id': viewerId,
        'feed_limit': limit,
        'feed_before': (before ?? DateTime.now()).toIso8601String(),
      },
    );
    debugPrint('🔍 rpc response: $response'); // <-- afegit

    final rows = response as List;
    debugPrint('🔍 rows.length: ${rows.length}'); // <-- afegit

    // Cal el nickname/avatar de cada actor (i de l'amic, per a
    // 'friendship_formed'); ho fem en una segona consulta per evitar
    // dependre de com la RPC retorna joins.
    final actorIds = rows.map((r) => r['user_id'] as String).toSet();
    final friendIds = rows
        .map((r) => r['friend_id'] as String?)
        .whereType<String>()
        .toSet();

    final allIds = {...actorIds, ...friendIds}.toList();

    final profiles = await client
        .from('profiles_public')
        .select('id, nickname, avatar_url')
        .inFilter('id', allIds);

    final profileById = {
      for (final p in profiles as List) p['id'] as String: p,
    };

    final items = rows.map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      map['profiles'] = profileById[map['user_id']];

      final friendId = map['friend_id'] as String?;
      if (friendId != null) {
        map['friend_profile'] = profileById[friendId];
      }

      return ActivityItem.fromMap(map);
    }).toList();

    // Cada amistat genera una activitat per a cada banda, així que si el
    // viewer és amic mutu de tots dos, li poden sortir dues files idèntiques
    // ("A i B ara són amics!" dues vegades). Les deduplica dins d'aquesta
    // pàgina (l'ordre ja ve per rellevància/data des de la RPC).
    final seenFriendshipPairs = <String>{};

    return items.where((item) {
      if (item.type != ActivityType.friendshipFormed || item.friendId == null) {
        return true;
      }

      final pairKey = ([item.userId, item.friendId!]..sort()).join('-');
      return seenFriendshipPairs.add(pairKey);
    }).toList();
  }

  /// Comprova si hi ha activitat més nova que [since], sense carregar-la.
  Future<bool> hasNewActivitySince(DateTime since) async {
    final viewerId = client.auth.currentUser?.id;
    if (viewerId == null) return false;

    final response = await client.rpc(
      'get_activity_feed',
      params: {
        'viewer_id': viewerId,
        'feed_limit': 1,
        'feed_before': DateTime.now().toIso8601String(),
      },
    );

    final rows = response as List;
    if (rows.isEmpty) return false;

    final latest = DateTime.parse(rows.first['created_at'] as String);
    return latest.isAfter(since);
  }

  /// Recuperar review
  Future<String?> getReview({
    required String userId,
    required int gameId,
  }) async {
    final response = await client
        .from('user_games')
        .select('review')
        .eq('user_id', userId)
        .eq('igdb_id', gameId)
        .maybeSingle();

    return response?['review'] as String?;
  }

  // ─────────────────────────────────────────────
  // LIKES
  // ─────────────────────────────────────────────

  /// No s'encadena `.select()`: `activity_likes` no té cap manera de
  /// tornar la fila igualment, i forçar-ho fa fallar la petició sencera.
  Future<void> likeActivity(String activityId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client.from('activity_likes').insert({
      'activity_id': activityId,
      'user_id': userId,
    });
  }

  Future<void> unlikeActivity(String activityId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client
        .from('activity_likes')
        .delete()
        .eq('activity_id', activityId)
        .eq('user_id', userId);
  }

  /// Likes de les MEVES pròpies reviews, indexats per `igdb_id`. Fa servir
  /// `get_my_review_likes` perquè `get_activity_feed()` exclou expressament
  /// les pròpies activitats (només ensenya les dels altres).
  Future<Map<int, ReviewLikes>> getMyReviewLikes(List<int> gameIds) async {
    if (gameIds.isEmpty) return {};

    final response = await client.rpc(
      'get_my_review_likes',
      params: {'game_ids': gameIds},
    );

    final rows = response as List;

    return {
      for (final row in rows)
        row['game_id'] as int: (
          likeCount: (row['like_count'] as num).toInt(),
          likedByMe: row['liked_by_me'] as bool,
        ),
    };
  }
}
