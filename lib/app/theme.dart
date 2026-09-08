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

  /// Estètica retro estil consola (Game Boy Advance/GameCube): carcassa
  /// grisa neutra, cantonades quadrades a tot arreu, i els 4 botons de
  /// control (verd/blau/vermell/groc) fent d'accent, com els botons de
  /// cara d'un comandament clàssic.
  static ThemeData gba = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: gbaGrey900,

    colorScheme: ColorScheme.fromSeed(
      seedColor: gbaGrey500,
      brightness: Brightness.dark,
    ).copyWith(
      primary: gbaGrey300,
      onPrimary: Colors.black,
      secondary: gbaBlue,
      tertiary: gbaYellow,
      surface: gbaGrey800,
      surfaceContainerHighest: gbaGrey700,
      outline: gbaGrey600,
    ),

    cardTheme: const CardThemeData(
      color: gbaGrey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: gbaGrey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: gbaGrey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    // Botó A: confirmar/guardar -- verd.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: gbaGreen,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    // Botó B: acció secundària -- vermell.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gbaRed,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    // Botó X: contorn -- blau.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: gbaBlue,
        side: const BorderSide(color: gbaBlue, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    // Botó Y: text -- groc.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: gbaYellow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: gbaGrey700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: gbaGrey800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: gbaGrey600),
      ),
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: gbaGrey700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    extensions: const [AppShapes(radius: 0)],
  );
}

// Paleta "carcassa de consola" -- grisos neutres del cos + els 4 colors
// de botó, reutilitzats des de fora (p. ex. per pintar l'aparença
// quadrada de miniatures i altres elements no derivats de ThemeData).
const gbaGrey900 = Color(0xFF232427);
const gbaGrey800 = Color(0xFF2D2E32);
const gbaGrey700 = Color(0xFF3B3C41);
const gbaGrey600 = Color(0xFF4C4D53);
const gbaGrey500 = Color(0xFF6B6C73);
const gbaGrey300 = Color(0xFFB9BAC0);

const gbaGreen = Color(0xFF2FAE59);
const gbaBlue = Color(0xFF2E86D8);
const gbaRed = Color(0xFFE0392E);
const gbaYellow = Color(0xFFF4C430);

/// Radi de cantonada a fer servir en widgets pintats a mà (no derivats
/// d'un `*ThemeData` de Material) perquè també es tornin quadrats amb el
/// tema GBA -- vegeu `appRadius()`.
class AppShapes extends ThemeExtension<AppShapes> {
  final double radius;

  const AppShapes({required this.radius});

  @override
  AppShapes copyWith({double? radius}) {
    return AppShapes(radius: radius ?? this.radius);
  }

  @override
  AppShapes lerp(ThemeExtension<AppShapes>? other, double t) {
    if (other is! AppShapes) return this;
    return AppShapes(radius: radius + (other.radius - radius) * t);
  }
}

/// `BorderRadius.circular(radius)` normalment, o quadrat si el tema
/// actual ho demana (`AppShapes`, només present al tema GBA). Fet servir
/// a miniatures/targetes pintades amb `ClipRRect`/`BoxDecoration` en lloc
/// d'un `*ThemeData` estàndard.
BorderRadius appRadius(BuildContext context, double radius) {
  final shapes = Theme.of(context).extension<AppShapes>();
  return BorderRadius.circular(shapes?.radius ?? radius);
}
