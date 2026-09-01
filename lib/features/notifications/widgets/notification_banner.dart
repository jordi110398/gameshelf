import 'dart:async';

import 'package:flutter/material.dart';
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
        return "@${n.actorNickname} t'ha enviat una sol·licitud d'amistat";
      case NotificationType.friendAccepted:
        return '@${n.actorNickname} ha acceptat la teva sol·licitud';
      case NotificationType.activityLike:
        final game = n.gameTitle;
        return '@${n.actorNickname} ha donat una estrella'
            '${game != null ? ' a $game' : ''}';
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
