import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/features/home/widgets/header.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/features/home/widgets/home_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum LibraryFilter { library, dropped, wantToPlay }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SupabaseLibraryRepository repository;
  late Future<List<LibraryGame>> libraryFuture;

  LibraryFilter selectedFilter = LibraryFilter.library;

  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    repository = SupabaseLibraryRepository(Supabase.instance.client);

    libraryFuture = repository.getLibrary();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      libraryFuture = repository.getLibrary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        searchController: searchController,
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        onLibraryChanged: refresh,
      ),

      body: FutureBuilder<List<LibraryGame>>(
        future: libraryFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hi ha jocs"));
          }

          final games = snapshot.data!;

          // ─────────────────────────────────────────────
          // COMPTADORS
          // ─────────────────────────────────────────────

          final libraryCount = games.where((game) {
            return game.userGame.status == GameStatus.playing ||
                game.userGame.status == GameStatus.completed ||
                game.userGame.status == GameStatus.paused ||
                game.userGame.status == GameStatus.dropped;
          }).length;

          final droppedCount = games.where((game) {
            return game.userGame.status == GameStatus.dropped;
          }).length;

          final wantToPlayCount = games.where((game) {
            return game.userGame.status == GameStatus.wantToPlay;
          }).length;

          // ─────────────────────────────────────────────
          // FILTRE D'ESTAT
          // ─────────────────────────────────────────────

          List<LibraryGame> filteredGames;

          switch (selectedFilter) {
            case LibraryFilter.library:
              filteredGames = games.where((game) {
                return game.userGame.status == GameStatus.playing ||
                    game.userGame.status == GameStatus.completed ||
                    game.userGame.status == GameStatus.paused ||
                    game.userGame.status == GameStatus.dropped;
              }).toList();
              break;

            case LibraryFilter.dropped:
              filteredGames = games.where((game) {
                return game.userGame.status == GameStatus.dropped;
              }).toList();
              break;

            case LibraryFilter.wantToPlay:
              filteredGames = games.where((game) {
                return game.userGame.status == GameStatus.wantToPlay;
              }).toList();
              break;
          }

          // ─────────────────────────────────────────────
          // CERCA DINS LA BIBLIOTECA
          // ─────────────────────────────────────────────

          if (searchQuery.trim().isNotEmpty) {
            final query = searchQuery.toLowerCase().trim();

            filteredGames = filteredGames.where((game) {
              return game.game.title.toLowerCase().contains(query);
            }).toList();
          }

          return Column(
            children: [
              Header(games: games),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),

                child: SizedBox(
                  width: double.infinity,

                  child: SegmentedButton<LibraryFilter>(
                    showSelectedIcon: false,

                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).colorScheme.primary;
                        }

                        return Theme.of(context).colorScheme.surfaceContainer;
                      }),

                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).colorScheme.onPrimary;
                        }

                        return Theme.of(context).colorScheme.onSurface;
                      }),

                      side: WidgetStatePropertyAll(
                        BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),

                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    segments: [
                      ButtonSegment<LibraryFilter>(
                        value: LibraryFilter.library,
                        icon: const Icon(Icons.sports_esports),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Biblioteca"),
                            const SizedBox(width: 6),
                            Text(
                              "$libraryCount",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),

                      ButtonSegment<LibraryFilter>(
                        value: LibraryFilter.dropped,
                        icon: const Icon(Icons.cancel),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Dropped"),
                            const SizedBox(width: 6),
                            Text(
                              "$droppedCount",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),

                      ButtonSegment<LibraryFilter>(
                        value: LibraryFilter.wantToPlay,
                        icon: const Icon(Icons.bookmark),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Want to Play"),
                            const SizedBox(width: 6),
                            Text(
                              "$wantToPlayCount",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],

                    selected: {selectedFilter},

                    onSelectionChanged: (selection) {
                      setState(() {
                        selectedFilter = selection.first;
                      });
                    },
                  ),
                ),
              ),

              Expanded(
                child: filteredGames.isEmpty
                    ? const Center(
                        child: Text("No hi ha jocs en aquesta categoria"),
                      )
                    : GameGrid(games: filteredGames, onLibraryChanged: refresh),
              ),
            ],
          );
        },
      ),
    );
  }
}
