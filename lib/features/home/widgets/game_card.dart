import 'dart:math';

import 'package:flutter/material.dart';
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

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;

  late final AnimationController _particleController;
  List<_StarParticle> _particles = [];
  Offset _particleOrigin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

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
      builder: (_) => GameDetailPage(
        game: widget.libraryGame.game,
      ),
    ),
  );

  if (refresh == true) {
    widget.onLibraryChanged?.call();
  }
}

  void _maybeTriggerStarBurst(Offset localPosition) {
    final isFavorite = widget.libraryGame.userGame.favorite;
    if (!isFavorite) return;

    final random = Random();
    _particles = List.generate(18, (index) {
      final angle = random.nextDouble() * 2 * pi;
      final distance = 80 + random.nextDouble() * 110;
      final size = 24 + random.nextDouble() * 24;
      final delay = random.nextDouble() * 0.2;
      return _StarParticle(
        angle: angle,
        distance: distance,
        size: size,
        delay: delay,
      );
    });

    setState(() {
      _particleOrigin = localPosition;
    });

    _particleController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.libraryGame.game;
    final status = widget.libraryGame.userGame.status;
    final statusColor = status.color;

    final isMobile = MediaQuery.of(context).size.width < 600;

    final isActive = isMobile
        ? widget.isActive
        : isHovered;

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

                child: Stack(
                  fit: StackFit.expand,

                  children: [
                    Hero(
                      tag: game.igdbId,

                      child: game.coverUrl != null
                          ? Image.network(
                              game.coverUrl!,
                              fit: BoxFit.cover,
                            )
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

                    // Overlay de partícules d'estreles daurades
                    IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _particleController,
                        builder: (context, child) {
                          if (_particleController.isDismissed) {
                            return const SizedBox.shrink();
                          }
                          return CustomPaint(
                            painter: _GoldenStarsPainter(
                              progress: _particleController.value,
                              origin: _particleOrigin,
                              particles: _particles,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarParticle {
  final double angle;
  final double distance;
  final double size;
  final double delay;

  _StarParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });
}

class _GoldenStarsPainter extends CustomPainter {
  final double progress;
  final Offset origin;
  final List<_StarParticle> particles;

  _GoldenStarsPainter({
    required this.progress,
    required this.origin,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final localProgress =
          ((progress - particle.delay) / (1 - particle.delay))
              .clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      final easedProgress = Curves.easeOut.transform(localProgress);
      final currentDistance = particle.distance * easedProgress;

      final dx = origin.dx + cos(particle.angle) * currentDistance;
      final dy = origin.dy + sin(particle.angle) * currentDistance;

      final opacity = (1 - easedProgress).clamp(0.0, 1.0);
      final scale = (1 - easedProgress * 0.4);

      final paint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      _drawStar(
        canvas,
        Offset(dx, dy),
        particle.size * scale,
        paint,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    const points = 5;
    final path = Path();
    final outerRadius = size;
    final innerRadius = size / 2.5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (pi / points) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Petit resplendor blanc
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: paint.color.a * 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _GoldenStarsPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.origin != origin;
  }
}