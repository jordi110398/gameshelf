import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/strings/game_strings.dart';
import 'package:gameshelf/core/utils/platform_visuals.dart';
import 'package:gameshelf/core/widgets/date_field.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';

class EditGamePage extends StatefulWidget {
  final Game game;
  final UserGame userGame;

  const EditGamePage({super.key, required this.game, required this.userGame});

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  late GameStatus status;
  late int rating;
  late final TextEditingController hoursController;
  late bool favorite;
  late final TextEditingController reviewController;

  late String platform;

  late DateTime startedAt;
  late DateTime completedAt;
  late DateTime droppedAt;
  late DateTime pausedAt;
  late DateTime resumedAt;

  final repository = SupabaseLibraryRepository(Supabase.instance.client);

  @override
  void initState() {
    super.initState();

    status = widget.userGame.status;

    rating = widget.userGame.rating ?? 0;

    hoursController = TextEditingController(
      text: widget.userGame.hoursPlayed.toString(),
    );

    favorite = widget.userGame.favorite;

    reviewController = TextEditingController(
      text: widget.userGame.review ?? "",
    );

    platform = platformOptions.contains(widget.userGame.platform)
        ? widget.userGame.platform!
        : platformNotSpecified;

    final now = DateTime.now();

    startedAt = widget.userGame.startedAt ?? now;
    completedAt = widget.userGame.completedAt ?? now;
    droppedAt = widget.userGame.droppedAt ?? now;
    pausedAt = widget.userGame.pausedAt ?? now;
    resumedAt = widget.userGame.resumedAt ?? now;
  }

  List<String> get platformOptions {
    return [...widget.game.platforms, platformNotSpecified];
  }

  bool get canReview {
    return status == GameStatus.completed || status == GameStatus.dropped;
  }

  bool get canFavorite {
    return status == GameStatus.completed;
  }

  // El joc estava pausat i ara se li canvia l'estat: és una represa.
  bool get isResuming {
    return widget.userGame.status == GameStatus.paused &&
        status != GameStatus.paused;
  }

  @override
  void dispose() {
    hoursController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    debugPrint("SAVING");

    final isWantToPlay = status == GameStatus.wantToPlay;

    final updatedUserGame = UserGame(
      igdbId: widget.userGame.igdbId,

      status: status,

      platform: isWantToPlay
          ? widget.userGame.platform
          : (platform == platformNotSpecified ? null : platform),

      // Només Completed o Dropped
      rating: canReview ? rating : null,

      // Want to Play no té hores
      hoursPlayed: isWantToPlay ? 0 : int.tryParse(hoursController.text) ?? 0,

      // Només Completed pot ser favorit
      favorite: canFavorite ? favorite : false,

      // Només Completed o Dropped poden tenir review
      review: canReview
          ? reviewController.text.trim().isEmpty
                ? null
                : reviewController.text.trim()
          : null,

      startedAt: isWantToPlay ? widget.userGame.startedAt : startedAt,

      completedAt: status == GameStatus.completed
          ? completedAt
          : widget.userGame.completedAt,

      droppedAt: status == GameStatus.dropped
          ? droppedAt
          : widget.userGame.droppedAt,

      pausedAt: status == GameStatus.paused
          ? pausedAt
          : widget.userGame.pausedAt,

      resumedAt: isResuming ? resumedAt : widget.userGame.resumedAt,
    );

    await repository.updateUserGame(updatedUserGame);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isWantToPlay = status == GameStatus.wantToPlay;
    final canReview =
        status == GameStatus.completed || status == GameStatus.dropped;

    return Scaffold(
      appBar: AppBar(title: Text(GameStrings.editTitle(widget.game.title))),

      body: ResponsiveCenter(
        maxWidth: 480,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ───────────────────────────
              // ESTAT
              // ───────────────────────────
              const Text(
                GameStrings.statusTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<GameStatus>(
                initialValue: status,

                decoration: const InputDecoration(border: OutlineInputBorder()),

                items: GameStatus.values.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Row(
                      children: [
                        Icon(value.icon, color: value.color, size: 20),
                        const SizedBox(width: 8),
                        Text(value.displayName),
                      ],
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    status = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ───────────────────────────
              // INFORMACIÓ DE JOC
              // Només si NO és Want to Play
              // ───────────────────────────
              if (!isWantToPlay) ...[
                // ───────────────────────────
                // PLATAFORMA
                // ───────────────────────────
                DropdownButtonFormField<String>(
                  initialValue: platform,

                  decoration: const InputDecoration(
                    labelText: GameStrings.platformLabel,
                    border: OutlineInputBorder(),
                  ),

                  items: platformOptions.map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      platform = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ───────────────────────────
                // DATES
                // ───────────────────────────
                DateField(
                  label: GameStrings.dateStartedLabel,
                  value: startedAt,
                  onChanged: (d) => setState(() => startedAt = d),
                ),

                if (status == GameStatus.completed) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: GameStrings.dateCompletedLabel,
                    value: completedAt,
                    onChanged: (d) => setState(() => completedAt = d),
                  ),
                ],

                if (status == GameStatus.dropped) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: GameStrings.dateDroppedLabel,
                    value: droppedAt,
                    onChanged: (d) => setState(() => droppedAt = d),
                  ),
                ],

                if (status == GameStatus.paused) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: GameStrings.datePausedLabel,
                    value: pausedAt,
                    onChanged: (d) => setState(() => pausedAt = d),
                  ),
                ],

                if (isResuming) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: GameStrings.dateResumedLabel,
                    value: resumedAt,
                    onChanged: (d) => setState(() => resumedAt = d),
                  ),
                ],

                const SizedBox(height: 24),

                // ───────────────────────────
                // VALORACIÓ
                // Només Completed o Dropped
                // ───────────────────────────
                if (canReview) ...[
                  const Text(
                    GameStrings.myRatingTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],

                // ───────────────────────────
                // FAVORIT
                // ───────────────────────────
                if (canFavorite) ...[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    value: favorite,

                    title: const Text(GameStrings.markAsFavorite),

                    secondary: Icon(
                      favorite ? Icons.star : Icons.star_border,
                      color: favorite ? Colors.amber : null,
                    ),

                    onChanged: (value) {
                      setState(() {
                        favorite = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                ],

                // ───────────────────────────
                // HORES
                // ───────────────────────────
                const Text(
                  GameStrings.hoursPlayedTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "0",
                    suffixText: GameStrings.hoursSuffix,
                  ),
                ),

                const SizedBox(height: 24),

                // ───────────────────────────
                // REVIEW
                // Només Completed o Dropped
                // ───────────────────────────
                if (canReview) ...[
                  const Text(
                    GameStrings.myReviewTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: reviewController,
                    minLines: 5,
                    maxLines: 8,
                    maxLength: 500,

                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: GameStrings.reviewHint,
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ],

              // ───────────────────────────
              // GUARDAR
              // ───────────────────────────
              SizedBox(
                width: double.infinity,

                child: FilledButton.icon(
                  onPressed: save,

                  icon: const Icon(Icons.save),

                  label: const Text(GameStrings.saveAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
