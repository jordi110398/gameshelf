import 'package:gameshelf/data/mock_games.dart';
import 'package:gameshelf/models/game.dart';

class GameRepository {
  List<Game> getGames() {
    return mockGames;
  }

  Game getGameById(int id) {
    return mockGames.firstWhere(
      (game) => game.id == id
    );
  }
}