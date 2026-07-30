import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/features/game/pages/edit_game_page.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;
  final UserGame? userGame;

  const GameDetailPage({super.key, required this.game, this.userGame});

  @override
  Widget build(BuildContext context) {
    final inLibrary = userGame != null;

    return Scaffold(
      appBar: AppBar(title: Text(game.title)),
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
                    ? Image.network(game.coverUrl!, width: 220)
                    : const SizedBox(
                        width: 220,
                        height: 330,
                        child: ColoredBox(color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              game.title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            if (game.releaseDate != null) ...[
              const SizedBox(height: 8),
              Text(
                "${game.releaseDate!.year}",
                style: const TextStyle(fontSize: 18),
              ),
            ],

            if (game.rating != null) ...[
              const SizedBox(height: 12),
              Text("Valoració IGDB: ${game.rating!.toStringAsFixed(1)}"),
            ],

            if (inLibrary) ...[
              const SizedBox(height: 24),

              RatingStars(rating: userGame!.rating ?? 0, size: 28),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    userGame!.status == GameStatus.completed
                        ? Icons.check_circle
                        : Icons.play_circle,
                  ),
                  const SizedBox(width: 8),
                  Text(userGame!.status.name),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.schedule),
                  const SizedBox(width: 8),
                  Text("${userGame!.hoursPlayed} hores"),
                ],
              ),
            ],

            if (game.summary != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),

              const Text(
                "Descripció",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Text(game.summary!),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  if (userGame == null) {
                    final repository = SupabaseLibraryRepository(
                      Supabase.instance.client,
                    );

                    await repository.addToLibrary(game);

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditGamePage(game: game, userGame: userGame!),
                      ),
                    );
                    if (refresh == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                icon: Icon(inLibrary ? Icons.edit : Icons.add),
                label: Text(inLibrary ? "Editar" : "Afegir a la biblioteca"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
