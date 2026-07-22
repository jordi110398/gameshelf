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
    return GridView.builder(
      itemCount: games.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
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
  }
}