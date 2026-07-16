import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2 / 3, // proporció típica de portada
        child: Container(
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(
              Icons.videogame_asset,
              size: 64,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}