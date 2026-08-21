import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/widgets/game_card.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/user_tags_service.dart';
import 'package:gameshelf/features/profile/edit_profile_page.dart';
import 'package:gameshelf/repositories/friendship_repository.dart';
import 'package:gameshelf/features/social/social_page.dart';
import 'package:gameshelf/core/services/auth_service.dart';

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
  late Profile currentProfile;
  late final FriendshipRepository friendshipRepository;

  Map<String, dynamic>? friendship;
  bool isFriendshipLoading = true;
  bool isFriendshipActionLoading = false;

  int? activeGameId;

  // null = Library
  GameStatus? selectedStatus;

  ProfileStats? stats;
  List<LibraryGame> games = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    currentProfile = widget.profile;

    final client = Supabase.instance.client;

    profileRepository = ProfileRepository(client);
    libraryRepository = SupabaseLibraryRepository(client);
    friendshipRepository = FriendshipRepository(client);

    loadProfile();
    loadFriendship();
  }

  // ─────────────────────────────────────────────
  // DETECTAR SI ÉS EL MEU PERFIL
  // ─────────────────────────────────────────────

  bool get isMyProfile {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      return false;
    }

    return currentUser.id == currentProfile.id;
  }

  // ─────────────────────────────────────────────
  // CARREGAR PERFIL + AMISTATS
  // ─────────────────────────────────────────────

  Future<void> loadProfile() async {
    try {
      final results = await Future.wait([
        _loadStats(),
        libraryRepository.getUserLibrary(currentProfile.id),
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

  Future<void> reloadProfile() async {
    final profile = await profileRepository.getProfileById(widget.profile.id);

    if (!mounted || profile == null) return;

    setState(() {
      currentProfile = profile;
    });
  }

  Future<void> loadFriendship() async {
    if (isMyProfile) {
      setState(() {
        isFriendshipLoading = false;
      });
      return;
    }

    try {
      final result = await friendshipRepository.getFriendship(
        currentProfile.id,
      );

      if (!mounted) return;

      setState(() {
        friendship = result;
        isFriendshipLoading = false;
      });
    } catch (e) {
      debugPrint('Error carregant amistat: $e');

      if (!mounted) return;

      setState(() {
        isFriendshipLoading = false;
      });
    }
  }

  // --------------------------------------------
  // ACCIONS AMISTATS
  // ---------------------------------------------
  Future<void> sendFriendRequest() async {
    setState(() {
      isFriendshipActionLoading = true;
    });

    try {
      await friendshipRepository.sendFriendRequest(currentProfile.id);

      await loadFriendship();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut enviar la sol·licitud: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFriendshipActionLoading = false;
        });
      }
    }
  }

  Future<void> acceptFriendRequest() async {
    final friendshipId = friendship?['id'];

    if (friendshipId == null) return;

    setState(() {
      isFriendshipActionLoading = true;
    });

    try {
      await friendshipRepository.acceptFriendRequest(friendshipId);

      await loadFriendship();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut acceptar la sol·licitud: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFriendshipActionLoading = false;
        });
      }
    }
  }

  Future<void> rejectFriendRequest() async {
    final friendshipId = friendship?['id'];

    if (friendshipId == null) return;

    setState(() {
      isFriendshipActionLoading = true;
    });

    try {
      await friendshipRepository.rejectFriendRequest(friendshipId);

      await loadFriendship();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut rebutjar la sol·licitud: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFriendshipActionLoading = false;
        });
      }
    }
  }

  Future<void> removeFriend() async {
    final friendshipId = friendship?['id'];

    if (friendshipId == null) return;

    setState(() {
      isFriendshipActionLoading = true;
    });

    try {
      await friendshipRepository.removeFriend(friendshipId);

      await loadFriendship();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut eliminar l\'amic: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFriendshipActionLoading = false;
        });
      }
    }
  }

  Widget _buildFriendshipButton() {
    if (isMyProfile) {
      return const SizedBox.shrink();
    }

    if (isFriendshipLoading) {
      return const SizedBox(
        height: 42,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final status = friendship?['status'];

    // ─────────────────────────────────────
    // NO HI HA RELACIÓ
    // ─────────────────────────────────────

    if (status == null) {
      return FilledButton.icon(
        onPressed: isFriendshipActionLoading ? null : sendFriendRequest,
        icon: isFriendshipActionLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.person_add_outlined),
        label: const Text('Afegir amic'),
      );
    }

    // ─────────────────────────────────────
    // JA SÓN AMICS
    // ─────────────────────────────────────

    if (status == 'accepted') {
      return OutlinedButton.icon(
        onPressed: isFriendshipActionLoading
            ? null
            : () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Eliminar amic?'),
                      content: Text(
                        'Vols eliminar @${currentProfile.nickname} dels teus amics?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel·lar'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  await removeFriend();
                }
              },
        icon: isFriendshipActionLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.people_alt_outlined),
        label: const Text('Amics'),
      );
    }

    // ─────────────────────────────────────
    // SOL·LICITUD PENDENT
    // ─────────────────────────────────────

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final requesterId = friendship?['requester_id'];

    // Jo he enviat la sol·licitud
    if (requesterId == currentUserId) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.hourglass_empty),
        label: const Text('Sol·licitud enviada'),
      );
    }

    // L'altre usuari me l'ha enviat
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: isFriendshipActionLoading ? null : acceptFriendRequest,
          icon: const Icon(Icons.check),
          label: const Text('Acceptar'),
        ),

        const SizedBox(width: 8),

        OutlinedButton.icon(
          onPressed: isFriendshipActionLoading ? null : rejectFriendRequest,
          icon: const Icon(Icons.close),
          label: const Text('Rebutjar'),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // ESTADÍSTIQUES
  // ─────────────────────────────────────────────

  Future<ProfileStats> _loadStats() async {
    final client = Supabase.instance.client;

    final response = await client
        .from('user_games')
        .select('status, review, hours_played')
        .eq('user_id', currentProfile.id);

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

  // REVIEWS

  List<LibraryGame> get reviewedGames {
    return games.where((libraryGame) {
      final review = libraryGame.userGame.review;

      return review != null && review.trim().isNotEmpty;
    }).toList();
  }

  Widget _buildReviewsSummary() {
    final reviews = reviewedGames.take(3).toList();

    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 32,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 10),
            Text(
              'Encara no has escrit cap review.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...reviews.map((libraryGame) {
          final game = libraryGame.game;
          final userGame = libraryGame.userGame;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
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
                          errorBuilder: (_, __, ___) {
                            return _buildReviewPlaceholder();
                          },
                        )
                      : _buildReviewPlaceholder(),
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
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),

        if (reviewedGames.length > 3)
          TextButton.icon(
            onPressed: () {
              // Més endavant:
              // obrir pantalla amb totes les reviews.
            },
            icon: const Icon(Icons.arrow_forward),
            label: Text('Veure totes les reviews (${reviewedGames.length})'),
          ),
      ],
    );
  }

  Widget _buildReviewPlaceholder() {
    return Container(
      width: 65,
      height: 95,
      color: Colors.grey.shade800,
      child: const Icon(Icons.videogame_asset, color: Colors.white54),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('@${currentProfile.nickname}'),
        // ACCIONS
        actions: [
          // MENÚ DE TRES PUNTS
          PopupMenuButton<String>(
            tooltip: "Més opcions",

            onSelected: (value) async {
              // ─────────────────────────
              // EL MEU PERFIL
              // ─────────────────────────
              if (value == "profile") {
                final profile = await ProfileRepository(
                  Supabase.instance.client,
                ).getMyProfile();

                if (profile == null || !context.mounted) {
                  return;
                }

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfilePage(profile: profile),
                  ),
                );
              }

              // ─────────────────────────
              // SOCIAL
              // ─────────────────────────
              if (value == "social") {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SocialPage()),
                );
              }

              // ─────────────────────────
              // TANCAR SESSIÓ
              // ─────────────────────────
              if (value == "logout") {
                await AuthService().signOut();
              }
            },

            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "profile",
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 12),
                    Text("El meu perfil"),
                  ],
                ),
              ),

              PopupMenuItem(
                value: "social",
                child: Row(
                  children: [
                    Icon(Icons.people_outline),
                    SizedBox(width: 12),
                    Text("Social"),
                  ],
                ),
              ),

              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text("Tancar sessió"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _buildContent(),
                if (isMyProfile)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton.filled(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar perfil',
                      onPressed: _openEditProfile,
                    ),
                  ),
              ],
            ),
    );
  }

  // ----------------------------------------------
  // EDICIÓ PERFIL
  // ----------------------------------------------
  Future<void> _openEditProfile() async {
    final updatedProfile = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profile: currentProfile),
      ),
    );

    if (updatedProfile != null && mounted) {
      setState(() {
        currentProfile = updatedProfile;
      });
    }
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
          // -------------------------------------
          // BOTÓ AMISTAT
          // -------------------------------------
          _buildFriendshipButton(),
          const SizedBox(height: 14),
          // ─────────────────────────────────────
          // AVATAR
          // ─────────────────────────────────────
          CircleAvatar(
            radius: 60,
            backgroundImage:
                currentProfile.avatarUrl != null &&
                    currentProfile.avatarUrl!.isNotEmpty
                ? NetworkImage(currentProfile.avatarUrl!)
                : null,
            child:
                currentProfile.avatarUrl == null ||
                    currentProfile.avatarUrl!.isEmpty
                ? const Icon(Icons.person, size: 60)
                : null,
          ),

          const SizedBox(height: 18),

          // ─────────────────────────────────────
          // NICKNAME
          // ─────────────────────────────────────
          Text(
            '@${currentProfile.nickname}',
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
          if (currentProfile.bio != null &&
              currentProfile.bio!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              currentProfile.bio!,
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
          // RESUM DE REVIEWS
          // NOMÉS EL MEU PERFIL
          // ─────────────────────────────────────
          if (isMyProfile) ...[
            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Les meves reviews',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 14),

            _buildReviewsSummary(),
          ],

          // ─────────────────────────────────────
          // GAMESHELF
          // NOMÉS ALTRES USUARIS
          // ─────────────────────────────────────
          if (!isMyProfile) ...[
            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${currentProfile.nickname}'s GameShelf",
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

              socialNickname: currentProfile.nickname,
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
