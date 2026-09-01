import 'package:flutter/material.dart';

/// Tira LED RGB decorativa muntada sota cada prestatge, alternativa a
/// [ShelfLights]. Segueix la mateixa corba penjant que el fil de llumets
/// clàssic, però amb un degradat lila/rosa/blau (colors de l'app) i glow.
class ShelfLedStrip extends StatelessWidget {
  final double width;

  const ShelfLedStrip({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 16,
      child: CustomPaint(painter: _LedStripPainter()),
    );
  }
}

const _ledColors = [
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
  Color(0xFF3B82F6),
  Color(0xFF22D3EE),
];

class _LedStripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, 0);

    final rect = Offset.zero & size;

    // Glow: el mateix traçat, més ample i difuminat, a sota de la línia
    // nítida.
    final glowGradient = LinearGradient(
      colors: _ledColors.map((c) => c.withValues(alpha: 0.55)).toList(),
    ).createShader(rect);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 7
        ..shader = glowGradient
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Línia nítida a sobre.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..shader = const LinearGradient(colors: _ledColors).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _LedStripPainter oldDelegate) => false;
}
