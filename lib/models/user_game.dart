import 'package:gameshelf/models/game_status.dart';
class UserGame {
  // Usuari
  final int rating;          // 0-5
  final int hoursPlayed;
  final String review;

  final GameStatus status;

  final bool favorite;
}