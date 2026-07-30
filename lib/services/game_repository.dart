import '../models/game.dart';

abstract class GameRepository {
  Future<Game?> getGameById(int igdbId);

  Future<List<Game>> searchGames(String query);
}