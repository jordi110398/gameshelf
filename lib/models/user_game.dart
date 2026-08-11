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
    final statusString = map["status"] as String;

    final GameStatus status;

    switch (statusString) {
      case "backlog":
      case "wishlist":
      case "want_to_play":
        status = GameStatus.wantToPlay;
        break;

      case "playing":
        status = GameStatus.playing;
        break;

      case "completed":
        status = GameStatus.completed;
        break;

      case "dropped":
        status = GameStatus.dropped;
        break;

      case "paused":
        status = GameStatus.paused;
        break;

      default:
        status = GameStatus.wantToPlay;
    }

    return UserGame(
      igdbId: map["igdb_id"],
      status: status,
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
      "status": _statusToDatabaseValue(),
      "rating": rating,
      "hours_played": hoursPlayed,
      "favorite": favorite,
      "review": review,
      "started_at": startedAt?.toIso8601String(),
      "completed_at": completedAt?.toIso8601String(),
    };
  }

  String _statusToDatabaseValue() {
    switch (status) {
      case GameStatus.wantToPlay:
        return "want_to_play";

      case GameStatus.playing:
        return "playing";

      case GameStatus.completed:
        return "completed";

      case GameStatus.dropped:
        return "dropped";

      case GameStatus.paused:
        return "paused";
    }
  }
}
