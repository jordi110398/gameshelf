import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/notification_item.dart';

class NotificationRepository {
  final SupabaseClient client;

  const NotificationRepository(this.client);

  String? get _userId => client.auth.currentUser?.id;

  /// Carrega les notificacions (paginat cap enrere amb [before]).
  Future<List<NotificationItem>> getNotifications({
    DateTime? before,
    int limit = 30,
  }) async {
    final userId = _userId;
    if (userId == null) return [];

    var query = client.from('notifications').select().eq('user_id', userId);

    if (before != null) {
      query = query.lt('created_at', before.toIso8601String());
    }

    final rows = await query.order('created_at', ascending: false).limit(limit);

    // notifications no té cap FK cap a profiles_public, així que Postgrest
    // no pot fer l'embed automàtic -- mateix patró que
    // ActivityRepository.getFeed().
    final actorIds = (rows as List)
        .map((r) => r['actor_id'] as String)
        .toSet()
        .toList();

    final profiles = actorIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await client
              .from('profiles_public')
              .select('id, nickname, avatar_url')
              .inFilter('id', actorIds);

    final profileById = {for (final p in profiles) p['id'] as String: p};

    return rows.map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      map['profiles'] = profileById[map['actor_id']];
      return NotificationItem.fromMap(map);
    }).toList();
  }

  Future<int> getUnreadCount() async {
    final userId = _userId;
    if (userId == null) return 0;

    final rows = await client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .filter('read_at', 'is', null);

    return (rows as List).length;
  }

  Future<void> markAsRead(String id) async {
    final userId = _userId;
    if (userId == null) return;

    await client
        .from('notifications')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', userId);
  }

  Future<void> markAllAsRead() async {
    final userId = _userId;
    if (userId == null) return;

    await client
        .from('notifications')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId)
        .filter('read_at', 'is', null);
  }
}
