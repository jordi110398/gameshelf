import 'package:flutter/material.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';

class Stats extends StatelessWidget {
  final List<LibraryGame> games;

  const Stats({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    final totalGames = games.length;

    final completedGames = games.where(
      (game) => game.userGame.status == GameStatus.completed,
    ).length;

    final totalHours = games.fold<int>(
      0,
      (sum, game) => sum + game.userGame.hoursPlayed,
    );

    return Row(
      children: [
        Text("$totalGames jocs"),
        const SizedBox(width: 24),
        Text("$completedGames completats"),
        const SizedBox(width: 24),
        Text("Total jugat: ${totalHours}h"),
      ],
    );
  }
}