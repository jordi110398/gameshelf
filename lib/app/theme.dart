import 'package:flutter/material.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Un únic tema visual, derivat del color de fusta triat per l'usuari
/// (`ShelfSkinService`) en lloc d'un selector de tema separat -- així
/// l'aparença de l'app i la de les seves estanteries van sempre a joc.
class AppTheme {
  const AppTheme._();

  /// El "walnut" (per defecte) és exactament el tema fosc original de
  /// l'app, perquè qui no toqui la configuració no vegi cap canvi.
  static ThemeData forWood(ShelfWoodColor wood) {
    switch (wood) {
      case ShelfWoodColor.walnut:
        return _themeFor(
          seedColor: const Color(0xFF8B5CF6),
          background: const Color(0xFF0D0D14),
          surface: const Color(0xFF141A23),
        );
      case ShelfWoodColor.oak:
        return _themeFor(
          seedColor: const Color(0xFFC17F3A),
          background: const Color(0xFF14100A),
          surface: const Color(0xFF201810),
        );
      case ShelfWoodColor.ebony:
        return _themeFor(
          seedColor: const Color(0xFF9296A0),
          background: const Color(0xFF0A0A0B),
          surface: const Color(0xFF18181B),
        );
      case ShelfWoodColor.cherry:
        return _themeFor(
          seedColor: const Color(0xFFC15A4A),
          background: const Color(0xFF160B0A),
          surface: const Color(0xFF231310),
        );
      case ShelfWoodColor.birch:
        return _themeFor(
          seedColor: const Color(0xFFD9B24C),
          background: const Color(0xFF171409),
          surface: const Color(0xFF241F13),
        );
    }
  }

  static ThemeData _themeFor({
    required Color seedColor,
    required Color background,
    required Color surface,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ).copyWith(surface: surface),
    );
  }
}
