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
    final userGame = libraryGame.userGame;
    final status = userGame.status;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 110,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                status.color.withValues(alpha: 0.10),
                status.color.withValues(alpha: 0.20),
              ],
            ),
          ),
          child: status == GameStatus.wantToPlay
              ? Center(child: Icon(status.icon, color: status.color, size: 26))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userGame.review != null &&
                        userGame.review!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Text(
                          userGame.review!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Estat + valoració
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(status.icon, color: status.color, size: 22),

                        const SizedBox(width: 8),

                        RatingStars(rating: userGame.rating ?? 0),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Hores
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 17,
                          color: Colors.white70,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          "${userGame.hoursPlayed}h",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
