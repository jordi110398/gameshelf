import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/star_burst.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/features/social/social_game_detail_page.dart';
import 'game_overlay.dart';

class GameCard extends StatefulWidget {
  final LibraryGame libraryGame;
  final VoidCallback? onLibraryChanged;

  final bool isActive;
  final VoidCallback onActivate;
  final String? socialNickname;

  const GameCard({
    super.key,
    required this.libraryGame,
    this.onLibraryChanged,
    required this.isActive,
    required this.onActivate,
    this.socialNickname,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;

  final _starBurstKey = GlobalKey<StarBurstState>();

  Future<void> openGameDetail() async {
    if (widget.socialNickname != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SocialGameDetailPage(
            libraryGame: widget.libraryGame,
            nickname: widget.socialNickname!,
          ),
        ),
      );

      return;
    }

    final refresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GameDetailPage(game: widget.libraryGame.game),
      ),
    );

    if (refresh == true) {
      widget.onLibraryChanged?.call();
    }
  }

  void _maybeTriggerStarBurst(Offset localPosition) {
    final isFavorite = widget.libraryGame.userGame.favorite;
    if (!isFavorite) return;

    _starBurstKey.currentState?.burst(localPosition);
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.libraryGame.game;
    final status = widget.libraryGame.userGame.status;
    final statusColor = status.color;

    final isMobile = MediaQuery.of(context).size.width < 600;

    final isActive = isMobile ? widget.isActive : isHovered;

    return GestureDetector(
      onTapUp: (details) {
        _maybeTriggerStarBurst(details.localPosition);
      },
      onTap: () async {
        if (isMobile) {
          // Primer tap: activar aquesta card
          if (!widget.isActive) {
            widget.onActivate();
            return;
          }

          // Segon tap: obrir el detall
          await openGameDetail();
        } else {
          // Desktop: clic directe al detall
          await openGameDetail();
        }
      },

      child: MouseRegion(
        onEnter: (_) {
          if (!isMobile) {
            setState(() {
              isHovered = true;
            });
          }
        },

        onExit: (_) {
          if (!isMobile) {
            setState(() {
              isHovered = false;
            });
          }
        },

        child: AnimatedScale(
          scale: isActive ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 180),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.55),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),

              child: AspectRatio(
                aspectRatio: 2 / 3,

                child: StarBurst(
                  key: _starBurstKey,
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
                        visible: isActive,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
