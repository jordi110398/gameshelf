import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/profile_strings.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/features/profile/widgets/review_card.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/models/shelf_style.dart';
import 'package:gameshelf/repositories/activity_repository.dart';

/// Totes les reviews d'un perfil (el resum a `UserProfilePage` només en
/// mostra les 3 primeres). Rep les dades ja carregades -- no torna a
/// consultar el servidor.
class AllReviewsPage extends StatelessWidget {
  final Profile profile;
  final List<LibraryGame> reviewedGames;
  final Map<int, ReviewLikes> reviewLikes;

  const AllReviewsPage({
    super.key,
    required this.profile,
    required this.reviewedGames,
    required this.reviewLikes,
  });

  @override
  Widget build(BuildContext context) {
    final isLightWood = profile.shelfWoodColor.isLight;

    return Scaffold(
      appBar: AppBar(title: const Text(ProfileStrings.myReviewsTitle)),
      body: Stack(
        children: [
          Positioned.fill(
            child: BookshelfBackground(color: profile.shelfWoodColor),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviewedGames.length,
            itemBuilder: (context, index) {
              final libraryGame = reviewedGames[index];

              return ReviewCard(
                libraryGame: libraryGame,
                likes: reviewLikes[libraryGame.game.igdbId],
                isLightWood: isLightWood,
                onTap: () async {
                  await pushFade(
                    context,
                    (_) => GameDetailPage(game: libraryGame.game),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
