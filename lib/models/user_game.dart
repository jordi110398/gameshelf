import 'package:gameshelf/models/game_status.dart';
class UserGame {
  final int igdbId;
  final GameStatus status;
  final int? rating;
  final int hoursPlayed;
  final bool favorite;
  final String? review;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const UserGame({
    required this.igdbId,
    required this.status,
    this.rating,
    required this.hoursPlayed,
    required this.favorite,
    this.review,
    this.startedAt,
    this.completedAt,
  });

  factory UserGame.fromMap(Map<String, dynamic> map) {
    return UserGame(
      igdbId: map["igdb_id"],
      status: GameStatus.values.byName(map["status"]),
      rating: map["rating"],
      hoursPlayed: map["hours_played"] ?? 0,
      favorite: map["favorite"] ?? false,
      review: map["review"],
      startedAt: map["started_at"] != null
          ? DateTime.parse(map["started_at"])
          : null,
      completedAt: map["completed_at"] != null
          ? DateTime.parse(map["completed_at"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "igdb_id": igdbId,
      "status": status.name,
      "rating": rating,
      "hours_played": hoursPlayed,
      "favorite": favorite,
      "review": review,
      "started_at": startedAt?.toIso8601String(),
      "completed_at": completedAt?.toIso8601String(),
    };
  }
}