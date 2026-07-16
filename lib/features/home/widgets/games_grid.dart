import 'package:flutter/material.dart';
import 'package:gameshelf/data/mock_games.dart';
import 'game_card.dart';

class GamesGrid extends StatelessWidget {
  const GamesGrid({super.key});

  @override
  Widget build(BuildContext context) {

    return GridView.builder(

      itemCount: mockGames.length,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 3,

        crossAxisSpacing: 16,

        mainAxisSpacing: 16,

        childAspectRatio: 2 / 3,

      ),

      itemBuilder: (context, index) {

        return GameCard(
          game: mockGames[index],
        );

      },
    );
  }
}