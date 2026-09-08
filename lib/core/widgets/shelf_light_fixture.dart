import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/core/widgets/shelf_led_strip.dart';
import 'package:gameshelf/core/widgets/shelf_lights.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Tria entre [ShelfLedStrip] (neó) i [ShelfLights] (fil de bombetes)
/// segons la preferència d'estètica de l'estanteria. Passa [style]
/// explícitament quan es mostra l'estanteria d'un perfil concret; deixa'l
/// `null` per a decoració genèrica, que segueix en temps real la
/// preferència de l'usuari actual (`ShelfSkinService`).
class ShelfLightFixture extends StatelessWidget {
  final double width;
  final ShelfLightStyle? style;

  const ShelfLightFixture({super.key, required this.width, this.style});

  @override
  Widget build(BuildContext context) {
    if (style != null) {
      return _build(style!);
    }

    return ValueListenableBuilder<ShelfLightStyle>(
      valueListenable: ShelfSkinService.instance.lightStyle,
      builder: (context, ambientStyle, _) => _build(ambientStyle),
    );
  }

  Widget _build(ShelfLightStyle resolvedStyle) {
    switch (resolvedStyle) {
      case ShelfLightStyle.neon:
        return ShelfLedStrip(width: width);
      case ShelfLightStyle.bulbs:
        return ShelfLights(width: width);
    }
  }
}
