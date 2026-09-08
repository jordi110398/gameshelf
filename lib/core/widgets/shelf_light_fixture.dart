import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/shelf_led_strip.dart';
import 'package:gameshelf/core/widgets/shelf_lights.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Tria entre [ShelfLedStrip] (neó) i [ShelfLights] (fil de bombetes)
/// segons la preferència d'estètica de l'estanteria del perfil a qui
/// pertany -- vegeu [BookshelfBackground] per al mateix criteri aplicat
/// al color de la fusta.
class ShelfLightFixture extends StatelessWidget {
  final double width;
  final ShelfLightStyle style;

  const ShelfLightFixture({
    super.key,
    required this.width,
    this.style = ShelfLightStyle.neon,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ShelfLightStyle.neon:
        return ShelfLedStrip(width: width);
      case ShelfLightStyle.bulbs:
        return ShelfLights(width: width);
    }
  }
}
