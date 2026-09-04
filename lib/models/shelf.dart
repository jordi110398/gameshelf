class Shelf {
  final String id;
  final String userId;
  final String title;
  final bool isPinned;
  final bool isPublished;
  final DateTime updatedAt;
  final List<int> gameIds;

  const Shelf({
    required this.id,
    required this.userId,
    required this.title,
    required this.isPinned,
    required this.isPublished,
    required this.updatedAt,
    this.gameIds = const [],
  });

  factory Shelf.fromMap(Map<String, dynamic> map) {
    final rawGames = map['shelf_games'] as List?;

    final gameIds = rawGames != null
        ? (rawGames.toList()
                ..sort(
                  (a, b) => (a['position'] as int).compareTo(
                    b['position'] as int,
                  ),
                ))
              .map((row) => row['igdb_id'] as int)
              .toList()
        : const <int>[];

    return Shelf(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      isPinned: map['is_pinned'] as bool? ?? false,
      isPublished: map['is_published'] as bool? ?? false,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      gameIds: gameIds,
    );
  }
}
