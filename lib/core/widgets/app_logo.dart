import 'package:flutter/material.dart';

/// Logo "GS"/"GameShelf" fet servir com a `leading` a les pantalles arrel
/// (Inici, Social, Perfil), consistent amb el que ja hi havia a l'AppBar
/// d'Inici.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  static double width(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return isMobile ? 82 : 150;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_esports,
            color: Colors.deepPurple,
            size: isMobile ? 22 : 28,
          ),
          const SizedBox(width: 6),
          Text(
            isMobile ? "GS" : "GameShelf",
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
