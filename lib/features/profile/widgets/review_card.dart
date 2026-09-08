import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/repositories/activity_repository.dart';

/// Targeta d'una review (coberta + títol + puntuació + text + likes),
/// reutilitzada al resum del perfil (`_buildReviewsSummary`) i a la
/// pàgina amb totes les reviews.
class ReviewCard extends StatelessWidget {
  final LibraryGame libraryGame;
  final ReviewLikes? likes;
  final bool isLightWood;
  final VoidCallback? onTap;

  const ReviewCard({
    super.key,
    required this.libraryGame,
    this.likes,
    required this.isLightWood,
    this.onTap,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: 65,
      height: 95,
      color: Colors.grey.shade800,
      child: const Icon(Icons.videogame_asset, color: Colors.white54),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = libraryGame.game;
    final userGame = libraryGame.userGame;

    final card = WoodDrawerContainer(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PORTADA
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: game.coverUrl != null && game.coverUrl!.isNotEmpty
                ? Image.network(
                    game.coverUrl!,
                    width: 65,
                    height: 95,
                    fit: BoxFit.cover,
                    cacheWidth: 130,
                    errorBuilder: (_, _, _) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),

          const SizedBox(width: 14),

          // INFORMACIÓ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                if (userGame.rating != null)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < userGame.rating!.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: Colors.amber,
                      );
                    }),
                  ),

                const SizedBox(height: 8),

                Text(
                  '"${userGame.review!}"',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontStyle: FontStyle.italic,
                    color: isLightWood
                        ? Colors.grey.shade900
                        : Colors.grey.shade700,
                  ),
                ),

                if (likes != null && likes!.likeCount > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        likes!.likedByMe ? Icons.star : Icons.star_border,
                        size: 15,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${likes!.likeCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: onTap == null
          ? card
          : InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: card,
            ),
    );
  }
}
