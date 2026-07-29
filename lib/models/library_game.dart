import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/user_game.dart';

class LibraryGame {
  final Game game;
  final UserGame userGame;

  const LibraryGame({
    required this.game,
    required this.userGame,
  });
}