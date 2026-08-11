import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';
import 'package:gameshelf/features/game/pages/edit_game_page.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;

  const GameDetailPage({
    super.key,
    required this.game,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  UserGame? userGame;
  bool hasChanges = false;

  late final SupabaseLibraryRepository repository;

  @override
  void initState() {
    super.initState();

    repository = SupabaseLibraryRepository(
      Supabase.instance.client,
    );

    loadUserGame();
  }

  Future<void> loadUserGame() async {
    final game = await repository.getUserGame(
      widget.game.igdbId,
    );

    if (!mounted) return;

    setState(() {
      userGame = game;
    });
  }

  Future<void> showAddToLibrarySheet() async {
    final status = await showModalBottomSheet<GameStatus>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Afegir a GameShelf",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: Icon(
                  GameStatus.playing.icon,
                  color: GameStatus.playing.color,
                ),
                title: const Text("Playing"),
                onTap: () {
                  Navigator.pop(
                    context,
                    GameStatus.playing,
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.completed.icon,
                  color: GameStatus.completed.color,
                ),
                title: const Text("Completed"),
                onTap: () {
                  Navigator.pop(
                    context,
                    GameStatus.completed,
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.wantToPlay.icon,
                  color: GameStatus.wantToPlay.color,
                ),
                title: const Text("Want to Play"),
                onTap: () {
                  Navigator.pop(
                    context,
                    GameStatus.wantToPlay,
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.paused.icon,
                  color: GameStatus.paused.color,
                ),
                title: const Text("Paused"),
                onTap: () {
                  Navigator.pop(
                    context,
                    GameStatus.paused,
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.dropped.icon,
                  color: GameStatus.dropped.color,
                ),
                title: const Text("Dropped"),
                onTap: () {
                  Navigator.pop(
                    context,
                    GameStatus.dropped,
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (status == null) return;

    await repository.addToLibrary(
      widget.game,
      status: status,
    );

    hasChanges = true;

    await loadUserGame();
  }

  Widget buildGenreChips(BuildContext context) {
    if (widget.game.genres.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.game.genres.map((genre) {
        return Chip(
          label: Text(genre),
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget buildUserGameInfo(BuildContext context) {
    final currentUserGame = userGame!;

    return Row(
      children: [
        // Rating personal
        Flexible(
          child: RatingStars(
            rating: currentUserGame.rating ?? 0,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        // Estat
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentUserGame.status.icon,
                color: currentUserGame.status.color,
                size: 22,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  currentUserGame.status.displayName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Hores
        if (currentUserGame.status != GameStatus.wantToPlay) ...[
          const SizedBox(width: 12),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule,
                size: 21,
              ),
              const SizedBox(width: 5),
              Text(
                "${currentUserGame.hoursPlayed}h",
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inLibrary = userGame != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              hasChanges,
            );
          },
        ),
        title: Text(widget.game.title),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────
            // PORTADA
            // ─────────────────────────────

            Hero(
              tag: widget.game.igdbId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.game.coverUrl != null
                    ? Image.network(
                        widget.game.coverUrl!,
                        width: 220,
                      )
                    : const SizedBox(
                        width: 220,
                        height: 330,
                        child: ColoredBox(
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────
            // TÍTOL
            // ─────────────────────────────

            Text(
              widget.game.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // ─────────────────────────────
            // ANY
            // ─────────────────────────────

            if (widget.game.releaseDate != null) ...[
              const SizedBox(height: 8),

              Text(
                widget.game.releaseDate!.year.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],

            // ─────────────────────────────
            // GÈNERES
            // ─────────────────────────────

            if (widget.game.genres.isNotEmpty) ...[
              const SizedBox(height: 16),

              buildGenreChips(context),
            ],

            // ─────────────────────────────
            // RATING IGDB
            // ─────────────────────────────

            if (widget.game.rating != null) ...[
              const SizedBox(height: 16),

              Text(
                "Valoració IGDB: "
                "${widget.game.rating!.toStringAsFixed(1)}",
              ),
            ],

            // ─────────────────────────────
            // INFORMACIÓ PERSONAL
            // ─────────────────────────────

            if (inLibrary) ...[
              const SizedBox(height: 24),

              buildUserGameInfo(context),

              // ───────────────────────────
              // REVIEW
              // ───────────────────────────

              if (userGame!.status != GameStatus.wantToPlay &&
                  userGame!.review != null &&
                  userGame!.review!.trim().isNotEmpty) ...[
                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 16),

                const Text(
                  "La meva review",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  userGame!.review!,
                ),
              ],
            ],

            // ─────────────────────────────
            // DESCRIPCIÓ
            // ─────────────────────────────

            if (widget.game.summary != null) ...[
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
                widget.game.summary!,
              ),
            ],

            const SizedBox(height: 40),

            // ─────────────────────────────
            // BOTÓ
            // ─────────────────────────────

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                icon: Icon(
                  inLibrary
                      ? Icons.edit
                      : Icons.add,
                ),

                label: Text(
                  inLibrary
                      ? "Editar"
                      : "Afegir a la biblioteca",
                ),

                onPressed: () async {
                  if (!inLibrary) {
                    await showAddToLibrarySheet();
                    return;
                  }

                  final edited =
                      await Navigator.push<bool>(
                    context,

                    MaterialPageRoute(
                      builder: (_) => EditGamePage(
                        game: widget.game,
                        userGame: userGame!,
                      ),
                    ),
                  );

                  if (edited == true) {
                    hasChanges = true;
                  }

                  await loadUserGame();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
