import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/core/widgets/floating_pill.dart';
import 'package:gameshelf/core/widgets/pressable_scale.dart';
import 'package:gameshelf/core/widgets/shimmer_box.dart';
import 'package:gameshelf/core/strings/home_strings.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/features/home/widgets/home_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/profile_service.dart';
import 'package:gameshelf/models/profile.dart';

enum LibraryFilter { library, dropped, wantToPlay }

enum LibrarySort { dateAdded, releaseDate, hoursPlayed, status, title }

extension on LibrarySort {
  String get label {
    switch (this) {
      case LibrarySort.dateAdded:
        return HomeStrings.sortDateAdded;
      case LibrarySort.releaseDate:
        return HomeStrings.sortReleaseDate;
      case LibrarySort.hoursPlayed:
        return HomeStrings.sortHoursPlayed;
      case LibrarySort.status:
        return HomeStrings.sortStatus;
      case LibrarySort.title:
        return HomeStrings.sortTitle;
    }
  }

  IconData get icon {
    switch (this) {
      case LibrarySort.dateAdded:
        return Icons.calendar_today_outlined;
      case LibrarySort.releaseDate:
        return Icons.event_outlined;
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
  final VoidCallback? onLogoTap;

  const HomePage({super.key, this.onLogoTap});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final SupabaseLibraryRepository repository;
  late Future<List<LibraryGame>> libraryFuture;

  LibraryFilter selectedFilter = LibraryFilter.library;
  LibrarySort selectedSort = LibrarySort.dateAdded;
  // false = ordre per defecte de cada camp (data: més recent primer, hores:
  // més hores primer, estat/títol: ordre natural). true = ordre invertit.
  bool sortAscending = false;

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
      int cmp;

      switch (selectedSort) {
        case LibrarySort.dateAdded:
          final aDate = a.userGame.createdAt;
          final bDate = b.userGame.createdAt;

          if (aDate == null && bDate == null) {
            cmp = 0;
          } else if (aDate == null) {
            cmp = 1;
          } else if (bDate == null) {
            cmp = -1;
          } else {
            cmp = bDate.compareTo(aDate);
          }
          break;

        case LibrarySort.releaseDate:
          final aDate = a.game.releaseDate;
          final bDate = b.game.releaseDate;

          if (aDate == null && bDate == null) {
            cmp = 0;
          } else if (aDate == null) {
            cmp = 1;
          } else if (bDate == null) {
            cmp = -1;
          } else {
            cmp = bDate.compareTo(aDate);
          }
          break;

        case LibrarySort.hoursPlayed:
          cmp = b.userGame.hoursPlayed.compareTo(a.userGame.hoursPlayed);
          break;

        case LibrarySort.status:
          cmp = a.userGame.status.index.compareTo(b.userGame.status.index);
          break;

        case LibrarySort.title:
          cmp = a.game.title.toLowerCase().compareTo(
            b.game.title.toLowerCase(),
          );
          break;
      }

      return sortAscending ? -cmp : cmp;
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
            "${profile?.nickname ?? HomeStrings.defaultNickname}"
            "${HomeStrings.titleSuffix}",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalGames ${HomeStrings.gamesCountSuffix}',
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
    final baseColor = selected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

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
      tooltip: HomeStrings.sortTooltip,
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          selectedSort.icon,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSortDirectionButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PressableScale(
      onTap: () {
        setState(() {
          sortAscending = !sortAscending;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSearchToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PressableScale(
      onTap: () {
        setState(() {
          isSearchExpanded = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.search,
          size: 20,
          color: colorScheme.onSurfaceVariant,
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

    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 6),
            _buildCountBadge(context, count, selected: selected),
          ],
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
          hintText: HomeStrings.searchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: HomeStrings.searchCloseTooltip,
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: FloatingPill(
        height: 58,
        borderRadius: 29,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isSearchExpanded
              ? Row(children: [_buildSearchField(context)])
              : Row(
                  children: [
                    _buildSortButton(context),
                    _buildSortDirectionButton(context),
                    const SizedBox(width: 4),
                    _buildSearchToggle(context),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShaderMask(
                        blendMode: BlendMode.dstIn,
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: [0, 0.88, 1],
                          ).createShader(rect);
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterButton(
                                context: context,
                                icon: Icons.library_books_outlined,
                                label: HomeStrings.filterLibrary,
                                count: libraryCount,
                                selected:
                                    selectedFilter == LibraryFilter.library,
                                onTap: () {
                                  setState(
                                    () =>
                                        selectedFilter = LibraryFilter.library,
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              _buildFilterButton(
                                context: context,
                                icon: Icons.cancel_outlined,
                                label: HomeStrings.filterDropped,
                                count: droppedCount,
                                selected:
                                    selectedFilter == LibraryFilter.dropped,
                                onTap: () {
                                  setState(
                                    () =>
                                        selectedFilter = LibraryFilter.dropped,
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              _buildFilterButton(
                                context: context,
                                icon: Icons.bookmark_outline,
                                label: HomeStrings.filterWishlist,
                                count: wantToPlayCount,
                                selected:
                                    selectedFilter == LibraryFilter.wantToPlay,
                                onTap: () {
                                  setState(
                                    () => selectedFilter =
                                        LibraryFilter.wantToPlay,
                                  );
                                },
                              ),
                              // Marge final perquè el desvaniment no talli
                              // el darrer botó quan sí que està a la vista.
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
        title = HomeStrings.emptyLibraryTitle;
        subtitle = HomeStrings.emptyLibrarySubtitle;
        break;

      case LibraryFilter.dropped:
        icon = Icons.cancel_outlined;
        title = HomeStrings.emptyDroppedTitle;
        subtitle = HomeStrings.emptyDroppedSubtitle;
        break;

      case LibraryFilter.wantToPlay:
        icon = Icons.bookmark_outline;
        title = HomeStrings.emptyWishlistTitle;
        subtitle = HomeStrings.emptyWishlistSubtitle;
        break;
    }

    if (searchQuery.trim().isNotEmpty) {
      icon = Icons.search_off;
      title = HomeStrings.emptySearchTitle;
      subtitle = HomeStrings.emptySearchSubtitle;
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
        onLibraryChanged: refresh,
        onLogoTap: widget.onLogoTap,
      ),

      body: FutureBuilder<List<LibraryGame>>(
        future: libraryFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LibrarySkeleton();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('${HomeStrings.loadErrorPrefix}${snapshot.error}'),
            );
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
                        : RefreshIndicator(
                            onRefresh: () async {
                              refresh();
                              await libraryFuture;
                            },
                            child: GameGrid(
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

/// Esquelet de càrrega de la biblioteca, en lloc d'un spinner genèric.
class _LibrarySkeleton extends StatelessWidget {
  const _LibrarySkeleton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BookshelfBackground()),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: 220,
                height: 26,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 8),
              ShimmerBox(
                width: 70,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 20),
              ShimmerBox(height: 58, borderRadius: BorderRadius.circular(29)),
              const SizedBox(height: 28),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (context, i) =>
                      ShimmerBox(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
