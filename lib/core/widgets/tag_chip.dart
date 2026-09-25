import 'package:flutter/material.dart';

/// Píndola d'icona + text amb un color (fons a alpha 0.15, vora a alpha
/// 0.35, icona i text sòlids) -- el mateix estil que els tags de
/// personalitat del perfil, reutilitzat també per gèneres i plataformes
/// dels jocs perquè comparteixin llenguatge visual.
class TagChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const TagChip({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
