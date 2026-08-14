import 'package:supabase_flutter/supabase_flutter.dart';

class FriendshipRepository {
  final SupabaseClient client;

  FriendshipRepository(this.client);

  // ─────────────────────────────────────────────
  // USUARI ACTUAL
  // ─────────────────────────────────────────────

  String get currentUserId {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    return user.id;
  }

  // ─────────────────────────────────────────────
  // ENVIAR SOL·LICITUD
  // ─────────────────────────────────────────────

  Future<void> sendFriendRequest(String receiverId) async {
    final userId = currentUserId;

    if (userId == receiverId) {
      throw Exception('No et pots enviar una sol·licitud a tu mateix');
    }

    // Comprovem si ja existeix una relació
    final existing = await _getFriendship(
      userId,
      receiverId,
    );

    if (existing != null) {
      throw Exception('Ja existeix una relació amb aquest usuari');
    }

    await client.from('friendships').insert({
      'requester_id': userId,
      'receiver_id': receiverId,
      'status': 'pending',
    });
  }

  // ─────────────────────────────────────────────
  // ACCEPTAR SOL·LICITUD
  // ─────────────────────────────────────────────

  Future<void> acceptFriendRequest(String friendshipId) async {
    await client
        .from('friendships')
        .update({
          'status': 'accepted',
        })
        .eq('id', friendshipId)
        .eq('receiver_id', currentUserId);
  }

  // ─────────────────────────────────────────────
  // REBUTJAR SOL·LICITUD
  // ─────────────────────────────────────────────

  Future<void> rejectFriendRequest(String friendshipId) async {
    await client
        .from('friendships')
        .delete()
        .eq('id', friendshipId)
        .eq('receiver_id', currentUserId);
  }

  // ─────────────────────────────────────────────
  // ELIMINAR AMISTAT
  // ─────────────────────────────────────────────

  Future<void> removeFriend(String friendshipId) async {
    await client
        .from('friendships')
        .delete()
        .eq('id', friendshipId)
        .or(
          'requester_id.eq.$currentUserId,receiver_id.eq.$currentUserId',
        );
  }

  // ─────────────────────────────────────────────
  // OBTENIR RELACIÓ ENTRE DOS USUARIS
  // ─────────────────────────────────────────────

  Future<Map<String, dynamic>?> _getFriendship(
    String userA,
    String userB,
  ) async {
    final response = await client
        .from('friendships')
        .select()
        .or(
          'and(requester_id.eq.$userA,receiver_id.eq.$userB),'
          'and(requester_id.eq.$userB,receiver_id.eq.$userA)',
        )
        .maybeSingle();

    return response;
  }

  // ─────────────────────────────────────────────
  // ESTAT DE L'AMISTAT
  // ─────────────────────────────────────────────

  Future<String?> getFriendshipStatus(String otherUserId) async {
    final friendship = await _getFriendship(
      currentUserId,
      otherUserId,
    );

    if (friendship == null) {
      return null;
    }

    return friendship['status'] as String?;
  }

  // ─────────────────────────────────────────────
  // OBTENIR LA RELACIÓ COMPLETA
  // ─────────────────────────────────────────────

  Future<Map<String, dynamic>?> getFriendship(
    String otherUserId,
  ) async {
    return _getFriendship(
      currentUserId,
      otherUserId,
    );
  }

  // ─────────────────────────────────────────────
  // OBTENIR AMICS
  // ─────────────────────────────────────────────

  Future<List<String>> getFriendIds() async {
    final userId = currentUserId;

    final response = await client
        .from('friendships')
        .select()
        .eq('status', 'accepted')
        .or(
          'requester_id.eq.$userId,receiver_id.eq.$userId',
        );

    final friendIds = <String>[];

    for (final friendship in response) {
      final requesterId = friendship['requester_id'] as String;
      final receiverId = friendship['receiver_id'] as String;

      if (requesterId == userId) {
        friendIds.add(receiverId);
      } else {
        friendIds.add(requesterId);
      }
    }

    return friendIds;
  }

  // ─────────────────────────────────────────────
  // SOL·LICITUDS REBUDES
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final response = await client
        .from('friendships')
        .select()
        .eq('receiver_id', currentUserId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // ─────────────────────────────────────────────
  // SOL·LICITUDS ENVIADES
  // ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getSentRequests() async {
    final response = await client
        .from('friendships')
        .select()
        .eq('requester_id', currentUserId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}