import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Paret de fusta de la prestatgeria. És un backdrop fix (no fa scroll amb
/// la llista, es dibuixa un sol cop sobre tot l'espai visible): per això no
/// cal cap imatge "seamless" que s'hagi de repetir infinitament cap avall,
/// només queda estàtica darrere les fileres que sí que es desplacen.
///
/// El color és una preferència pública del perfil a qui pertany
/// l'estanteria mostrada (com el banner generat pels tags): passa'l
/// explícitament quan es mostra la col·lecció d'un usuari concret (el seu
/// perfil, una targeta del llamp). Si es deixa `null` (decoració genèrica:
/// Inici, Social, el propi perfil), es fa servir en temps real la
/// preferència de l'usuari actual (`ShelfSkinService`).
class BookshelfBackground extends StatelessWidget {
  final ShelfWoodColor? color;

  const BookshelfBackground({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return _paint(color!);
    }

    return ValueListenableBuilder<ShelfWoodColor>(
      valueListenable: ShelfSkinService.instance.woodColor,
      builder: (context, ambientColor, _) => _paint(ambientColor),
    );
  }

  Widget _paint(ShelfWoodColor resolvedColor) {
    return SizedBox.expand(
      child: RepaintBoundary(
        child: CustomPaint(painter: _WoodGrainPainter(resolvedColor)),
      ),
    );
  }
}

// Tons clarament diferenciables entre ells (no tots quasi negres com
// abans), perquè el canvi es noti d'una ullada; l'ombreig cap avall del
// painter ja fosqueja la part de sota igualment.
const _woodGradients = {
  ShelfWoodColor.walnut: [Color(0xFF4A3320), Color(0xFF1A1109)],
  ShelfWoodColor.oak: [Color(0xFF6B4A26), Color(0xFF2A1B0C)],
  ShelfWoodColor.ebony: [Color(0xFF2B2B2E), Color(0xFF0B0B0C)],
  ShelfWoodColor.cherry: [Color(0xFF6B2E24), Color(0xFF260F0B)],
  ShelfWoodColor.birch: [Color(0xFFC7AD7C), Color(0xFF6E5B3B)],
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
    // fixa perquè el patró no "parpellegi" en cada repintat.
    final random = Random(7);
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Sobre fusta clara (birch) la veta es marca amb una ombra fosca; sobre
    // la resta (fosques), amb un lleuger reflex clar.
    final isLight = color == ShelfWoodColor.birch;

    for (double y = 10; y < size.height; y += 24) {
      final path = Path()..moveTo(0, y);

      for (double x = 0; x <= size.width; x += 44) {
        final wobble = random.nextDouble() * 8 - 4;
        path.lineTo(x, y + wobble);
      }

      grainPaint.color = isLight
          ? Colors.black.withValues(alpha: 0.05 + random.nextDouble() * 0.05)
          : Colors.white.withValues(alpha: 0.025 + random.nextDouble() * 0.035);

      canvas.drawPath(path, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WoodGrainPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
