import 'package:flutter/material.dart';
import 'package:gameshelf/core/localization/app_localizations_x.dart';

/// Valor especial per quan l'usuari no vol (o no pot) triar cap de les
/// plataformes reals d'IGDB per a aquest joc.
String platformNotSpecified(BuildContext context) =>
    context.l10n.platformNotSpecified;

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

/// Abreviatura curta d'una plataforma per mostrar en petit (p. ex. a la
/// base d'un cartutx): "NS2", "PS5", "PC", "XBOX"... `null` si no hi ha
/// plataforma.
String? platformAbbreviation(String? platform) {
  if (platform == null) return null;

  final p = platform.toLowerCase();

  if (p.contains('switch 2')) return 'NS2';
  if (p.contains('switch')) return 'NS';
  if (p.contains('playstation 5')) return 'PS5';
  if (p.contains('playstation 4')) return 'PS4';
  if (p.contains('playstation 3')) return 'PS3';
  if (p.contains('playstation vita')) return 'VITA';
  if (p.contains('playstation')) return 'PS';
  if (p.contains('series x') || p.contains('series s')) return 'XSX';
  if (p.contains('xbox one')) return 'XB1';
  if (p.contains('xbox 360')) return 'X360';
  if (p.contains('xbox')) return 'XBOX';
  if (p.contains('windows') || p.contains('pc')) return 'PC';
  if (p.contains('mac')) return 'MAC';
  if (p.contains('linux')) return 'LNX';
  if (p.contains('ios')) return 'IOS';
  if (p.contains('android')) return 'AND';
  if (p.contains('wii u')) return 'WIIU';
  if (p.contains('wii')) return 'WII';
  if (p.contains('3ds')) return '3DS';
  if (p.contains('nintendo 64')) return 'N64';

  // Sense coincidència coneguda: sigles a partir de les primeres
  // lletres de cada paraula (p. ex. "Sega Genesis" -> "SG").
  final words = platform
      .split(RegExp(r'[\s(]+'))
      .where((w) => w.isNotEmpty)
      .toList();

  if (words.isEmpty) return null;

  final initials = words.take(3).map((w) => w[0].toUpperCase()).join();
  return initials.isEmpty ? null : initials;
}
