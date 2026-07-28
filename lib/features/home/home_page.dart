import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/features/home/widgets/header.dart';
import 'package:gameshelf/services/game_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = GameRepository();
    final games = repository.getGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GameShelf"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Tancar sessió",
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: GameGrid(
              games: games,
            ),
          ),
        ],
      ),
    );
  }
}