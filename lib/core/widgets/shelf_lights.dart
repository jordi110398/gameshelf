import 'dart:math';
import 'package:flutter/material.dart';

/// Forma de cada llumet del fil -- vegeu [ShelfLights].
enum BulbShape { round, star, heart }

const _warmBulbColors = [Color(0xFFFFE08A)];
const _christmasBulbColors = [
  Color(0xFF34C759),
  Color(0xFFFF3B30),
  Color(0xFFF5F5F0),
];
const _heartBulbColors = [Color(0xFFFF5C93)];

/// Fil de llumets decoratiu penjat sobre cada prestatge, alternativa a
/// [ShelfLedStrip]. Els llumets poden ser rodons o en forma d'estrella
/// ([shape]), i seguir una paleta de colors ([colors]) que es reparteix
/// ciclant entre ells -- per defecte, groc càlid; nadalenca amb
/// [ShelfLights.christmas].
class ShelfLights extends StatelessWidget {
  final double width;
  final BulbShape shape;
  final List<Color> colors;

  const ShelfLights({
    super.key,
    required this.width,
    this.shape = BulbShape.round,
    this.colors = _warmBulbColors,
  });

  const ShelfLights.christmas({super.key, required this.width})
    : shape = BulbShape.round,
      colors = _christmasBulbColors;

  const ShelfLights.hearts({super.key, required this.width})
    : shape = BulbShape.heart,
      colors = _heartBulbColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 16,
      child: CustomPaint(painter: _LightsPainter(shape: shape, colors: colors)),
    );
  }
}

class _LightsPainter extends CustomPainter {
  final BulbShape shape;
  final List<Color> colors;

  _LightsPainter({required this.shape, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final stringPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    canvas.drawPath(path, stringPaint);

    const bulbCount = 9;

    for (var i = 0; i <= bulbCount; i++) {
      final t = i / bulbCount;
      final x = size.width * t;
      final y = 4 * size.height * t * (1 - t);
      final color = colors[i % colors.length];

      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      switch (shape) {
        case BulbShape.star:
          _drawStar(canvas, Offset(x, y), 4.2, Paint()..color = color);
        case BulbShape.heart:
          _drawHeart(canvas, Offset(x, y), 4.4, Paint()..color = color);
        case BulbShape.round:
          canvas.drawCircle(Offset(x, y), 2.4, Paint()..color = color);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    const points = 5;
    final path = Path();
    final outerRadius = size;
    final innerRadius = size / 2.5;

    for (var i = 0; i < points * 2; i++) {
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
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final x = center.dx;
    final y = center.dy - size * 0.3;

    path.moveTo(x, y + size * 0.6);
    path.cubicTo(
      x - size * 1.4,
      y - size * 0.6,
      x - size * 0.5,
      y - size * 1.5,
      x,
      y - size * 0.4,
    );
    path.cubicTo(
      x + size * 0.5,
      y - size * 1.5,
      x + size * 1.4,
      y - size * 0.6,
      x,
      y + size * 0.6,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LightsPainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.colors != colors;
}
