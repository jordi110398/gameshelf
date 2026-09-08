import 'package:flutter/material.dart';

/// Banner generatiu amb dithering estil GBA a partir d'una paleta de
/// colors, reutilitzat al perfil i a la targeta de perfil compartible
/// (mateixos colors -> mateix banner, ja que es deriven dels tags de
/// l'usuari).
class DitherBanner extends StatelessWidget {
  final List<Color> colors;

  const DitherBanner({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _DitherBannerPainter(colors),
    );
  }
}

/// Matriu Bayer 4x4 estàndard, per decidir píxel a píxel quin dels dos
/// colors "reals" toca dibuixar en una transició -- la tècnica autèntica
/// de dithering ordenat que feien servir les pantalles de GBA en lloc
/// d'un degradat suau (que necessitaria més colors dels que la pantalla
/// podia mostrar).
const _bayer4x4 = [
  [0, 8, 2, 10],
  [12, 4, 14, 6],
  [3, 11, 1, 9],
  [15, 7, 13, 5],
];

class _DitherBannerPainter extends CustomPainter {
  final List<Color> colors;

  static const double _pixelSize = 6;
  static const Color _shadowColor = Color(0xFF14101C);

  const _DitherBannerPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final palette = colors.isEmpty
        ? const [Color(0xFF8B5CF6), Color(0xFF6D28D9)]
        : colors;

    final cols = (size.width / _pixelSize).ceil();
    final rows = (size.height / _pixelSize).ceil();

    final paint = Paint()..style = PaintingStyle.fill;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final threshold = _bayer4x4[row % 4][col % 4] / 16.0;

        // Transició horitzontal entre els colors de la paleta.
        final hProgress = palette.length == 1
            ? 0.0
            : (col / cols) * (palette.length - 1);
        final colorA = palette[hProgress.floor().clamp(0, palette.length - 1)];
        final colorB =
            palette[(hProgress.floor() + 1).clamp(0, palette.length - 1)];
        final hLocal = hProgress - hProgress.floor();

        var pixelColor = hLocal > threshold ? colorB : colorA;

        // Ombreig vertical cap avall (dithered, no degradat suau).
        final vProgress = ((row / rows) - 0.3) / 0.7;
        if (vProgress > 0 && vProgress.clamp(0.0, 1.0) > threshold) {
          pixelColor = _shadowColor;
        }

        paint.color = pixelColor;

        canvas.drawRect(
          Rect.fromLTWH(
            col * _pixelSize,
            row * _pixelSize,
            _pixelSize,
            _pixelSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DitherBannerPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
