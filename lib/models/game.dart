import 'package:gameshelf/models/game_status.dart';
class Game {
  final int id;

  // IGDB
  final String title;
  final String cover;
  final String platform;

  // Usuari
  final int rating;          // 0-5
  final int hoursPlayed;
  final String review;

  final GameStatus status;

  final bool favorite;

  const Game({
    required this.id,
    required this.title,
    required this.cover,
    required this.platform,
    required this.rating,
    required this.hoursPlayed,
    required this.review,
    required this.status,
    required this.favorite,
  });
}