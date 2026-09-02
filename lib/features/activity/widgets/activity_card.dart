import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/activity_strings.dart';
import 'package:gameshelf/core/widgets/star_burst.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/gestures.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class ActivityCard extends StatefulWidget {
  final ActivityItem item;

  const ActivityCard({super.key, required this.item});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final _repository = ActivityRepository(Supabase.instance.client);
  final _starBurstKey = GlobalKey<StarBurstState>();

  late bool _likedByMe;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likedByMe = widget.item.likedByMe;
    _likeCount = widget.item.likeCount;
  }

  ({IconData icon, Color color}) get _typeStyle {
    switch (widget.item.type) {
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
      case ActivityType.friendshipFormed:
        return (icon: Icons.people_alt, color: Colors.deepPurpleAccent);
    }
  }

  String get _actionText {
    switch (widget.item.type) {
      case ActivityType.startedPlaying:
        return '${ActivityStrings.actionStartedPlayingPrefix}'
            '${widget.item.gameTitle}';
      case ActivityType.completed:
        return '${ActivityStrings.actionCompletedPrefix}'
            '${widget.item.gameTitle}';
      case ActivityType.dropped:
        return '${ActivityStrings.actionDroppedPrefix}'
            '${widget.item.gameTitle}';
      case ActivityType.review:
        return '${ActivityStrings.actionReviewPrefix}'
            '${widget.item.gameTitle}';
      case ActivityType.addedToLibrary:
        return '${ActivityStrings.actionAddedToLibraryVerb}'
            '${widget.item.gameTitle}'
            '${ActivityStrings.actionAddedToLibrarySuffix}';
      case ActivityType.friendshipFormed:
        // No s'utilitza: el build() construeix un RichText propi per a
        // aquest tipus (calen dos enllaços de perfil, no un).
        return '${ActivityStrings.friendshipFormedConnector}'
            '@${widget.item.friendNickname ?? ActivityStrings.friendshipFormedUnknownFriend} '
            '${ActivityStrings.friendshipFormedSuffix}';
    }
  }

  Future<void> _openProfileById(BuildContext context, String userId) async {
    final profile = await ProfileRepository(
      Supabase.instance.client,
    ).getProfileById(userId);

    if (profile == null || !context.mounted) return;

    pushFade(context, (_) => UserProfilePage(profile: profile));
  }

  Future<void> _openProfile(BuildContext context) =>
      _openProfileById(context, widget.item.userId);

  // ─────────────────────────────────────────────
  // LIKE (tap sobre l'estrella)
  // ─────────────────────────────────────────────

  void _handleLikeTap(TapDownDetails details) {
    // Convertim la posició global del tap a coordenades locals de
    // l'`StarBurst` (que embolcalla tota la card), ja que el tap ve d'un
    // widget imbricat molt més petit (la fila de l'estrella).
    final starBurstBox =
        _starBurstKey.currentContext?.findRenderObject() as RenderBox?;

    if (starBurstBox != null) {
      _starBurstKey.currentState?.burst(
        starBurstBox.globalToLocal(details.globalPosition),
      );
    }

    _toggleLike();
  }

  Future<void> _toggleLike() async {
    final wasLiked = _likedByMe;

    setState(() {
      _likedByMe = !_likedByMe;
      _likeCount += _likedByMe ? 1 : -1;
    });

    try {
      if (_likedByMe) {
        await _repository.likeActivity(widget.item.id);
      } else {
        await _repository.unlikeActivity(widget.item.id);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _likedByMe = wasLiked;
        _likeCount += wasLiked ? 1 : -1;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
  }

  Future<void> _showReview(BuildContext context) async {
    try {
      final review = await _repository.getReview(
        userId: widget.item.userId,
        gameId: widget.item.gameId!,
      );

      if (!context.mounted) return;

      if (review == null || review.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ActivityStrings.reviewNotFound)),
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
                                widget.item.gameCoverUrl != null &&
                                    widget.item.gameCoverUrl!.isNotEmpty
                                ? Image.network(
                                    widget.item.gameCoverUrl!,
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
                                widget.item.gameTitle!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (widget.item.rating != null) ...[
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        index < widget.item.rating!.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 21,
                                      ),
                                    ),

                                    const SizedBox(width: 7),

                                    Text(
                                      '${widget.item.rating!.round()}/5',
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
                                    widget.item.userAvatarUrl != null &&
                                        widget.item.userAvatarUrl!.isNotEmpty
                                    ? NetworkImage(widget.item.userAvatarUrl!)
                                    : null,
                                child:
                                    widget.item.userAvatarUrl == null ||
                                        widget.item.userAvatarUrl!.isEmpty
                                    ? const Icon(Icons.person, size: 19)
                                    : null,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@${widget.item.userNickname}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      timeago.format(
                                        widget.item.createdAt,
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
        SnackBar(
          content: Text(
            '${ActivityStrings.reviewLoadFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle;

    return StarBurst(
      key: _starBurstKey,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: woodDrawerDecoration(
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
                    widget.item.userAvatarUrl != null &&
                        widget.item.userAvatarUrl!.isNotEmpty
                    ? NetworkImage(widget.item.userAvatarUrl!)
                    : null,
                child:
                    widget.item.userAvatarUrl == null ||
                        widget.item.userAvatarUrl!.isEmpty
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
                            children:
                                widget.item.type ==
                                    ActivityType.friendshipFormed
                                ? [
                                    TextSpan(
                                      text: '@${widget.item.userNickname} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _openProfile(context),
                                    ),
                                    const TextSpan(
                                      text: ActivityStrings
                                          .friendshipFormedConnector,
                                    ),
                                    TextSpan(
                                      text:
                                          '@${widget.item.friendNickname ?? ActivityStrings.friendshipFormedUnknownFriend} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          final friendId = widget.item.friendId;
                                          if (friendId != null) {
                                            _openProfileById(context, friendId);
                                          }
                                        },
                                    ),
                                    const TextSpan(
                                      text: ActivityStrings
                                          .friendshipFormedSuffix,
                                    ),
                                  ]
                                : [
                                    TextSpan(
                                      text: '@${widget.item.userNickname} ',
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
                    timeago.format(widget.item.createdAt, locale: 'ca'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),

                  if (widget.item.type == ActivityType.completed &&
                      widget.item.rating != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '⭐ ${widget.item.rating}/5',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],

                  if (widget.item.type == ActivityType.review &&
                      widget.item.reviewSnippet != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '"${widget.item.reviewSnippet}"',
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
                      child: const Text(ActivityStrings.seeReview),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Tap sobre l'estrella per donar/treure "m'agrada".
                  GestureDetector(
                    onTapDown: _handleLikeTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _likedByMe ? Icons.star : Icons.star_border,
                            size: 18,
                            color: _likedByMe
                                ? Colors.amber
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_likeCount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _likedByMe
                                  ? Colors.amber
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
