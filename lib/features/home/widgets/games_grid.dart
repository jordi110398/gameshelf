import 'package:flutter/material.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/home_strings.dart';
import 'package:gameshelf/core/widgets/shelf_list.dart';
import 'package:gameshelf/models/library_game.dart';
import 'game_card.dart';

class GameGrid extends StatefulWidget {
  final List<LibraryGame> games;
  final VoidCallback onLibraryChanged;
  final Future<void> Function(LibraryGame game) onGameDeleted;

  const GameGrid({
    super.key,
    required this.games,
    required this.onLibraryChanged,
    required this.onGameDeleted,
  });

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  int? activeGameId;

  void activateGame(int gameId) {
    setState(() {
      activeGameId = gameId;
    });
  }

  @override
  void didUpdateWidget(covariant GameGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el joc actiu ja no existeix després d'un refresh,
    // desactivem la card.
    if (activeGameId != null &&
        !widget.games.any((game) => game.game.igdbId == activeGameId)) {
      activeGameId = null;
    }
  }

  Widget _buildCard(LibraryGame libraryGame) {
    final gameId = libraryGame.game.igdbId;

    return Dismissible(
      key: ValueKey(gameId),

      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),

      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(HomeStrings.deleteGameTitle),
              content: Text(
                '${HomeStrings.deleteGameBodyPrefix}'
                '${libraryGame.game.title}'
                '${HomeStrings.deleteGameBodySuffix}',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(AppStrings.actionCancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(AppStrings.actionDelete),
                ),
              ],
            );
          },
        );
      },

      onDismissed: (_) async {
        if (activeGameId == gameId) {
          setState(() {
            activeGameId = null;
          });
        }

        await widget.onGameDeleted(libraryGame);
      },

      child: GameCard(
        libraryGame: libraryGame,
        onLibraryChanged: widget.onLibraryChanged,

        isActive: activeGameId == gameId,

        onActivate: () {
          activateGame(gameId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShelfList<LibraryGame>(
      items: widget.games,
      minItemWidth: 130,
      minColumns: 3,
      itemAspectRatio: 2 / 3,
      horizontalGap: 12,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      itemBuilder: (context, libraryGame) => _buildCard(libraryGame),
    );
  }
}
