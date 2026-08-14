import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/activity_item.dart';

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
    debugPrint('🔍 rpc response: $response');  // <-- afegit

    final rows = response as List;
    debugPrint('🔍 rows.length: ${rows.length}');  // <-- afegit

    // Cal el nickname/avatar de cada actor; el fem en una segona consulta
    // per evitar dependre de com la RPC retorna joins.
    final userIds = rows.map((r) => r['user_id'] as String).toSet().toList();

    final profiles = await client
        .from('profiles')
        .select('id, nickname, avatar_url')
        .inFilter('id', userIds);

    final profileById = {
      for (final p in profiles as List) p['id'] as String: p,
    };

    return rows.map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      map['profiles'] = profileById[map['user_id']];
      return ActivityItem.fromMap(map);
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
}