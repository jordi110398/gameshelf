import 'package:flutter/material.dart';

/// Fil de llumets decoratiu penjat sobre cada prestatge, alternativa a
/// [ShelfLedStrip]. Actualment no s'usa (es fa servir la tira LED), es manté
/// per a quan l'estanteria sigui personalitzable.
class ShelfLights extends StatelessWidget {
  final double width;

  const ShelfLights({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 16,
      child: CustomPaint(painter: _LightsPainter()),
    );
  }
}

class _LightsPainter extends CustomPainter {
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

      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = const Color(0xFFFFD873).withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      canvas.drawCircle(
        Offset(x, y),
        2.4,
        Paint()..color = const Color(0xFFFFE08A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LightsPainter oldDelegate) => false;
}
