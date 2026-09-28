import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameshelf/core/utils/hours_format.dart';
import 'package:gameshelf/models/notification_item.dart';

/// Mostra un banner flotant a la part superior de la pantalla (per sobre de
/// qualsevol pestanya activa, gràcies a l'`Overlay` arrel) per avisar d'una
/// notificació nova, sense necessitat d'obrir la safata.
void showNotificationBanner(
  BuildContext context,
  NotificationItem notification, {
  required VoidCallback onTap,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _NotificationBanner(
      notification: notification,
      onTap: onTap,
      onDismiss: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _NotificationBanner extends StatefulWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationBanner({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<_NotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  Timer? _dismissTimer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, -1.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _dismissTimer = Timer(const Duration(seconds: 5), _close);
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;

    _dismissTimer?.cancel();

    if (mounted) {
      await _controller.reverse();
    }

    widget.onDismiss();
  }

  String get _text {
    final n = widget.notification;

    switch (n.type) {
      case NotificationType.friendRequest:
        return '@${n.actorNickname} ${context.l10n.bannerFriendRequestSuffix}';
      case NotificationType.friendAccepted:
        return '@${n.actorNickname} ${context.l10n.bannerFriendAcceptedSuffix}';
      case NotificationType.activityLike:
        final game = n.gameTitle;
        return '@${n.actorNickname} ${context.l10n.bannerActivityLikeSuffix}'
            '${game != null ? '${context.l10n.bannerActivityLikeGamePrefix}$game' : ''}';
      case NotificationType.startedPlaying:
        return '@${n.actorNickname} ${context.l10n.actionStartedPlayingPrefix}'
            '${n.gameTitle}';
      case NotificationType.completed:
        return '@${n.actorNickname} ${context.l10n.actionCompletedPrefix}'
            '${n.gameTitle}';
      case NotificationType.dropped:
        return '@${n.actorNickname} ${context.l10n.actionDroppedPrefix}'
            '${n.gameTitle}';
      case NotificationType.paused:
        return '@${n.actorNickname} ${context.l10n.actionPausedPrefix}'
            '${n.gameTitle}';
      case NotificationType.rated:
        final suffix = context.l10n.actionRatedSuffix.replaceFirst(
          '{rating}',
          '${n.rating}',
        );
        return '@${n.actorNickname} ${context.l10n.actionRatedPrefix}'
            '${n.gameTitle}'
            '$suffix';
      case NotificationType.hoursLogged:
        final prefix = context.l10n.actionHoursLoggedPrefix.replaceFirst(
          '{hours}',
          formatHours(n.hoursPlayed ?? 0),
        );
        return '@${n.actorNickname} $prefix${n.gameTitle}';
      case NotificationType.review:
        return '@${n.actorNickname} ${context.l10n.actionReviewPrefix}'
            '${n.gameTitle}';
      case NotificationType.addedToLibrary:
        return '@${n.actorNickname} ${context.l10n.actionAddedToLibraryVerb}'
            '${n.gameTitle}'
            '${context.l10n.actionAddedToLibrarySuffix}';
      case NotificationType.shelfPublished:
        return '@${n.actorNickname} ${context.l10n.actionShelfPublishedPrefix}'
            '"${n.shelfTitle}"';
      case NotificationType.unknown:
        // NotificationRepository ja el descarta abans que arribi aquí.
        return '';
    }
  }

  IconData get _icon {
    switch (widget.notification.type) {
      case NotificationType.friendRequest:
        return Icons.person_add_alt_1;
      case NotificationType.friendAccepted:
        return Icons.people_alt;
      case NotificationType.activityLike:
        return Icons.star;
      case NotificationType.startedPlaying:
        return Icons.videogame_asset;
      case NotificationType.completed:
        return Icons.emoji_events;
      case NotificationType.dropped:
        return Icons.cancel;
      case NotificationType.paused:
        return Icons.pause_circle_outline;
      case NotificationType.rated:
        return Icons.star_rate;
      case NotificationType.hoursLogged:
        return Icons.schedule;
      case NotificationType.review:
        return Icons.edit_note;
      case NotificationType.addedToLibrary:
        return Icons.add_circle_outline;
      case NotificationType.shelfPublished:
        return Icons.bolt;
      case NotificationType.unknown:
        return Icons.notifications_none;
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _offset,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: const Color(0xFF241F1B),
              elevation: 10,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  _close();
                  widget.onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_icon, color: Colors.white, size: 19),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                          size: 18,
                        ),
                        onPressed: _close,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
