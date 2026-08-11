import 'package:flutter/material.dart';
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
        !widget.games.any(
          (game) => game.game.igdbId == activeGameId,
        )) {
      activeGameId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth / 190).floor();

        if (columns < 2) {
          columns = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: widget.games.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 3,
          ),

          itemBuilder: (context, index) {
            final libraryGame = widget.games[index];
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
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Eliminar joc"),
                      content: Text(
                        "Vols eliminar "
                        "${libraryGame.game.title} "
                        "de la biblioteca?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel·lar"),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Eliminar"),
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
          },
        );
      },
    );
  }
}

