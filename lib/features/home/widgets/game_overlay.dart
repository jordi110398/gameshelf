import 'package:flutter/material.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';

class GameOverlay extends StatelessWidget {
  final LibraryGame libraryGame;
  final bool visible;

  const GameOverlay({
    super.key,
    required this.libraryGame,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final game = libraryGame.game;
    final userGame = libraryGame.userGame;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black54,
                Colors.black87,
              ],
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(game.title, maxLines: 2, overflow: TextOverflow.ellipsis),

              RatingStars(rating: userGame.rating ?? 0),

              Row(
                children: [
                  Icon(
                    userGame.status == GameStatus.completed
                        ? Icons.check_circle
                        : Icons.cancel,
                  ),

                  Text("${userGame.hoursPlayed}h"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
