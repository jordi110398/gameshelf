import 'package:flutter/material.dart';
import 'package:gameshelf/core/strings/social_strings.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';

class SocialGameDetailPage extends StatelessWidget {
  final LibraryGame libraryGame;
  final String nickname;

  const SocialGameDetailPage({
    super.key,
    required this.libraryGame,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    final game = libraryGame.game;
    final userGame = libraryGame.userGame;
    final status = userGame.status;

    return Scaffold(
      appBar: AppBar(title: Text(game.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PORTADA
            Hero(
              tag: 'social-${game.igdbId}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: game.coverUrl != null
                    ? Image.network(
                        game.coverUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 330,
                        width: double.infinity,
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.image_not_supported, size: 48),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // TÍTOL
            Text(
              game.title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ESTAT + RATING + HORES
            Wrap(
              spacing: 18,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(status.icon, color: status.color),
                    const SizedBox(width: 6),
                    Text(status.displayName),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingStars(rating: userGame.rating ?? 0, size: 22),
                  ],
                ),

                if (status != GameStatus.wantToPlay)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 20),
                      const SizedBox(width: 6),
                      Text("${userGame.hoursPlayed}h"),
                    ],
                  ),
              ],
            ),

            // REVIEW
            if (status != GameStatus.wantToPlay &&
                userGame.review != null &&
                userGame.review!.trim().isNotEmpty) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    "${SocialStrings.reviewOfPrefix}$nickname",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  RatingStars(rating: userGame.rating ?? 0, size: 20),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                '"${userGame.review!.trim()}"',
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],

            // DESCRIPCIÓ DEL JOC
            if (game.summary != null && game.summary!.trim().isNotEmpty) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              const Text(
                "Descripció",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Text(game.summary!, style: const TextStyle(height: 1.5)),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
