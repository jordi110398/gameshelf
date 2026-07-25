import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(game.title)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // PORTADA
            Hero(
              tag: game.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(game.cover, width: 220),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              game.title,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            RatingStars(rating: game.rating, size: 28),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  game.status == GameStatus.completed
                      ? Icons.check_circle
                      : Icons.cancel,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.schedule),

                const SizedBox(width: 8),

                Text("${game.hoursPlayed} hores"),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.computer),

                const SizedBox(width: 8),

                Text(game.platform),
              ],
            ),

            const SizedBox(height: 32),

            const Divider(),

            const SizedBox(height: 24),

            const Text(
              "La meva review",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              game.review,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

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
