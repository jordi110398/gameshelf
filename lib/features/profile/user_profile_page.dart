import 'dart:ui';

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
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/features/profile/widgets/user_tags_row.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/repositories/activity_repository.dart';

const _monthNames = [
  'Gener',
  'Febrer',
  'Març',
  'Abril',
  'Maig',
  'Juny',
  'Juliol',
  'Agost',
  'Setembre',
  'Octubre',
  'Novembre',
  'Desembre',
];

class UserProfilePage extends StatefulWidget {
  final Profile profile;

  const UserProfilePage({super.key, required this.profile});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final ProfileRepository profileRepository;
  late final SupabaseLibraryRepository libraryRepository;
  late final ActivityRepository activityRepository;
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
  Map<int, ReviewLikes> reviewLikes = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    currentProfile = widget.profile;

    final client = Supabase.instance.client;

    profileRepository = ProfileRepository(client);
    libraryRepository = SupabaseLibraryRepository(client);
    friendshipRepository = FriendshipRepository(client);
    activityRepository = ActivityRepository(client);

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

      final loadedGames = results[1] as List<LibraryGame>;

      setState(() {
        stats = results[0] as ProfileStats;
        games = loadedGames;
        isLoading = false;
      });

      // Els likes de reviews només es poden consultar per al propi perfil
      // (get_my_review_likes només retorna les activitats del cridant).
      if (isMyProfile) {
        final reviewedGameIds = loadedGames
            .where((g) => (g.userGame.review ?? '').trim().isNotEmpty)
            .map((g) => g.game.igdbId)
            .toList();

        final likes = await activityRepository.getMyReviewLikes(
          reviewedGameIds,
        );

        if (!mounted) return;

        setState(() {
          reviewLikes = likes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut carregar el perfil: ${friendlyError(e)}',
          ),
        ),
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
        SnackBar(
          content: Text(
            'No s\'ha pogut enviar la sol·licitud: ${friendlyError(e)}',
          ),
        ),
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
        SnackBar(
          content: Text(
            'No s\'ha pogut acceptar la sol·licitud: ${friendlyError(e)}',
          ),
        ),
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
        SnackBar(
          content: Text(
            'No s\'ha pogut rebutjar la sol·licitud: ${friendlyError(e)}',
          ),
        ),
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
        SnackBar(
          content: Text('No s\'ha pogut eliminar l\'amic: ${friendlyError(e)}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFriendshipActionLoading = false;
        });
      }
    }
  }

  // Botó/es d'amistat compactes, per mostrar a dalt a la dreta del
  // banner (mateixa posició que el botó d'editar del propi perfil).
  Widget? _buildFriendshipCornerAction() {
    if (isMyProfile) {
      return null;
    }

    if (isFriendshipLoading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final status = friendship?['status'];

    // ─────────────────────────────────────
    // NO HI HA RELACIÓ
    // ─────────────────────────────────────

    if (status == null) {
      return IconButton.filled(
        tooltip: 'Afegir amic',
        onPressed: isFriendshipActionLoading ? null : sendFriendRequest,
        icon: isFriendshipActionLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.person_add_outlined),
      );
    }

    // ─────────────────────────────────────
    // JA SÓN AMICS
    // ─────────────────────────────────────

    if (status == 'accepted') {
      return IconButton.filled(
        tooltip: 'Amics',
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
      );
    }

    // ─────────────────────────────────────
    // SOL·LICITUD PENDENT
    // ─────────────────────────────────────

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final requesterId = friendship?['requester_id'];

    // Jo he enviat la sol·licitud
    if (requesterId == currentUserId) {
      return IconButton.filled(
        tooltip: 'Sol·licitud enviada',
        onPressed: null,
        icon: const Icon(Icons.hourglass_empty),
      );
    }

    // L'altre usuari me l'ha enviat
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          tooltip: 'Rebutjar',
          onPressed: isFriendshipActionLoading ? null : rejectFriendRequest,
          icon: const Icon(Icons.close),
        ),

        const SizedBox(width: 8),

        IconButton.filled(
          tooltip: 'Acceptar',
          onPressed: isFriendshipActionLoading ? null : acceptFriendRequest,
          icon: isFriendshipActionLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
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

  // ─────────────────────────────────────────────
  // PREFERITS
  // ─────────────────────────────────────────────

  List<LibraryGame> get favoriteGames =>
      games.where((g) => g.userGame.favorite).toList();

  // ─────────────────────────────────────────────
  // COMPLETATS AGRUPATS PER MES (NOMÉS PERFIL PROPI)
  // ─────────────────────────────────────────────

  Map<String, List<LibraryGame>> get completedByMonth {
    final completed =
        games
            .where(
              (g) =>
                  g.userGame.status == GameStatus.completed &&
                  g.userGame.completedAt != null,
            )
            .toList()
          ..sort(
            (a, b) =>
                b.userGame.completedAt!.compareTo(a.userGame.completedAt!),
          );

    final grouped = <String, List<LibraryGame>>{};

    for (final libraryGame in completed) {
      final date = libraryGame.userGame.completedAt!;
      final key = '${_monthNames[date.month - 1]} ${date.year}';

      grouped.putIfAbsent(key, () => []).add(libraryGame);
    }

    return grouped;
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
          final likes = reviewLikes[game.igdbId];

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
                          errorBuilder: (_, _, _) {
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

                      if (likes != null && likes.likeCount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              likes.likedByMe ? Icons.star : Icons.star_border,
                              size: 15,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${likes.likeCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                  )
                else if (_buildFriendshipCornerAction() case final action?)
                  Positioned(top: 12, right: 12, child: action),
              ],
            ),
    );
  }

  // ----------------------------------------------
  // EDICIÓ PERFIL
  // ----------------------------------------------
  Future<void> _openEditProfile() async {
    // currentProfile pot venir de profiles_public (sense email) si hem
    // arribat aquí per cerca; per editar cal el perfil complet.
    final profileToEdit =
        await profileRepository.getMyProfile() ?? currentProfile;

    if (!mounted) return;

    final updatedProfile = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profile: profileToEdit),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─────────────────────────────────────
          // CAPÇALERA (degradat + avatar flotant)
          // ─────────────────────────────────────
          _buildHeader(context),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),

                // ─────────────────────────────────────
                // NICKNAME
                // ─────────────────────────────────────
                Text(
                  '@${currentProfile.nickname}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                // ─────────────────────────────────────
                // TAGS
                // ─────────────────────────────────────
                if (userTags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  UserTagsRow(games: games),
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

                const SizedBox(height: 26),

                // ─────────────────────────────────────
                // ESTADÍSTIQUES
                // ─────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
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
                      _statDivider(context),
                      Expanded(
                        child: _ProfileStat(
                          value: currentStats.completed.toString(),
                          label: 'Completats',
                        ),
                      ),
                      _statDivider(context),
                      Expanded(
                        child: _ProfileStat(
                          value: currentStats.reviews.toString(),
                          label: 'Reviews',
                        ),
                      ),
                      _statDivider(context),
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
                // PREFERITS
                // ─────────────────────────────────────
                if (favoriteGames.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _buildFavoritesShelf(),
                ],

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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildReviewsSummary(),

                  // ─────────────────────────────────────
                  // COMPLETATS AGRUPATS PER MES
                  // ─────────────────────────────────────
                  if (completedByMonth.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildCompletedByMonth(),
                  ],
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
          ),
        ],
      ),
    );
  }

  Widget _statDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  // ─────────────────────────────────────────────
  // BANNER GENERATIU (a partir dels colors dels tags)
  // ─────────────────────────────────────────────

  /// Colors base del banner: un per tag (fins a 4), o un parell de
  /// colors neutres si encara no hi ha tags. És determinista: els
  /// mateixos tags sempre generen el mateix banner.
  List<Color> _bannerColors(BuildContext context) {
    final tagColors = userTags
        .map((tag) => tagsService.styleForTag(tag).color)
        .toList();

    if (tagColors.isEmpty) {
      return [
        Theme.of(context).colorScheme.primary,
        Colors.deepOrange.shade400,
      ];
    }

    return tagColors;
  }

  static const _blobLayout = [
    (
      top: -70.0,
      left: -50.0,
      right: null,
      bottom: null,
      size: 220.0,
      opacity: 0.55,
    ),
    (
      top: -30.0,
      left: null,
      right: -60.0,
      bottom: null,
      size: 200.0,
      opacity: 0.50,
    ),
    (
      top: null,
      left: 60.0,
      right: null,
      bottom: -90.0,
      size: 190.0,
      opacity: 0.45,
    ),
    (
      top: null,
      left: null,
      right: 30.0,
      bottom: -60.0,
      size: 170.0,
      opacity: 0.40,
    ),
  ];

  Widget _buildBanner(BuildContext context) {
    final colors = _bannerColors(context);

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 46, sigmaY: 46),
        child: Stack(
          children: [
            Container(color: const Color(0xFF14101C)),
            for (var i = 0; i < _blobLayout.length; i++)
              Positioned(
                top: _blobLayout[i].top,
                left: _blobLayout[i].left,
                right: _blobLayout[i].right,
                bottom: _blobLayout[i].bottom,
                child: Container(
                  width: _blobLayout[i].size,
                  height: _blobLayout[i].size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[i % colors.length].withValues(
                      alpha: _blobLayout[i].opacity,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CAPÇALERA (banner + avatar flotant)
  // ─────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 152,
          width: double.infinity,
          child: _buildBanner(context),
        ),

        Positioned(
          top: 96,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:
                    currentProfile.avatarUrl != null &&
                        currentProfile.avatarUrl!.isNotEmpty
                    ? Image.network(
                        currentProfile.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _avatarPlaceholder(context),
                      )
                    : _avatarPlaceholder(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.person, size: 44),
    );
  }

  // ─────────────────────────────────────────────
  // PREFERITS
  // ─────────────────────────────────────────────

  Widget _buildFavoritesShelf() {
    final favorites = favoriteGames;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 6),
              const Text(
                'Preferits',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _GameCoverTile(
                  libraryGame: favorites[index],
                  width: 88,
                  onOpened: loadProfile,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // COMPLETATS AGRUPATS PER MES
  // ─────────────────────────────────────────────

  Widget _buildCompletedByMonth() {
    final grouped = completedByMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Completats',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 18),

        for (final entry in grouped.entries) ...[
          Text(
            entry.key.toUpperCase(),
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entry.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              return _GameCoverTile(
                libraryGame: entry.value[index],
                onOpened: loadProfile,
              );
            },
          ),

          const SizedBox(height: 22),
        ],
      ],
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

// ─────────────────────────────────────────────
// PORTADA DE JOC (preferits / completats per mes)
// ─────────────────────────────────────────────

class _GameCoverTile extends StatelessWidget {
  final LibraryGame libraryGame;
  final Future<void> Function() onOpened;
  final double? width;

  const _GameCoverTile({
    required this.libraryGame,
    required this.onOpened,
    this.width,
  });

  Future<void> _open(BuildContext context) async {
    final refresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => GameDetailPage(game: libraryGame.game)),
    );

    if (refresh == true) {
      await onOpened();
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = libraryGame.game;

    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: game.coverUrl != null && game.coverUrl!.isNotEmpty
            ? Image.network(
                game.coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.videogame_asset),
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.videogame_asset),
              ),
      ),
    );

    final tile = InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _open(context),
      child: cover,
    );

    return width != null ? SizedBox(width: width, child: tile) : tile;
  }
}
