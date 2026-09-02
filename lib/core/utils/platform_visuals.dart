import 'package:flutter/material.dart';

/// Valor especial per quan l'usuari no vol (o no pot) triar cap de les
/// plataformes reals d'IGDB per a aquest joc.
const platformNotSpecified = 'No especificat';

class PlatformVisual {
  final IconData icon;
  final Color color;

  const PlatformVisual(this.icon, this.color);
}

/// Icona i color genèrics per a una plataforma (mateixa icona per a totes
/// les consoles, diferenciades només pel color, per evitar fer servir
/// logos de marques de tercers). Retorna `null` si no es reconeix la
/// plataforma (per exemple [platformNotSpecified]), cas en què no es
/// mostra cap insígnia.
PlatformVisual? platformVisualFor(String? platform) {
  if (platform == null) return null;

  final p = platform.toLowerCase();

  if (p.contains('playstation')) {
    return const PlatformVisual(Icons.sports_esports, Color(0xFF0070D1));
  }

  if (p.contains('xbox')) {
    return const PlatformVisual(Icons.sports_esports, Color(0xFF107C10));
  }

  if (p.contains('switch') || p.contains('nintendo')) {
    return const PlatformVisual(Icons.sports_esports, Color(0xFFE60012));
  }

  if (p.contains('pc') ||
      p.contains('windows') ||
      p.contains('mac') ||
      p.contains('linux')) {
    return const PlatformVisual(Icons.computer, Color(0xFF64748B));
  }

  if (p.contains('ios') ||
      p.contains('android') ||
      p.contains('mobile') ||
      p.contains('phone')) {
    return const PlatformVisual(Icons.smartphone, Color(0xFF8B5CF6));
  }

  return null;
}
