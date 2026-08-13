import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/game_card.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/user_tags_service.dart';

class UserProfilePage extends StatefulWidget {
  final Profile profile;

  const UserProfilePage({super.key, required this.profile});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final ProfileRepository profileRepository;
  late final SupabaseLibraryRepository libraryRepository;
  final UserTagsService tagsService = const UserTagsService();

  int? activeGameId;

  // null = Library
  GameStatus? selectedStatus;

  ProfileStats? stats;
  List<LibraryGame> games = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;

    profileRepository = ProfileRepository(client);
    libraryRepository = SupabaseLibraryRepository(client);

    loadProfile();
  }

  // ─────────────────────────────────────────────
  // DETECTAR SI ÉS EL MEU PERFIL
  // ─────────────────────────────────────────────

  bool get isMyProfile {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      return false;
    }

    return currentUser.id == widget.profile.id;
  }

  // ─────────────────────────────────────────────
  // CARREGAR PERFIL
  // ─────────────────────────────────────────────

  Future<void> loadProfile() async {
    try {
      final results = await Future.wait([
        _loadStats(),
        libraryRepository.getUserLibrary(widget.profile.id),
      ]);

      if (!mounted) return;

      setState(() {
        stats = results[0] as ProfileStats;
        games = results[1] as List<LibraryGame>;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut carregar el perfil: $e')),
      );
    }
  }

  // ─────────────────────────────────────────────
  // ESTADÍSTIQUES
  // ─────────────────────────────────────────────

  Future<ProfileStats> _loadStats() async {
    final client = Supabase.instance.client;

    final response = await client
        .from('user_games')
        .select('status, review, hours_played')
        .eq('user_id', widget.profile.id);

    final userGames = response as List;

    int completed = 0;
    int reviews = 0;
    int hours = 0;

    for (final game in userGames) {
      if (game['status'] == 'completed') {
        completed++;
      }

      final review = game['review'] as String?;

      if (review != null && review.trim().isNotEmpty) {
        reviews++;
      }

      hours += (game['hours_played'] as num?)?.toInt() ?? 0;
    }

    return ProfileStats(
      games: userGames.length,
      completed: completed,
      reviews: reviews,
      hours: hours,
    );
  }

  // ─────────────────────────────────────────────
  // TAGS
  // ─────────────────────────────────────────────

  List<String> get userTags => tagsService.tagsFromGames(games);
  Widget _buildUserTags() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: userTags.map((tag) {
        final style = tagsService.styleForTag(tag);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: style.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: style.color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: 14, color: style.color),
              const SizedBox(width: 5),
              Text(
                tag,
                style: TextStyle(
                  color: style.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  // JOCS FILTRATS
  // ─────────────────────────────────────────────

  List<LibraryGame> get filteredGames {
    if (selectedStatus == null) {
      // Library:
      // només playing, paused i completed
      return games.where((libraryGame) {
        final status = libraryGame.userGame.status;

        return status == GameStatus.playing ||
            status == GameStatus.paused ||
            status == GameStatus.completed;
      }).toList();
    }

    // Dropped o Want to play
    return games.where((libraryGame) {
      return libraryGame.userGame.status == selectedStatus;
    }).toList();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('@${widget.profile.nickname}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  // ─────────────────────────────────────────────
  // CONTINGUT
  // ─────────────────────────────────────────────

  Widget _buildContent() {
    final currentStats = stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─────────────────────────────────────
          // AVATAR
          // ─────────────────────────────────────
          CircleAvatar(
            radius: 60,
            backgroundImage:
                widget.profile.avatarUrl != null &&
                    widget.profile.avatarUrl!.isNotEmpty
                ? NetworkImage(widget.profile.avatarUrl!)
                : null,
            child:
                widget.profile.avatarUrl == null ||
                    widget.profile.avatarUrl!.isEmpty
                ? const Icon(Icons.person, size: 60)
                : null,
          ),

          const SizedBox(height: 18),

          // ─────────────────────────────────────
          // NICKNAME
          // ─────────────────────────────────────
          Text(
            '@${widget.profile.nickname}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          // ─────────────────────────────────────
          // TAGS
          // ─────────────────────────────────────
          if (userTags.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildUserTags(),
          ],

          // ─────────────────────────────────────
          // BIO
          // ─────────────────────────────────────
          if (widget.profile.bio != null &&
              widget.profile.bio!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.profile.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],

          const SizedBox(height: 30),

          // ─────────────────────────────────────
          // ESTADÍSTIQUES
          // ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ProfileStat(
                    value: currentStats.games.toString(),
                    label: 'Jocs',
                  ),
                ),
                Expanded(
                  child: _ProfileStat(
                    value: currentStats.completed.toString(),
                    label: 'Completats',
                  ),
                ),
                Expanded(
                  child: _ProfileStat(
                    value: currentStats.reviews.toString(),
                    label: 'Reviews',
                  ),
                ),
                Expanded(
                  child: _ProfileStat(
                    value: '${currentStats.hours}h',
                    label: 'Hores',
                  ),
                ),
              ],
            ),
          ),

          // ─────────────────────────────────────
          // GAMESHELF
          // NOMÉS ALTRES USUARIS
          // ─────────────────────────────────────
          if (!isMyProfile) ...[
            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "User's Gameshelf",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // FILTRES
            Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusFilters(),
            ),

            const SizedBox(height: 20),

            // JOCS
            if (filteredGames.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  _emptyGamesText(),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else
              _buildGameGrid(),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FILTRES
  // ─────────────────────────────────────────────

  Widget _buildStatusFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(label: 'Library', status: null),

          const SizedBox(width: 8),

          _buildFilterChip(label: 'Dropped', status: GameStatus.dropped),

          const SizedBox(width: 8),

          _buildFilterChip(
            label: 'Want to play',
            status: GameStatus.wantToPlay,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required GameStatus? status,
  }) {
    final selected = selectedStatus == status;

    return FilterChip(
      label: Text(label),
      selected: selected,

      onSelected: (_) {
        setState(() {
          selectedStatus = status;
          activeGameId = null;
        });
      },

      selectedColor: Colors.deepPurple,

      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,

      checkmarkColor: Colors.white,

      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.deepPurple,
        fontWeight: FontWeight.w600,
      ),

      side: BorderSide(
        color: Colors.deepPurple.withValues(alpha: selected ? 1 : 0.35),
      ),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  // ─────────────────────────────────────────────
  // TEXT QUAN NO HI HA JOCS
  // ─────────────────────────────────────────────

  String _emptyGamesText() {
    switch (selectedStatus) {
      case GameStatus.dropped:
        return 'Aquest usuari no té jocs abandonats.';

      case GameStatus.wantToPlay:
        return 'Aquest usuari no té jocs pendents.';

      case GameStatus.playing:
        return 'Aquest usuari no té jocs en curs.';

      case GameStatus.completed:
        return 'Aquest usuari no té jocs completats.';

      case GameStatus.paused:
        return 'Aquest usuari no té jocs pausats.';

      case null:
        return 'Aquest usuari encara no té jocs.';
    }
  }

  // ─────────────────────────────────────────────
  // GRAELLA DE JOCS
  // ─────────────────────────────────────────────

  Widget _buildGameGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount;

        if (width < 500) {
          crossAxisCount = 3;
        } else if (width < 800) {
          crossAxisCount = 4;
        } else if (width < 1100) {
          crossAxisCount = 5;
        } else {
          crossAxisCount = 6;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredGames.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio: 2 / 3,
          ),

          itemBuilder: (context, index) {
            final libraryGame = filteredGames[index];
            final gameId = libraryGame.game.igdbId;

            return GameCard(
              libraryGame: libraryGame,

              isActive: activeGameId == gameId,

              onActivate: () {
                setState(() {
                  activeGameId = gameId;
                });
              },

              socialNickname: widget.profile.nickname,
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// ESTADÍSTICA
// ─────────────────────────────────────────────

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
