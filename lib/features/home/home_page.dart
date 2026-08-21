import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/features/home/widgets/home_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/profile_service.dart';
import 'package:gameshelf/models/profile.dart';

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
  Profile? profile;
  final profileService = ProfileService();

  Future<void> loadProfile() async {
    final result = await profileService.getCurrentProfile();

    debugPrint(result?.nickname);

    if (!mounted) return;

    setState(() {
      profile = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();

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

  // ─────────────────────────────────────────────
  // FILTRAR JOCS
  // ─────────────────────────────────────────────

  List<LibraryGame> _filterGames(List<LibraryGame> games) {
    List<LibraryGame> filteredGames;

    switch (selectedFilter) {
      case LibraryFilter.library:
        // Biblioteca = Playing + Paused + Completed + Dropped
        filteredGames = games.where((game) {
          return game.userGame.status == GameStatus.playing ||
              game.userGame.status == GameStatus.paused ||
              game.userGame.status == GameStatus.completed ||
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

    // Cerca
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();

      filteredGames = filteredGames.where((game) {
        return game.game.title.toLowerCase().contains(query);
      }).toList();
    }

    return filteredGames;
  }

  // ─────────────────────────────────────────────
  // TÍTOL
  // ─────────────────────────────────────────────

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
      child: Column(
        children: [
          Text(
            "${profile?.nickname ?? "GameShelf"}'s GameShelf",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FILTRES
  // ─────────────────────────────────────────────

  Widget _buildCountBadge(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, List<LibraryGame> games) {
    final colorScheme = Theme.of(context).colorScheme;

    // ─────────────────────────────────────────────
    // COMPTADORS
    // ─────────────────────────────────────────────

    final libraryCount = games.where((game) {
      return game.userGame.status == GameStatus.playing ||
          game.userGame.status == GameStatus.paused ||
          game.userGame.status == GameStatus.completed ||
          game.userGame.status == GameStatus.dropped;
    }).length;

    final droppedCount = games.where((game) {
      return game.userGame.status == GameStatus.dropped;
    }).length;

    final wantToPlayCount = games.where((game) {
      return game.userGame.status == GameStatus.wantToPlay;
    }).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<LibraryFilter>(
          showSelectedIcon: false,

          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }

              return colorScheme.surfaceContainer;
            }),

            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimary;
              }

              return colorScheme.onSurface;
            }),

            side: WidgetStatePropertyAll(
              BorderSide(color: colorScheme.outlineVariant),
            ),

            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),

            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            ),
          ),

          segments: [
            ButtonSegment<LibraryFilter>(
              value: LibraryFilter.library,
              icon: const Icon(Icons.library_books_outlined, size: 19),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text('Biblioteca', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  _buildCountBadge(context, libraryCount),
                ],
              ),
            ),

            ButtonSegment<LibraryFilter>(
              value: LibraryFilter.dropped,
              icon: const Icon(Icons.cancel_outlined, size: 19),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text('Dropped', overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  _buildCountBadge(context, droppedCount),
                ],
              ),
            ),

            ButtonSegment<LibraryFilter>(
              value: LibraryFilter.wantToPlay,
              icon: const Icon(Icons.bookmark_outline, size: 19),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text(
                      'Want to Play',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildCountBadge(context, wantToPlayCount),
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
    );
  }

  // ─────────────────────────────────────────────
  // ESTAT BUIT
  // ─────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String title;
    String subtitle;
    IconData icon;

    switch (selectedFilter) {
      case LibraryFilter.library:
        icon = Icons.videogame_asset_outlined;
        title = 'La teva biblioteca està buida';
        subtitle = 'Afegeix jocs i comença a construir la teva col·lecció.';
        break;

      case LibraryFilter.dropped:
        icon = Icons.cancel_outlined;
        title = 'Cap joc abandonat';
        subtitle = 'Aquí apareixeran els jocs que decideixis deixar.';
        break;

      case LibraryFilter.wantToPlay:
        icon = Icons.bookmark_outline;
        title = 'No tens jocs pendents';
        subtitle = 'Afegeix jocs que vulguis jugar més endavant.';
        break;
    }

    if (searchQuery.trim().isNotEmpty) {
      icon = Icons.search_off;
      title = 'No s\'han trobat jocs';
      subtitle = 'Prova amb un altre terme de cerca.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return _buildEmptyState(context);
          }

          final games = snapshot.data!;

          final filteredGames = _filterGames(games);

          return Column(
            children: [
              // ─────────────────────────────────
              // TÍTOL
              // ─────────────────────────────────
              _buildTitle(context),

              // ─────────────────────────────────
              // FILTRES
              // ─────────────────────────────────
              _buildFilters(context, games),

              // ─────────────────────────────────
              // GRID
              // ─────────────────────────────────
              Expanded(
                child: filteredGames.isEmpty
                    ? _buildEmptyState(context)
                    : GameGrid(
                        games: filteredGames,
                        onLibraryChanged: refresh,
                        onGameDeleted: (libraryGame) async {
                          await repository.removeGame(libraryGame.game.igdbId);

                          refresh();
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
