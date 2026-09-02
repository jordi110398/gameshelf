// lib/services/user_tags_service.dart

import 'package:flutter/material.dart';
import 'package:gameshelf/models/library_game.dart';

typedef TagStyle = ({IconData icon, Color color});

class UserTagsService {
  const UserTagsService();

  // ─────────────────────────────────────────────
  // MAPA GÈNERE → TAG
  // ─────────────────────────────────────────────

  // Claus en minúscules tal com arriben d'IGDB (`genres.name`). Alguns
  // gèneres tenen més d'un nom possible segons la versió de l'API o el
  // moment en què es va desar el joc, per això hi ha alies duplicats
  // apuntant al mateix tag.
  static const Map<String, String> _genreToTagMap = {
    'role-playing': 'Roleplayer',
    'role-playing (rpg)': 'Roleplayer',
    'rpg': 'Roleplayer',
    'adventure': 'Adventurous',
    'action': 'Action junkie',
    'strategy': 'Control freak',
    'real time strategy (rts)': 'Control freak',
    'turn-based strategy (tbs)': 'Control freak',
    'tactical': 'Control freak',
    'simulator': 'Farmer',
    'simulation': 'Farmer',
    'sport': 'Uncle',
    'sports': 'Uncle',
    'racing': 'Speedster',
    'shooter': 'Hawk-eye',
    'platform': 'Jump addict',
    'platformer': 'Jump addict',
    'fighting': 'Steel knuckles',
    "hack and slash/beat 'em up": 'Steel knuckles',
    'puzzle': 'Puzzle lover',
    'indie': 'Indie soul',
    'horror': 'Fearless',
    'arcade': 'Arcade lover',
    'pinball': 'Arcade lover',
    'music': 'Rhythm master',
    'point-and-click': 'Detective',
    'quiz/trivia': 'Know-it-all',
    'visual novel': 'Storyteller',
    'card & board game': 'Tabletop nerd',
    'moba': 'Team captain',
  };

  // ─────────────────────────────────────────────
  // MAPA TAG → ESTIL (icona + color)
  // ─────────────────────────────────────────────

  // Paleta inspirada en els colors clàssics de carcasses/cartutxos de GBA
  // (Indigo, Glacier, Flame Red, Cobalt, Spice, Fuchsia...): tons saturats
  // però una mica "apagats", no neons moderns, per generar banners amb
  // aquell aire retro.
  static const Map<String, TagStyle> _tagStyles = {
    'Roleplayer': (icon: Icons.auto_fix_high, color: Color(0xFF5B4E8C)),
    'Adventurous': (icon: Icons.explore, color: Color(0xFF4A9FB0)),
    'Action junkie': (icon: Icons.bolt, color: Color(0xFFD93A2B)),
    'Control freak': (icon: Icons.psychology, color: Color(0xFF2E5C9E)),
    'Dreamer': (icon: Icons.settings, color: Color(0xFF7C8FD1)),
    'Uncle': (icon: Icons.sports_soccer, color: Color(0xFF4F9B4A)),
    'Speedster': (icon: Icons.directions_car, color: Color(0xFFE08A2E)),
    'Hawk-eye': (icon: Icons.gps_fixed, color: Color(0xFFB08D3E)),
    'Jump addict': (icon: Icons.stairs, color: Color(0xFF3FBFA0)),
    'Steel knuckles': (icon: Icons.sports_mma, color: Color(0xFFB0522E)),
    'Puzzle lover': (icon: Icons.extension, color: Color(0xFFC43D82)),
    'Indie soul': (icon: Icons.favorite, color: Color(0xFF7048A0)),
    'Fearless': (icon: Icons.nightlight, color: Color(0xFF4A3350)),
    'Arcade lover': (icon: Icons.videogame_asset, color: Color(0xFFD9A22E)),
    'Farmer': (icon: Icons.agriculture, color: Color(0xFF6B8E3D)),
    'Rhythm master': (icon: Icons.music_note, color: Color(0xFFA63D8F)),
    'Detective': (icon: Icons.search, color: Color(0xFF8A6F4E)),
    'Know-it-all': (icon: Icons.lightbulb, color: Color(0xFF3EA6D9)),
    'Storyteller': (icon: Icons.menu_book, color: Color(0xFFC97A9E)),
    'Tabletop nerd': (icon: Icons.casino, color: Color(0xFF8C6239)),
    'Team captain': (icon: Icons.shield, color: Color(0xFFA83250)),
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
