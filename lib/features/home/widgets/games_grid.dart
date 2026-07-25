import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'game_card.dart';

class GameGrid extends StatelessWidget {
  final List<Game> games;

  const GameGrid({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth / 190).floor();

        if (columns < 2) columns = 2;

        return GridView.builder(
          padding: const EdgeInsets.all(24),

          itemCount: games.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 3,
          ),

          itemBuilder: (context, index) {
            return GameCard(
              game: games[index],
            );
          },
        );
      },
    );
  }
}