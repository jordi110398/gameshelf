import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/features/home/widgets/home_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/profile_service.dart';
import 'package:gameshelf/models/profile.dart';

enum LibraryFilter { library, dropped, wantToPlay }

enum LibrarySort { dateAdded, hoursPlayed, status, title }

extension on LibrarySort {
  String get label {
    switch (this) {
      case LibrarySort.dateAdded:
        return "Data d'addició";
      case LibrarySort.hoursPlayed:
        return 'Hores jugades';
      case LibrarySort.status:
        return 'Estat';
      case LibrarySort.title:
        return 'Títol (A-Z)';
    }
  }

  IconData get icon {
    switch (this) {
      case LibrarySort.dateAdded:
        return Icons.calendar_today_outlined;
      case LibrarySort.hoursPlayed:
        return Icons.schedule;
      case LibrarySort.status:
        return Icons.flag_outlined;
      case LibrarySort.title:
        return Icons.sort_by_alpha;
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final SupabaseLibraryRepository repository;
  late Future<List<LibraryGame>> libraryFuture;

  LibraryFilter selectedFilter = LibraryFilter.library;
  LibrarySort selectedSort = LibrarySort.dateAdded;

  final searchController = TextEditingController();
  String searchQuery = '';
  bool isSearchExpanded = false;
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

    // Ordenar
    filteredGames.sort((a, b) {
      switch (selectedSort) {
        case LibrarySort.dateAdded:
          final aDate = a.userGame.createdAt;
          final bDate = b.userGame.createdAt;

          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;

          return bDate.compareTo(aDate);

        case LibrarySort.hoursPlayed:
          return b.userGame.hoursPlayed.compareTo(a.userGame.hoursPlayed);

        case LibrarySort.status:
          return a.userGame.status.index.compareTo(b.userGame.status.index);

        case LibrarySort.title:
          return a.game.title.toLowerCase().compareTo(
            b.game.title.toLowerCase(),
          );
      }
    });

    return filteredGames;
  }

  // ─────────────────────────────────────────────
  // CAPÇALERA (TÍTOL)
  // ─────────────────────────────────────────────

  void _collapseSearch() {
    searchController.clear();
    setState(() {
      searchQuery = '';
      isSearchExpanded = false;
    });
  }

  Widget _buildHeader(BuildContext context, int totalGames) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${profile?.nickname ?? "GameShelf"}'s GameShelf",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalGames jocs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FILTRES
  // ─────────────────────────────────────────────

  Widget _buildCountBadge(
    BuildContext context,
    int count, {
    bool selected = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = selected ? colorScheme.onPrimary : colorScheme.onSurface;

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<LibrarySort>(
      tooltip: 'Ordenar',
      initialValue: selectedSort,
      onSelected: (value) {
        setState(() {
          selectedSort = value;
        });
      },
      itemBuilder: (context) => LibrarySort.values.map((sort) {
        final isSelected = sort == selectedSort;

        return PopupMenuItem(
          value: sort,
          child: Row(
            children: [
              Icon(sort.icon, size: 18),
              const SizedBox(width: 10),
              Text(sort.label),
              if (isSelected) ...[
                const Spacer(),
                Icon(Icons.check, size: 18, color: colorScheme.primary),
              ],
            ],
          ),
        );
      }).toList(),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.sort, size: 22, color: colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildSearchToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() {
            isSearchExpanded = true;
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.search, size: 22),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              _buildCountBadge(context, count, selected: selected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: TextField(
        controller: searchController,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Buscar a la meva biblioteca...",
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Tancar cerca',
            onPressed: _collapseSearch,
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, List<LibraryGame> games) {
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

    if (isSearchExpanded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
        child: Row(children: [_buildSearchField(context)]),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Row(
        children: [
          _buildSortButton(context),
          const SizedBox(width: 8),
          _buildSearchToggle(context),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton(
                    context: context,
                    icon: Icons.library_books_outlined,
                    label: 'Biblioteca',
                    count: libraryCount,
                    selected: selectedFilter == LibraryFilter.library,
                    onTap: () {
                      setState(() => selectedFilter = LibraryFilter.library);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                    context: context,
                    icon: Icons.cancel_outlined,
                    label: 'Dropped',
                    count: droppedCount,
                    selected: selectedFilter == LibraryFilter.dropped,
                    onTap: () {
                      setState(() => selectedFilter = LibraryFilter.dropped);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                    context: context,
                    icon: Icons.bookmark_outline,
                    label: 'Want to Play',
                    count: wantToPlayCount,
                    selected: selectedFilter == LibraryFilter.wantToPlay,
                    onTap: () {
                      setState(() => selectedFilter = LibraryFilter.wantToPlay);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
      appBar: HomeAppBar(onLibraryChanged: refresh),

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

          return Stack(
            children: [
              const Positioned.fill(child: BookshelfBackground()),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─────────────────────────────────
                  // CAPÇALERA (TÍTOL + CERCA)
                  // ─────────────────────────────────
                  _buildHeader(context, games.length),

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
                              await repository.removeGame(
                                libraryGame.game.igdbId,
                              );

                              refresh();
                            },
                          ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
