import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/user_tags_service.dart';
import 'package:gameshelf/core/widgets/tag_chip.dart';
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

        return TagChip(icon: style.icon, color: style.color, label: tag);
      }).toList(),
    );
  }
}
