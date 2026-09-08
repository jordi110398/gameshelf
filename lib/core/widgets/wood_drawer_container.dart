import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

const _woodDrawerGradients = {
  ShelfWoodColor.walnut: [Color(0xFF2A2420), Color(0xFF120F0D)],
  ShelfWoodColor.oak: [Color(0xFF3A2A16), Color(0xFF1C130A)],
  ShelfWoodColor.ebony: [Color(0xFF201F22), Color(0xFF0A0A0B)],
  ShelfWoodColor.cherry: [Color(0xFF3A1F1A), Color(0xFF1A0C09)],
  ShelfWoodColor.birch: [Color(0xFF8C7A56), Color(0xFF4A3F2A)],
};

/// Decoració de "calaix de fusta" semi-transparent, reutilitzable en
/// contenidors que no són pròpiament una `Material` (o quan cal compondre-la
/// amb un `Material` transparent a sobre per mantenir el ripple del tap).
/// És translúcida a propòsit perquè el fons de fusta de la pantalla
/// (vegeu `BookshelfBackground`) es transllueixi una mica per darrere.
BoxDecoration woodDrawerDecoration({
  BorderRadiusGeometry borderRadius = const BorderRadius.all(
    Radius.circular(16),
  ),
  ShelfWoodColor color = ShelfWoodColor.walnut,
}) {
  final tones = _woodDrawerGradients[color]!;

  return BoxDecoration(
    borderRadius: borderRadius,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [tones[0].withValues(alpha: 0.78), tones[1].withValues(alpha: 0.86)],
    ),
    border: Border.all(color: Colors.black.withValues(alpha: 0.25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

/// Contenidor amb aparença de calaix de fusta, per a targetes que no són
/// pròpiament una "lleixa" de jocs (estadístiques, reviews...). Passa
/// [color] explícitament quan representa el calaix d'un perfil concret;
/// deixa'l `null` per seguir en temps real la preferència de l'usuari
/// actual (`ShelfSkinService`), com `BookshelfBackground`.
class WoodDrawerContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final ShelfWoodColor? color;

  const WoodDrawerContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return _buildContainer(color!);
    }

    return ValueListenableBuilder<ShelfWoodColor>(
      valueListenable: ShelfSkinService.instance.woodColor,
      builder: (context, ambientColor, _) => _buildContainer(ambientColor),
    );
  }

  Widget _buildContainer(ShelfWoodColor resolvedColor) {
    return Container(
      decoration: woodDrawerDecoration(
        borderRadius: borderRadius,
        color: resolvedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nansa del calaix.
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
