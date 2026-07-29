import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';

class GameDetailPage extends StatelessWidget {
  final LibraryGame libraryGame;

  const GameDetailPage({
    super.key,
    required this.libraryGame,
  });

  @override
  Widget build(BuildContext context) {
    final game = libraryGame.game;
    final userGame = libraryGame.userGame;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: game.igdbId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: game.coverUrl != null
                    ? Image.network(
                        game.coverUrl!,
                        width: 220,
                      )
                    : const SizedBox(
                        width: 220,
                        height: 330,
                        child: ColoredBox(color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              game.title,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            RatingStars(
              rating: userGame.rating ?? 0,
              size: 28,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  userGame.status == GameStatus.completed
                      ? Icons.check_circle
                      : Icons.play_circle,
                ),
                const SizedBox(width: 8),
                Text(userGame.status.name),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.schedule),
                const SizedBox(width: 8),
                Text("${userGame.hoursPlayed} hores"),
              ],
            ),

            if (game.summary != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                "Descripció",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                game.summary!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],

            if (userGame.review != null &&
                userGame.review!.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                "La meva review",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userGame.review!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Editar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}