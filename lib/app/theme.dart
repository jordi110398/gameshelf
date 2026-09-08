import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0D0D14),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: Brightness.dark,
    ).copyWith(surface: const Color(0xFF141A23)),
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF5F4F8),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: Brightness.light,
    ),
  );

  /// Estètica retro Game Boy Advance: cantonades quadrades a tot arreu i
  /// una paleta molt saturada (lila de la carcassa + accents RGB dels
  /// botons A/B).
  static ThemeData gba = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF241640),

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF6E2FE0),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF6E2FE0),
          secondary: const Color(0xFFFF3B6B),
          tertiary: const Color(0xFF2FE0A0),
          surface: const Color(0xFF2E1B52),
        ),

    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    chipTheme: const ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),

    snackBarTheme: const SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );
}
