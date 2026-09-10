import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/utils/platform_visuals.dart';
import 'package:gameshelf/core/widgets/cartridge_cover.dart';
import 'package:gameshelf/core/widgets/star_burst.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/shelf_style.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/features/social/social_game_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'game_overlay.dart';

class GameCard extends StatefulWidget {
  final LibraryGame libraryGame;
  final VoidCallback? onLibraryChanged;

  final bool isActive;
  final VoidCallback onActivate;
  final String? socialNickname;

  /// `null` -- segueix la preferència de l'usuari actual
  /// (`ShelfSkinService`); explícit quan la coberta pertany a
  /// l'estanteria/perfil d'una altra persona (mateix patró que
  /// `BookshelfBackground`).
  final ShelfCoverStyle? coverStyle;

  const GameCard({
    super.key,
    required this.libraryGame,
    this.onLibraryChanged,
    required this.isActive,
    required this.onActivate,
    this.socialNickname,
    this.coverStyle,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;
  late bool _favorite;

  final _starBurstKey = GlobalKey<StarBurstState>();
  final _repository = SupabaseLibraryRepository(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _favorite = widget.libraryGame.userGame.favorite;
  }

  @override
  void didUpdateWidget(covariant GameCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.libraryGame.userGame.favorite !=
        widget.libraryGame.userGame.favorite) {
      _favorite = widget.libraryGame.userGame.favorite;
    }
  }

  Future<void> openGameDetail() async {
    if (widget.socialNickname != null) {
      await pushFade(
        context,
        (_) => SocialGameDetailPage(
          libraryGame: widget.libraryGame,
          nickname: widget.socialNickname!,
        ),
      );

      return;
    }

    final refresh = await pushFade<bool>(
      context,
      (_) => GameDetailPage(game: widget.libraryGame.game),
    );

    if (refresh == true) {
      widget.onLibraryChanged?.call();
    }
  }

  void _maybeTriggerStarBurst(Offset localPosition) {
    if (!_favorite) return;

    _starBurstKey.currentState?.burst(localPosition);
  }

  // ─────────────────────────────────────────────
  // PREFERIT (MANTENIR PREMUT)
  // ─────────────────────────────────────────────

  Future<void> _handleLongPress(LongPressStartDetails details) async {
    // Només a la pròpia biblioteca (no al mirar el prestatge d'un altre
    // usuari), i només als jocs completats -- mateixa regla que ja
    // s'aplica a `edit_game_page.dart`.
    if (widget.socialNickname != null) return;

    final userGame = widget.libraryGame.userGame;

    if (userGame.status != GameStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.favoriteNotCompletedMessage)),
      );
      return;
    }

    final addingFavorite = !_favorite;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.libraryGame.game.title),
          content: Text(
            addingFavorite
                ? context.l10n.favoriteConfirmAddBody
                : context.l10n.favoriteConfirmRemoveBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                addingFavorite
                    ? context.l10n.favoriteConfirmAddAction
                    : context.l10n.favoriteConfirmRemoveAction,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _favorite = addingFavorite;
    });

    if (addingFavorite) {
      _starBurstKey.currentState?.burst(details.localPosition);
    }

    try {
      await _repository.updateUserGame(
        UserGame(
          igdbId: userGame.igdbId,
          status: userGame.status,
          rating: userGame.rating,
          hoursPlayed: userGame.hoursPlayed,
          favorite: addingFavorite,
          review: userGame.review,
          platform: userGame.platform,
          startedAt: userGame.startedAt,
          completedAt: userGame.completedAt,
          droppedAt: userGame.droppedAt,
          pausedAt: userGame.pausedAt,
          resumedAt: userGame.resumedAt,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            addingFavorite
                ? context.l10n.favoriteAddedMessage
                : context.l10n.favoriteRemovedMessage,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _favorite = !addingFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.favoriteUpdateFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coverStyle != null) {
      return _build(context, widget.coverStyle!);
    }

    return ValueListenableBuilder<ShelfCoverStyle>(
      valueListenable: ShelfSkinService.instance.coverStyle,
      builder: (context, ambientStyle, _) => _build(context, ambientStyle),
    );
  }

  Widget _build(BuildContext context, ShelfCoverStyle coverStyle) {
    final game = widget.libraryGame.game;
    final status = widget.libraryGame.userGame.status;
    final statusColor = status.color;
    final platformVisual = platformVisualFor(
      widget.libraryGame.userGame.platform,
    );

    final isMobile = MediaQuery.of(context).size.width < 600;

    final isActive = isMobile ? widget.isActive : isHovered;

    return GestureDetector(
      onTapUp: (details) {
        _maybeTriggerStarBurst(details.localPosition);
      },
      onLongPressStart: _handleLongPress,
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
                      Builder(
                        builder: (context) {
                          final hero = Hero(
                            tag: game.igdbId,

                            child: game.coverUrl != null
                                ? Image.network(
                                    game.coverUrl!,
                                    fit: BoxFit.cover,
                                    cacheWidth: 300,
                                  )
                                : Container(
                                    color: Colors.grey.shade800,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                    ),
                                  ),
                          );

                          if (coverStyle == ShelfCoverStyle.plain) {
                            return hero;
                          }

                          return CartridgeCover(
                            cover: hero,
                            shellColor: cartridgeShellColorFor(
                              platform: widget.libraryGame.userGame.platform,
                              favorite: _favorite,
                            ),
                            platformLabel: platformAbbreviation(
                              widget.libraryGame.userGame.platform,
                            ),
                          );
                        },
                      ),

                      GameOverlay(
                        libraryGame: widget.libraryGame,
                        visible: isActive,
                      ),

                      // Insígnia d'estat sempre visible, sense necessitat de
                      // tap/hover, per identificar-lo d'una ullada. Es
                      // desactiva quan la card és activa, ja que llavors
                      // l'estat ja es mostra dins de l'overlay.
                      Positioned(
                        top: 8,
                        left: 8,
                        child: AnimatedOpacity(
                          opacity: isActive ? 0 : 1,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              status.icon,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),

                      // Insígnia de plataforma, mateix tractament que la
                      // d'estat però a l'altra cantonada.
                      if (platformVisual != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedOpacity(
                            opacity: isActive ? 0 : 1,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: platformVisual.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                platformVisual.icon,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
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
