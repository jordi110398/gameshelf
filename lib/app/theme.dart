import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0D0D14),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8B5CF6),
      surface: Color(0xFF141A23),
    ),
  );
}