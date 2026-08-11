import 'package:flutter/material.dart';

enum GameStatus {
  wantToPlay,
  playing,
  completed,
  dropped,
  paused,
}

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

  String get displayName {
    switch (this) {
      case GameStatus.wantToPlay:
        return "Want to Play";

      case GameStatus.playing:
        return "Playing";

      case GameStatus.completed:
        return "Completed";

      case GameStatus.dropped:
        return "Dropped";

      case GameStatus.paused:
        return "Paused";
    }
  }
}
