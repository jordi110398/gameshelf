import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/widgets/rating_stars.dart';
import 'package:gameshelf/features/game/pages/edit_game_page.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/game_strings.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/widgets/date_field.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  UserGame? userGame;
  bool hasChanges = false;
  ReviewLikes? reviewLikes;

  late final SupabaseLibraryRepository repository;
  late final ActivityRepository activityRepository;

  @override
  void initState() {
    super.initState();

    repository = SupabaseLibraryRepository(Supabase.instance.client);
    activityRepository = ActivityRepository(Supabase.instance.client);

    loadUserGame();
  }

  Future<void> loadUserGame() async {
    final game = await repository.getUserGame(widget.game.igdbId);

    if (!mounted) return;

    setState(() {
      userGame = game;
    });

    if (game != null && (game.review ?? '').trim().isNotEmpty) {
      final likes = await activityRepository.getMyReviewLikes([
        widget.game.igdbId,
      ]);

      if (!mounted) return;

      setState(() {
        reviewLikes = likes[widget.game.igdbId];
      });
    } else {
      reviewLikes = null;
    }
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
                  GameStrings.addToLibrarySheetTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                leading: Icon(
                  GameStatus.playing.icon,
                  color: GameStatus.playing.color,
                ),
                title: Text(GameStatus.playing.displayName),
                onTap: () {
                  Navigator.pop(context, GameStatus.playing);
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.completed.icon,
                  color: GameStatus.completed.color,
                ),
                title: Text(GameStatus.completed.displayName),
                onTap: () {
                  Navigator.pop(context, GameStatus.completed);
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.wantToPlay.icon,
                  color: GameStatus.wantToPlay.color,
                ),
                title: Text(GameStatus.wantToPlay.displayName),
                onTap: () {
                  Navigator.pop(context, GameStatus.wantToPlay);
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.paused.icon,
                  color: GameStatus.paused.color,
                ),
                title: Text(GameStatus.paused.displayName),
                onTap: () {
                  Navigator.pop(context, GameStatus.paused);
                },
              ),

              ListTile(
                leading: Icon(
                  GameStatus.dropped.icon,
                  color: GameStatus.dropped.color,
                ),
                title: Text(GameStatus.dropped.displayName),
                onTap: () {
                  Navigator.pop(context, GameStatus.dropped);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (status == null) return;

    final dates = await _promptForDates(status);

    if (dates == null) return;

    try {
      await repository.addToLibrary(
        widget.game,
        status: status,
        startedAt: dates['startedAt'],
        completedAt: dates['completedAt'],
        droppedAt: dates['droppedAt'],
        pausedAt: dates['pausedAt'],
      );

      hasChanges = true;

      await loadUserGame();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${GameStrings.addToLibraryFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // DATES SEGONS L'ESTAT TRIAT
  // ─────────────────────────────────────────────

  /// Demana les dates rellevants per a l'estat triat (cap si és "Want to
  /// Play"). Retorna `null` si l'usuari cancel·la el diàleg.
  Future<Map<String, DateTime>?> _promptForDates(GameStatus status) async {
    if (status == GameStatus.wantToPlay) return {};

    var startedAt = DateTime.now();
    var completedAt = DateTime.now();
    var droppedAt = DateTime.now();
    var pausedAt = DateTime.now();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(GameStrings.confirmDatesTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DateField(
                    label: GameStrings.dateStartedLabel,
                    value: startedAt,
                    onChanged: (d) => setDialogState(() => startedAt = d),
                  ),

                  if (status == GameStatus.completed) ...[
                    const SizedBox(height: 16),
                    DateField(
                      label: GameStrings.dateCompletedLabel,
                      value: completedAt,
                      onChanged: (d) => setDialogState(() => completedAt = d),
                    ),
                  ],

                  if (status == GameStatus.dropped) ...[
                    const SizedBox(height: 16),
                    DateField(
                      label: GameStrings.dateDroppedLabel,
                      value: droppedAt,
                      onChanged: (d) => setDialogState(() => droppedAt = d),
                    ),
                  ],

                  if (status == GameStatus.paused) ...[
                    const SizedBox(height: 16),
                    DateField(
                      label: GameStrings.datePausedLabel,
                      value: pausedAt,
                      onChanged: (d) => setDialogState(() => pausedAt = d),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(AppStrings.actionCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(GameStrings.addToLibraryAction),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return null;

    return {
      'startedAt': startedAt,
      if (status == GameStatus.completed) 'completedAt': completedAt,
      if (status == GameStatus.dropped) 'droppedAt': droppedAt,
      if (status == GameStatus.paused) 'pausedAt': pausedAt,
    };
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
          padding: const EdgeInsets.symmetric(horizontal: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget buildUserGameInfo(BuildContext context) {
    final currentUserGame = userGame!;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Valoració IGDB
        if (widget.game.rating != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                GameStrings.igdbLabel,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                widget.game.rating!.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

        // Estat
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              currentUserGame.status.icon,
              color: currentUserGame.status.color,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(currentUserGame.status.displayName),
          ],
        ),

        // Hores
        if (currentUserGame.status != GameStatus.wantToPlay)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule, size: 21),
              const SizedBox(width: 5),
              Text("${currentUserGame.hoursPlayed}h"),
            ],
          ),
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
            Navigator.pop(context, hasChanges);
          },
        ),
        title: Text(widget.game.title),
      ),

      body: ResponsiveCenter(
        maxWidth: 720,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // PORTADA BANNER
              // ─────────────────────────────
              Hero(
                tag: widget.game.igdbId,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 8,
                    child: widget.game.artworkUrl != null
                        ? Image.network(
                            widget.game.artworkUrl!,
                            fit: BoxFit.cover,
                          )
                        : widget.game.coverUrl != null
                        ? Image.network(
                            widget.game.coverUrl!,
                            fit: BoxFit.cover,
                          )
                        : const ColoredBox(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────
              // THUMBNAIL I TÍTOL
              // ─────────────────────────────
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: widget.game.coverUrl != null
                        ? Image.network(
                            widget.game.coverUrl!,
                            width: 48,
                            height: 68,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(
                            width: 48,
                            height: 68,
                            child: ColoredBox(color: Colors.grey),
                          ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.game.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (widget.game.releaseDate != null)
                          Text(
                            widget.game.releaseDate!.year.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // ─────────────────────────────
              // GÈNERES
              // ─────────────────────────────
              if (widget.game.genres.isNotEmpty) ...[
                const SizedBox(height: 16),

                buildGenreChips(context),
              ],
              // ─────────────────────────────
              // INFORMACIÓ PERSONAL
              // ─────────────────────────────
              if (inLibrary) ...[
                const SizedBox(height: 16),

                buildUserGameInfo(context),

                // ───────────────────────────
                // REVIEW
                // ───────────────────────────
                // ───────────────────────────
                // REVIEW
                // ───────────────────────────
                if (userGame!.status != GameStatus.wantToPlay) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        GameStrings.myReviewTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      RatingStars(rating: userGame!.rating ?? 0, size: 22),
                    ],
                  ),

                  if (userGame!.review != null &&
                      userGame!.review!.isNotEmpty) ...[
                    const SizedBox(height: 12),

                    Text(userGame!.review!),

                    if (reviewLikes != null && reviewLikes!.likeCount > 0) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            reviewLikes!.likedByMe
                                ? Icons.star
                                : Icons.star_border,
                            size: 17,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${reviewLikes!.likeCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
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
                  GameStrings.descriptionTitle,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(widget.game.summary!),
              ],

              const SizedBox(height: 40),

              // ─────────────────────────────
              // BOTÓ
              // ─────────────────────────────
              SizedBox(
                width: double.infinity,

                child: FilledButton.icon(
                  icon: Icon(inLibrary ? Icons.edit : Icons.add),

                  label: Text(
                    inLibrary
                        ? GameStrings.editAction
                        : GameStrings.addToLibraryAction,
                  ),

                  onPressed: () async {
                    if (!inLibrary) {
                      await showAddToLibrarySheet();
                      return;
                    }

                    final edited = await pushFade<bool>(
                      context,
                      (_) =>
                          EditGamePage(game: widget.game, userGame: userGame!),
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
      ),
    );
  }
}
