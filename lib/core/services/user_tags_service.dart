// lib/services/user_tags_service.dart

import 'package:flutter/material.dart';
import 'package:gameshelf/models/library_game.dart';

typedef TagStyle = ({IconData icon, Color color});

class UserTagsService {
  const UserTagsService();

  // ─────────────────────────────────────────────
  // MAPA GÈNERE → TAG
  // ─────────────────────────────────────────────

  static const Map<String, String> _genreToTagMap = {
    'role-playing': 'Roleplayer',
    'rpg': 'Roleplayer',
    'adventure': 'Adventurous',
    'action': 'Action junkie',
    'strategy': 'Control freak',
    'simulation': 'Dreamer',
    'sports': 'Uncle',
    'racing': 'Speedster',
    'shooter': 'Hawk-eye',
    'platform': 'Jump addict',
    'platformer': 'Jump addict',
    'fighting': 'Steel knuckles',
    'puzzle': 'Puzzle lover',
    'indie': 'Indie soul',
    'horror': 'Fearless',
    'arcade': 'Arcade lover',
  };

  // ─────────────────────────────────────────────
  // MAPA TAG → ESTIL (icona + color)
  // ─────────────────────────────────────────────

  static const Map<String, TagStyle> _tagStyles = {
    'Roleplayer': (icon: Icons.auto_fix_high, color: Colors.deepPurple),
    'Adventurous': (icon: Icons.explore, color: Colors.teal),
    'Action junkie': (icon: Icons.bolt, color: Colors.redAccent),
    'Control freak': (icon: Icons.psychology, color: Colors.indigo),
    'Dreamer': (icon: Icons.settings, color: Colors.blueGrey),
    'Uncle': (icon: Icons.sports_soccer, color: Colors.green),
    'Speedster': (icon: Icons.directions_car, color: Colors.orange),
    'Hawk-eye': (icon: Icons.gps_fixed, color: Colors.brown),
    'Jump addict': (icon: Icons.stairs, color: Colors.cyan),
    'Steel knuckles': (icon: Icons.sports_mma, color: Colors.deepOrange),
    'Puzzle lover': (icon: Icons.extension, color: Colors.pink),
    'Indie soul': (icon: Icons.favorite, color: Colors.purple),
    'Fearless': (icon: Icons.nightlight, color: Colors.black87),
    'Arcade lover': (icon: Icons.videogame_asset, color: Colors.amber),
  };

  static const TagStyle _defaultStyle = (
    icon: Icons.label,
    color: Colors.deepPurple,
  );

  // ─────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────

  /// Calcula els tags (màxim 4) a partir dels jocs de la llibreria,
  /// ordenats per freqüència de gènere.
  List<String> tagsFromGames(List<LibraryGame> games) {
    if (games.isEmpty) return [];

    final genreCount = <String, int>{};

    for (final libraryGame in games) {
      for (final genre in libraryGame.game.genres) {
        final normalized = genre.trim();
        if (normalized.isEmpty) continue;

        genreCount[normalized] = (genreCount[normalized] ?? 0) + 1;
      }
    }

    if (genreCount.isEmpty) return [];

    final sortedGenres = genreCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final tags = <String>[];

    for (final entry in sortedGenres) {
      final tag = _genreToTag(entry.key);

      if (tag != null && !tags.contains(tag)) {
        tags.add(tag);
      }

      if (tags.length >= 4) break;
    }

    return tags;
  }

  /// Retorna l'estil (icona + color) associat a un tag.
  TagStyle styleForTag(String tag) => _tagStyles[tag] ?? _defaultStyle;

  String? _genreToTag(String genre) => _genreToTagMap[genre.toLowerCase()];
}
