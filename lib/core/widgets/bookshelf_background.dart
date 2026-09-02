import 'dart:math';
import 'package:flutter/material.dart';

/// Paret de fusta de la prestatgeria. És un backdrop fix (no fa scroll amb
/// la llista, es dibuixa un sol cop sobre tot l'espai visible): per això no
/// cal cap imatge "seamless" que s'hagi de repetir infinitament cap avall,
/// només queda estàtica darrere les fileres que sí que es desplacen.
class BookshelfBackground extends StatelessWidget {
  const BookshelfBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: RepaintBoundary(child: CustomPaint(painter: _WoodGrainPainter())),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  const _WoodGrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B1714), Color(0xFF0A0807)],
        ).createShader(rect),
    );

    // Vetes de fusta: línies horitzontals lleugerament ondulades. Llavor
    // fixa perquè el patró no "parpellegi" en cada repintat. Sobre un fons
    // gairebé negre, la veta es marca amb un lleuger reflex clar en lloc
    // d'ombra fosca (que no es veuria).
    final random = Random(7);
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double y = 10; y < size.height; y += 24) {
      final path = Path()..moveTo(0, y);

      for (double x = 0; x <= size.width; x += 44) {
        final wobble = random.nextDouble() * 8 - 4;
        path.lineTo(x, y + wobble);
      }

      grainPaint.color = Colors.white.withValues(
        alpha: 0.025 + random.nextDouble() * 0.035,
      );

      canvas.drawPath(path, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WoodGrainPainter oldDelegate) => false;
}
