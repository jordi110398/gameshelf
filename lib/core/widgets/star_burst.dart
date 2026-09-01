import 'dart:math';

import 'package:flutter/material.dart';

/// Embolcalla un widget i permet disparar una explosió de partícules
/// d'estrelles daurades sobre seu (via [StarBurstState.burst]). Extret de
/// `game_card.dart` perquè el mateix efecte es fes servir també a
/// `activity_card.dart`.
class StarBurst extends StatefulWidget {
  final Widget child;

  const StarBurst({super.key, required this.child});

  @override
  State<StarBurst> createState() => StarBurstState();
}

class StarBurstState extends State<StarBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<_StarParticle> _particles = [];
  Offset _origin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void burst(Offset localPosition) {
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
      _origin = localPosition;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_controller.isDismissed) {
                return const SizedBox.shrink();
              }

              return CustomPaint(
                painter: _GoldenStarsPainter(
                  progress: _controller.value,
                  origin: _origin,
                  particles: _particles,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ],
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
      final localProgress = ((progress - particle.delay) / (1 - particle.delay))
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

      _drawStar(canvas, Offset(dx, dy), particle.size * scale, paint);
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
