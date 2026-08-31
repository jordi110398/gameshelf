import 'package:flutter/material.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/gestures.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem item;

  const ActivityCard({super.key, required this.item});

  ({IconData icon, Color color}) get _typeStyle {
    switch (item.type) {
      case ActivityType.startedPlaying:
        return (icon: Icons.videogame_asset, color: Colors.blueAccent);
      case ActivityType.completed:
        return (icon: Icons.emoji_events, color: Colors.amber);
      case ActivityType.dropped:
        return (icon: Icons.cancel, color: Colors.redAccent);
      case ActivityType.review:
        return (icon: Icons.edit_note, color: Colors.teal);
      case ActivityType.addedToLibrary:
        return (icon: Icons.add_circle_outline, color: Colors.green);
    }
  }

  String get _actionText {
    switch (item.type) {
      case ActivityType.startedPlaying:
        return 'està jugant a ${item.gameTitle}';
      case ActivityType.completed:
        return 'ha completat ${item.gameTitle}';
      case ActivityType.dropped:
        return 'ha abandonat ${item.gameTitle}';
      case ActivityType.review:
        return 'ha publicat una review de ${item.gameTitle}';
      case ActivityType.addedToLibrary:
        return 'ha afegit ${item.gameTitle} a la seva biblioteca';
    }
  }

  Future<void> _openProfile(BuildContext context) async {
    final profile = await ProfileRepository(
      Supabase.instance.client,
    ).getProfileById(item.userId);

    if (profile == null || !context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfilePage(profile: profile)),
    );
  }

  Future<void> _showReview(BuildContext context) async {
    try {
      final repository = ActivityRepository(Supabase.instance.client);

      final review = await repository.getReview(
        userId: item.userId,
        gameId: item.gameId,
      );

      if (!context.mounted) return;

      if (review == null || review.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No s\'ha pogut trobar la review.')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─────────────────────────────
                    // JOC
                    // ─────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PORTADA
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 70,
                            height: 100,
                            child:
                                item.gameCoverUrl != null &&
                                    item.gameCoverUrl!.isNotEmpty
                                ? Image.network(
                                    item.gameCoverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) {
                                      return Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                        child: const Icon(
                                          Icons.videogame_asset,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    child: const Icon(
                                      Icons.videogame_asset,
                                      size: 30,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // TÍTOL + RATING
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.gameTitle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (item.rating != null) ...[
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        index < item.rating!.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 21,
                                      ),
                                    ),

                                    const SizedBox(width: 7),

                                    Text(
                                      '${item.rating!.round()}/5',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        // TANCAR
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ─────────────────────────────
                    // REVIEW
                    // ─────────────────────────────
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          '“$review”',
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─────────────────────────────
                    // AUTOR
                    // ─────────────────────────────
                    Material(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _openProfile(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 19,
                                backgroundImage:
                                    item.userAvatarUrl != null &&
                                        item.userAvatarUrl!.isNotEmpty
                                    ? NetworkImage(item.userAvatarUrl!)
                                    : null,
                                child:
                                    item.userAvatarUrl == null ||
                                        item.userAvatarUrl!.isEmpty
                                    ? const Icon(Icons.person, size: 19)
                                    : null,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@${item.userNickname}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      timeago.format(
                                        item.createdAt,
                                        locale: 'ca',
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: Colors.grey,
                              ),
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
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut carregar la review: ${friendlyError(e)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AVATAR CLICABLE
          GestureDetector(
            onTap: () => _openProfile(context),
            child: CircleAvatar(
              radius: 20,
              backgroundImage:
                  item.userAvatarUrl != null && item.userAvatarUrl!.isNotEmpty
                  ? NetworkImage(item.userAvatarUrl!)
                  : null,
              child: item.userAvatarUrl == null || item.userAvatarUrl!.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(style.icon, size: 16, color: style.color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: '@${item.userNickname} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _openProfile(context),
                            ),
                            TextSpan(text: _actionText),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  timeago.format(item.createdAt, locale: 'ca'),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),

                if (item.type == ActivityType.completed &&
                    item.rating != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '⭐ ${item.rating}/5',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],

                if (item.type == ActivityType.review &&
                    item.reviewSnippet != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '"${item.reviewSnippet}"',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => _showReview(context),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('Veure review'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
