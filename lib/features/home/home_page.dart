import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/games_grid.dart';
import 'package:gameshelf/data/mock_games.dart';
import 'package:gameshelf/services/game_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = GameRepository();
    final games = repository.getGames();

    return Scaffold(
      body: Column(
        children: [
          const Header(),

          Expanded(child: GameGrid(
            games: games)),
        ],
      ),
    );
  }
}
