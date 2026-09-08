import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Paret de fusta de la prestatgeria. És un backdrop fix (no fa scroll amb
/// la llista, es dibuixa un sol cop sobre tot l'espai visible): per això no
/// cal cap imatge "seamless" que s'hagi de repetir infinitament cap avall,
/// només queda estàtica darrere les fileres que sí que es desplacen.
///
/// El color és una preferència pública del perfil a qui pertany
/// l'estanteria mostrada (com el banner generat pels tags): passa'l quan
/// es mostra la col·lecció d'un usuari concret; deixa el valor per
/// defecte (walnut) per a decoració genèrica no lligada a ningú.
class BookshelfBackground extends StatelessWidget {
  final ShelfWoodColor color;

  const BookshelfBackground({super.key, this.color = ShelfWoodColor.walnut});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: RepaintBoundary(
        child: CustomPaint(painter: _WoodGrainPainter(color)),
      ),
    );
  }
}

const _woodGradients = {
  ShelfWoodColor.walnut: [Color(0xFF1B1714), Color(0xFF0A0807)],
  ShelfWoodColor.oak: [Color(0xFF2E2013), Color(0xFF150E08)],
  ShelfWoodColor.ebony: [Color(0xFF17181A), Color(0xFF030304)],
  ShelfWoodColor.cherry: [Color(0xFF2B1512), Color(0xFF120705)],
  ShelfWoodColor.birch: [Color(0xFF2A2620), Color(0xFF120F0C)],
};

class _WoodGrainPainter extends CustomPainter {
  final ShelfWoodColor color;

  const _WoodGrainPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _woodGradients[color]!,
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
  bool shouldRepaint(covariant _WoodGrainPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
