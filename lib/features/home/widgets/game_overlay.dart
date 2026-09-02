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
    final game = libraryGame.game;
    final status = userGame.status;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 150,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            8,
            12,
            8,
            10,
          ),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 130;

              final iconSize = isSmall ? 17.0 : 22.0;
              final spacing = isSmall ? 4.0 : 8.0;

              return status == GameStatus.wantToPlay
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ─────────────────────
                        // ESTAT + IGDB
                        // ─────────────────────

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status.icon,
                              color: status.color,
                              size: iconSize,
                            ),

                            SizedBox(width: spacing),

                            if (game.rating != null) ...[
                              Text(
                                "IGDB",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmall ? 9 : 12,
                                  fontWeight: FontWeight.w600,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: isSmall ? 2 : 4),

                              Text(
                                game.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmall ? 10 : 13,
                                  fontWeight: FontWeight.w600,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),

                        if (game.genres.isNotEmpty) ...[
                          const SizedBox(height: 6),

                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: game.genres.map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(
                                    alpha: 0.55,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmall ? 7 : 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ─────────────────────
                        // REVIEW
                        // ─────────────────────

                        if (userGame.review != null &&
                            userGame.review!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            child: Text(
                              '"${userGame.review!}"',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 9 : 13,
                                fontStyle: FontStyle.italic,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // ─────────────────────
                        // ESTAT + VALORACIÓ
                        // ─────────────────────

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status.icon,
                              color: status.color,
                              size: iconSize,
                            ),

                            SizedBox(width: spacing),

                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: RatingStars(
                                  rating: userGame.rating ?? 0,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // ─────────────────────
                        // HORES
                        // ─────────────────────

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: isSmall ? 13 : 17,
                              color: Colors.white70,
                            ),

                            const SizedBox(width: 3),

                            Text(
                              "${userGame.hoursPlayed}h",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 10 : 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}