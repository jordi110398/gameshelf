import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';

import 'game_card.dart';
import 'shelf.dart';

class ShelfRow extends StatelessWidget {
  final List<Game> games;

  const ShelfRow({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: games
              .map(
                (game) => SizedBox(
                  width: 170,
                  child: GameCard(game: game),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 6),

        const Shelf(),

        const SizedBox(height: 36),
      ],
    );
  }
}