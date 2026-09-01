import 'package:flutter/material.dart';

/// Limita l'amplada del contingut a pantalles grans (escriptori/web),
/// centrant-lo horitzontalment. A mòbil, per sota de [maxWidth], no fa
/// res (el contingut ja ocupa tota l'amplada disponible).
class ResponsiveCenter extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const ResponsiveCenter({
    super.key,
    required this.maxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
