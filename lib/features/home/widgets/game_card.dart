import 'package:flutter/material.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailPage(game: widget.game),
          ),
        );
      },
      child: MouseRegion(
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
                fit: StackFit.expand,
                children: [

                  // PORTADA
                  Image.asset(
                    widget.game.cover,
                    fit: BoxFit.cover,
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
      ),
    );
  }
}