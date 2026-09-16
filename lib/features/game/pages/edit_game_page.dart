import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/utils/hours_format.dart';
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

  String? platform;

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
      text: formatHours(widget.userGame.hoursPlayed),
    );

    favorite = widget.userGame.favorite;

    reviewController = TextEditingController(
      text: widget.userGame.review ?? "",
    );

    platform = widget.game.platforms.contains(widget.userGame.platform)
        ? widget.userGame.platform
        : null;

    final now = DateTime.now();

    startedAt = widget.userGame.startedAt ?? now;
    completedAt = widget.userGame.completedAt ?? now;
    droppedAt = widget.userGame.droppedAt ?? now;
    pausedAt = widget.userGame.pausedAt ?? now;
    resumedAt = widget.userGame.resumedAt ?? now;
  }

  List<String> platformOptions(BuildContext context) {
    return [...widget.game.platforms, platformNotSpecified(context)];
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

      platform: isWantToPlay ? widget.userGame.platform : platform,

      // Només Completed o Dropped
      rating: canReview ? rating : null,

      // Want to Play no té hores
      hoursPlayed: isWantToPlay
          ? 0
          : double.tryParse(hoursController.text.trim().replaceAll(',', '.')) ??
                0,

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
      appBar: AppBar(title: Text(context.l10n.editTitle(widget.game.title))),

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
              Text(
                context.l10n.statusTitle,
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
                        Text(value.localizedDisplayName(context)),
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
                  initialValue: platform ?? platformNotSpecified(context),

                  decoration: InputDecoration(
                    labelText: context.l10n.platformLabel,
                    border: OutlineInputBorder(),
                  ),

                  items: platformOptions(context).map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      platform = value == platformNotSpecified(context)
                          ? null
                          : value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ───────────────────────────
                // DATES
                // ───────────────────────────
                DateField(
                  label: context.l10n.dateStartedLabel,
                  value: startedAt,
                  onChanged: (d) => setState(() => startedAt = d),
                ),

                if (status == GameStatus.completed) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: context.l10n.dateCompletedLabel,
                    value: completedAt,
                    onChanged: (d) => setState(() => completedAt = d),
                  ),
                ],

                if (status == GameStatus.dropped) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: context.l10n.dateDroppedLabel,
                    value: droppedAt,
                    onChanged: (d) => setState(() => droppedAt = d),
                  ),
                ],

                if (status == GameStatus.paused) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: context.l10n.datePausedLabel,
                    value: pausedAt,
                    onChanged: (d) => setState(() => pausedAt = d),
                  ),
                ],

                if (isResuming) ...[
                  const SizedBox(height: 16),
                  DateField(
                    label: context.l10n.dateResumedLabel,
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
                  Text(
                    context.l10n.myRatingTitle,
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

                    title: Text(context.l10n.markAsFavorite),

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
                Text(
                  context.l10n.hoursPlayedTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: hoursController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "0",
                    suffixText: context.l10n.hoursSuffix,
                  ),
                ),

                const SizedBox(height: 24),

                // ───────────────────────────
                // REVIEW
                // Només Completed o Dropped
                // ───────────────────────────
                if (canReview) ...[
                  Text(
                    context.l10n.myReviewTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: reviewController,
                    minLines: 5,
                    maxLines: 8,
                    maxLength: 500,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: context.l10n.reviewHint,
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

                  label: Text(context.l10n.saveAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
