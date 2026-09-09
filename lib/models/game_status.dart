import 'package:flutter/material.dart';
import 'package:gameshelf/core/localization/app_localizations_x.dart';

enum GameStatus { wantToPlay, playing, completed, dropped, paused }

extension GameStatusExtension on GameStatus {
  IconData get icon {
    switch (this) {
      case GameStatus.wantToPlay:
        return Icons.bookmark;

      case GameStatus.playing:
        return Icons.play_circle;

      case GameStatus.completed:
        return Icons.check_circle;

      case GameStatus.dropped:
        return Icons.cancel;

      case GameStatus.paused:
        return Icons.pause_circle;
    }
  }

  Color get color {
    switch (this) {
      case GameStatus.wantToPlay:
        return const Color.fromARGB(255, 7, 140, 206);

      case GameStatus.playing:
        return Colors.deepPurple;

      case GameStatus.completed:
        return Colors.green;

      case GameStatus.dropped:
        return Colors.red;

      case GameStatus.paused:
        return Colors.orange;
    }
  }

  String get databaseValue {
    switch (this) {
      case GameStatus.wantToPlay:
        return "want_to_play";

      case GameStatus.playing:
        return "playing";

      case GameStatus.completed:
        return "completed";

      case GameStatus.dropped:
        return "dropped";

      case GameStatus.paused:
        return "paused";
    }
  }

  String localizedDisplayName(BuildContext context) {
    switch (this) {
      case GameStatus.wantToPlay:
        return context.l10n.gameStatusWantToPlay;

      case GameStatus.playing:
        return context.l10n.gameStatusPlaying;

      case GameStatus.completed:
        return context.l10n.gameStatusCompleted;

      case GameStatus.dropped:
        return context.l10n.gameStatusDropped;

      case GameStatus.paused:
        return context.l10n.gameStatusPaused;
    }
  }
}
