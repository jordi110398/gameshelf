enum ActivityType { startedPlaying, completed, dropped, review, addedToLibrary }

extension ActivityTypeX on ActivityType {
  static ActivityType fromDb(String value) {
    switch (value) {
      case 'started_playing':
        return ActivityType.startedPlaying;
      case 'completed':
        return ActivityType.completed;
      case 'dropped':
        return ActivityType.dropped;
      case 'review':
        return ActivityType.review;
      case 'added_to_library':
        return ActivityType.addedToLibrary;
      default:
        throw ArgumentError('Tipus d\'activitat desconegut: $value');
    }
  }
}

class ActivityItem {
  final String id;
  final String userId;
  final String userNickname;
  final String? userAvatarUrl;
  final ActivityType type;
  final int gameId;
  final String gameTitle;
  final String? gameCoverUrl;
  final double? rating;
  final String? reviewSnippet;
  final DateTime createdAt;
  final int likeCount;
  final bool likedByMe;

  const ActivityItem({
    required this.id,
    required this.userId,
    required this.userNickname,
    this.userAvatarUrl,
    required this.type,
    required this.gameId,
    required this.gameTitle,
    this.gameCoverUrl,
    this.rating,
    this.reviewSnippet,
    required this.createdAt,
    this.likeCount = 0,
    this.likedByMe = false,
  });

  factory ActivityItem.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;

    return ActivityItem(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      userNickname: profile?['nickname'] as String? ?? 'unknown',
      userAvatarUrl: profile?['avatar_url'] as String?,
      type: ActivityTypeX.fromDb(map['type'] as String),
      gameId: map['game_id'] as int,
      gameTitle: map['game_title'] as String,
      gameCoverUrl: map['game_cover_url'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
      reviewSnippet: map['review_snippet'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      likeCount: (map['like_count'] as num?)?.toInt() ?? 0,
      likedByMe: map['liked_by_me'] as bool? ?? false,
    );
  }
}
