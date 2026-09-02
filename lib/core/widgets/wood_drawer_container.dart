import 'package:flutter/material.dart';

/// Decoració de "calaix de fusta" semi-transparent, reutilitzable en
/// contenidors que no són pròpiament una `Material` (o quan cal compondre-la
/// amb un `Material` transparent a sobre per mantenir el ripple del tap).
/// És translúcida a propòsit perquè el fons de fusta de la pantalla
/// (vegeu `BookshelfBackground`) es transllueixi una mica per darrere.
BoxDecoration woodDrawerDecoration({
  BorderRadiusGeometry borderRadius = const BorderRadius.all(
    Radius.circular(16),
  ),
}) {
  return BoxDecoration(
    borderRadius: borderRadius,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF2A2420).withValues(alpha: 0.78),
        const Color(0xFF120F0D).withValues(alpha: 0.86),
      ],
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
/// pròpiament una "lleixa" de jocs (estadístiques, reviews...).
class WoodDrawerContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const WoodDrawerContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: woodDrawerDecoration(borderRadius: borderRadius),
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
