import 'package:flutter/material.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/models/library_game.dart';

import 'game_overlay.dart';

class GameCard extends StatefulWidget {
  final LibraryGame libraryGame;

  const GameCard({super.key, required this.libraryGame});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final game = widget.libraryGame.game;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailPage(
              game: widget.libraryGame.game,
              userGame: widget.libraryGame.userGame,
            ),
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
                  Hero(
                    tag: game.igdbId,
                    child: game.coverUrl != null
                        ? Image.network(game.coverUrl!, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey.shade800,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                            ),
                          ),
                  ),

                  GameOverlay(
                    libraryGame: widget.libraryGame,
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
