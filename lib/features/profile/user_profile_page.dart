import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/profile_strings.dart';
import 'package:gameshelf/core/widgets/app_logo.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/core/widgets/shelf_ledge.dart';
import 'package:gameshelf/core/widgets/shelf_led_strip.dart';
import 'package:gameshelf/core/widgets/shelf_list.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
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
            '${ProfileStrings.loadFailedPrefix}${friendlyError(e)}',
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
            '${ProfileStrings.sendRequestFailedPrefix}${friendlyError(e)}',
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
            '${ProfileStrings.acceptRequestFailedPrefix}${friendlyError(e)}',
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
            '${ProfileStrings.rejectRequestFailedPrefix}${friendlyError(e)}',
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
          content: Text(
            '${ProfileStrings.removeFriendFailedPrefix}${friendlyError(e)}',
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
        tooltip: AppStrings.friendshipAdd,
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
        tooltip: AppStrings.friendshipFriends,
        onPressed: isFriendshipActionLoading
            ? null
            : () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(ProfileStrings.removeFriendTitle),
                      content: Text(
                        ProfileStrings.removeFriendBody(
                          currentProfile.nickname,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text(AppStrings.actionCancel),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text(AppStrings.actionDelete),
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
        tooltip: AppStrings.friendshipRequestSent,
        onPressed: null,
        icon: const Icon(Icons.hourglass_empty),
      );
    }

    // L'altre usuari me l'ha enviat
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          tooltip: AppStrings.actionReject,
          onPressed: isFriendshipActionLoading ? null : rejectFriendRequest,
          icon: const Icon(Icons.close),
        ),

        const SizedBox(width: 8),

        IconButton.filled(
          tooltip: AppStrings.actionAccept,
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
      return WoodDrawerContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              ProfileStrings.noReviewsYet,
              style: TextStyle(color: Colors.grey.shade300),
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

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WoodDrawerContainer(
              padding: const EdgeInsets.all(12),
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
                                likes.likedByMe
                                    ? Icons.star
                                    : Icons.star_border,
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
            label: Text(ProfileStrings.seeAllReviews(reviewedGames.length)),
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
    return Scaffold(
      appBar: AppBar(
        leadingWidth: isMyProfile ? AppLogo.width(context) : null,
        leading: isMyProfile ? const AppLogo() : null,
        title: Text('@${currentProfile.nickname}'),
        // ACCIONS
        actions: [
          if (isMyProfile)
            IconButton(
              tooltip: ProfileStrings.logoutTooltip,
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService().signOut();
              },
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
                      tooltip: ProfileStrings.editProfileTooltip,
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

    final updatedProfile = await pushFade<Profile>(
      context,
      (_) => EditProfilePage(profile: profileToEdit),
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
                WoodDrawerContainer(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ProfileStat(
                          value: currentStats.games.toString(),
                          label: ProfileStrings.statGames,
                        ),
                      ),
                      _statDivider(context),
                      Expanded(
                        child: _ProfileStat(
                          value: currentStats.completed.toString(),
                          label: ProfileStrings.statCompleted,
                        ),
                      ),
                      _statDivider(context),
                      Expanded(
                        child: _ProfileStat(
                          value: currentStats.reviews.toString(),
                          label: ProfileStrings.statReviews,
                        ),
                      ),
                      _statDivider(context),
                      Expanded(
                        child: _ProfileStat(
                          value: '${currentStats.hours}h',
                          label: ProfileStrings.statHours,
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
                      ProfileStrings.myReviewsTitle,
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
                      ProfileStrings.gameshelfOf(currentProfile.nickname),
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

  Widget _buildBanner(BuildContext context) {
    final colors = _bannerColors(context);

    return CustomPaint(
      size: Size.infinite,
      painter: _DitherBannerPainter(colors),
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
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.55),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          const Positioned.fill(child: BookshelfBackground()),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    const Text(
                      ProfileStrings.favoritesTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return ShelfLedStrip(width: constraints.maxWidth);
                  },
                ),

                const SizedBox(height: 4),

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

                const SizedBox(height: 10),
                const ShelfLedge(),
              ],
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
            ProfileStrings.completedTitle,
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

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                const Positioned.fill(child: BookshelfBackground()),
                ShelfList<LibraryGame>(
                  items: entry.value,
                  scrollable: false,
                  minItemWidth: 90,
                  minColumns: 4,
                  itemAspectRatio: 3 / 4,
                  padding: const EdgeInsets.all(14),
                  itemBuilder: (context, libraryGame) => _GameCoverTile(
                    libraryGame: libraryGame,
                    onOpened: loadProfile,
                  ),
                ),
              ],
            ),
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
          _buildFilterChip(label: ProfileStrings.filterLibrary, status: null),

          const SizedBox(width: 8),

          _buildFilterChip(
            label: ProfileStrings.filterDropped,
            status: GameStatus.dropped,
          ),

          const SizedBox(width: 8),

          _buildFilterChip(
            label: ProfileStrings.filterWantToPlay,
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
        return ProfileStrings.emptyGamesDropped;

      case GameStatus.wantToPlay:
        return ProfileStrings.emptyGamesWantToPlay;

      case GameStatus.playing:
        return ProfileStrings.emptyGamesPlaying;

      case GameStatus.completed:
        return ProfileStrings.emptyGamesCompleted;

      case GameStatus.paused:
        return ProfileStrings.emptyGamesPaused;

      case null:
        return ProfileStrings.emptyGamesAny;
    }
  }

  // ─────────────────────────────────────────────
  // GRAELLA DE JOCS
  // ─────────────────────────────────────────────

  Widget _buildGameGrid() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          const Positioned.fill(child: BookshelfBackground()),
          ShelfList<LibraryGame>(
            items: filteredGames,
            scrollable: false,
            minItemWidth: 100,
            minColumns: 3,
            itemAspectRatio: 2 / 3,
            padding: const EdgeInsets.all(14),
            itemBuilder: (context, libraryGame) {
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
          ),
        ],
      ),
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
    final refresh = await pushFade<bool>(
      context,
      (_) => GameDetailPage(game: libraryGame.game),
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

// ─────────────────────────────────────────────
// BANNER AMB DITHERING (ESTIL GBA)
// ─────────────────────────────────────────────

/// Matriu Bayer 4x4 estàndard, per decidir píxel a píxel quin dels dos
/// colors "reals" toca dibuixar en una transició -- la tècnica autèntica
/// de dithering ordenat que feien servir les pantalles de GBA en lloc
/// d'un degradat suau (que necessitaria més colors dels que la pantalla
/// podia mostrar).
const _bayer4x4 = [
  [0, 8, 2, 10],
  [12, 4, 14, 6],
  [3, 11, 1, 9],
  [15, 7, 13, 5],
];

class _DitherBannerPainter extends CustomPainter {
  final List<Color> colors;

  static const double _pixelSize = 6;
  static const Color _shadowColor = Color(0xFF14101C);

  const _DitherBannerPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final palette = colors.isEmpty
        ? const [Color(0xFF8B5CF6), Color(0xFF6D28D9)]
        : colors;

    final cols = (size.width / _pixelSize).ceil();
    final rows = (size.height / _pixelSize).ceil();

    final paint = Paint()..style = PaintingStyle.fill;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final threshold = _bayer4x4[row % 4][col % 4] / 16.0;

        // Transició horitzontal entre els colors de la paleta.
        final hProgress = palette.length == 1
            ? 0.0
            : (col / cols) * (palette.length - 1);
        final colorA = palette[hProgress.floor().clamp(0, palette.length - 1)];
        final colorB =
            palette[(hProgress.floor() + 1).clamp(0, palette.length - 1)];
        final hLocal = hProgress - hProgress.floor();

        var pixelColor = hLocal > threshold ? colorB : colorA;

        // Ombreig vertical cap avall (dithered, no degradat suau).
        final vProgress = ((row / rows) - 0.3) / 0.7;
        if (vProgress > 0 && vProgress.clamp(0.0, 1.0) > threshold) {
          pixelColor = _shadowColor;
        }

        paint.color = pixelColor;

        canvas.drawRect(
          Rect.fromLTWH(
            col * _pixelSize,
            row * _pixelSize,
            _pixelSize,
            _pixelSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DitherBannerPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
