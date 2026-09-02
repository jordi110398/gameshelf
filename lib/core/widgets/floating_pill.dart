import 'dart:ui';

import 'package:flutter/material.dart';

/// Contenidor flotant en forma de càpsula amb efecte de vidre glaçat
/// (semi-transparent + blur), fet servir tant per la barra de navegació
/// inferior com per altres barres flotants (p. ex. la de filtres d'Inici),
/// per mantenir una mateixa identitat visual.
class FloatingPill extends StatelessWidget {
  final Widget child;
  final double height;
  final double borderRadius;

  const FloatingPill({
    super.key,
    required this.child,
    this.height = 66,
    this.borderRadius = 33,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.55),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: child,
        ),
      ),
    );
  }
}
