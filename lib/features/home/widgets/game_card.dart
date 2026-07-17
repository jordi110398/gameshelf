import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'game_overlay.dart';

class GameCard extends StatefulWidget {
  final Game game;

  const GameCard({
    super.key,
    required this.game,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              children: [

                // PORTADA
                Image.asset(
                  widget.game.cover,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

                // OVERLAY
                GameOverlay(
                  game: widget.game,
                  visible: isHovered,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}