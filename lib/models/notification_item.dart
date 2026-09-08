enum NotificationType { friendRequest, friendAccepted, activityLike, unknown }

extension NotificationTypeX on NotificationType {
  /// Un tipus no reconegut (p. ex. afegit per una versió més nova de l'app
  /// que encara no s'ha desplegat) es tradueix a [NotificationType.unknown]
  /// en lloc de llançar -- `NotificationRepository` el descarta abans de
  /// mostrar-lo, així que una versió antiga en producció simplement
  /// l'ignora en lloc de petar tota la llista de notificacions.
  static NotificationType fromDb(String value) {
    switch (value) {
      case 'friend_request':
        return NotificationType.friendRequest;
      case 'friend_accepted':
        return NotificationType.friendAccepted;
      case 'activity_like':
        return NotificationType.activityLike;
      default:
        return NotificationType.unknown;
    }
  }
}

class NotificationItem {
  final String id;
  final String actorId;
  final String actorNickname;
  final String? actorAvatarUrl;
  final NotificationType type;
  final String? friendshipId;
  final String? activityId;
  final String? gameTitle;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.actorId,
    required this.actorNickname,
    this.actorAvatarUrl,
    required this.type,
    this.friendshipId,
    this.activityId,
    this.gameTitle,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;

    return NotificationItem(
      id: map['id'] as String,
      actorId: map['actor_id'] as String,
      actorNickname: profile?['nickname'] as String? ?? 'unknown',
      actorAvatarUrl: profile?['avatar_url'] as String?,
      type: NotificationTypeX.fromDb(map['type'] as String),
      friendshipId: map['friendship_id'] as String?,
      activityId: map['activity_id'] as String?,
      gameTitle: map['game_title'] as String?,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
