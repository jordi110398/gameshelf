import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/user_tags_service.dart';
import 'package:gameshelf/models/library_game.dart';

/// Etiquetes de personalitat calculades a partir dels gèneres de la
/// biblioteca (veure [UserTagsService]). Reutilitzat al propi perfil i
/// al d'altres usuaris.
class UserTagsRow extends StatelessWidget {
  final List<LibraryGame> games;

  static const _tagsService = UserTagsService();

  const UserTagsRow({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final tags = _tagsService.tagsFromGames(games);

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final style = _tagsService.styleForTag(tag);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: style.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: style.color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: 14, color: style.color),
              const SizedBox(width: 5),
              Text(
                tag,
                style: TextStyle(
                  color: style.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
