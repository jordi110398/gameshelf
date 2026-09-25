import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';
import 'package:gameshelf/features/notifications/notification_navigation.dart';
import 'package:gameshelf/models/notification_item.dart';
import 'package:gameshelf/repositories/notification_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _repository = NotificationRepository(Supabase.instance.client);

  List<NotificationItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repository.getNotifications();

      if (!mounted) return;

      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.notificationLoadFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _repository.markAllAsRead();

      if (!mounted) return;

      setState(() {
        _items = _items
            .map(
              (n) => n.isRead
                  ? n
                  : NotificationItem(
                      id: n.id,
                      actorId: n.actorId,
                      actorNickname: n.actorNickname,
                      actorAvatarUrl: n.actorAvatarUrl,
                      type: n.type,
                      friendshipId: n.friendshipId,
                      activityId: n.activityId,
                      gameTitle: n.gameTitle,
                      shelfId: n.shelfId,
                      shelfTitle: n.shelfTitle,
                      readAt: DateTime.now(),
                      createdAt: n.createdAt,
                    ),
            )
            .toList();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(context, e))));
    }
  }

  Future<void> _handleTap(NotificationItem item) async {
    if (!item.isRead) {
      unawaited(_repository.markAsRead(item.id));

      setState(() {
        final index = _items.indexWhere((n) => n.id == item.id);
        if (index != -1) {
          _items[index] = NotificationItem(
            id: item.id,
            actorId: item.actorId,
            actorNickname: item.actorNickname,
            actorAvatarUrl: item.actorAvatarUrl,
            type: item.type,
            friendshipId: item.friendshipId,
            activityId: item.activityId,
            gameTitle: item.gameTitle,
            shelfId: item.shelfId,
            shelfTitle: item.shelfTitle,
            readAt: DateTime.now(),
            createdAt: item.createdAt,
          );
        }
      });
    }

    if (!mounted) return;

    await openNotificationTarget(context, item);
  }

  String _messageFor(NotificationItem item) {
    switch (item.type) {
      case NotificationType.friendRequest:
        return context.l10n.listFriendRequest;
      case NotificationType.friendAccepted:
        return context.l10n.listFriendAccepted;
      case NotificationType.activityLike:
        return '${context.l10n.listActivityLikePrefix}'
            '${item.gameTitle ?? context.l10n.listActivityLikeUnknownGame}';
      case NotificationType.dropped:
        return '${context.l10n.actionDroppedPrefix}${item.gameTitle}';
      case NotificationType.review:
        return '${context.l10n.actionReviewPrefix}${item.gameTitle}';
      case NotificationType.addedToLibrary:
        return '${context.l10n.actionAddedToLibraryVerb}'
            '${item.gameTitle}'
            '${context.l10n.actionAddedToLibrarySuffix}';
      case NotificationType.shelfPublished:
        return '${context.l10n.actionShelfPublishedPrefix}'
            '"${item.shelfTitle}"';
      case NotificationType.unknown:
        // NotificationRepository ja el descarta abans que arribi aquí.
        return '';
    }
  }

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.friendRequest:
        return Icons.person_add_outlined;
      case NotificationType.friendAccepted:
        return Icons.people_alt_outlined;
      case NotificationType.activityLike:
        return Icons.star;
      case NotificationType.dropped:
        return Icons.cancel;
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

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.activityLike:
        return Colors.amber;
      case NotificationType.dropped:
        return Colors.redAccent;
      case NotificationType.review:
        return Colors.teal;
      case NotificationType.addedToLibrary:
        return Colors.green;
      case NotificationType.shelfPublished:
        return Colors.pinkAccent;
      case NotificationType.friendRequest:
      case NotificationType.friendAccepted:
      case NotificationType.unknown:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = _items.any((n) => !n.isRead);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationAppBarTitle),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(context.l10n.markAllAsRead),
            ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BookshelfBackground()),
          ResponsiveCenter(
            maxWidth: 640,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.emptyList,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _items[index];

                        return Material(
                          color: item.isRead
                              ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _handleTap(item),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        item.actorAvatarUrl != null &&
                                            item.actorAvatarUrl!.isNotEmpty
                                        ? ResizeImage(
                                            NetworkImage(item.actorAvatarUrl!),
                                            width: 80,
                                          )
                                        : null,
                                    child:
                                        item.actorAvatarUrl == null ||
                                            item.actorAvatarUrl!.isEmpty
                                        ? const Icon(Icons.person, size: 20)
                                        : null,
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(
                                              context,
                                            ).style,
                                            children: [
                                              TextSpan(
                                                text: '@${item.actorNickname} ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(text: _messageFor(item)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
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

                                  const SizedBox(width: 8),

                                  Icon(
                                    _iconFor(item.type),
                                    size: 20,
                                    color: _colorFor(item.type),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
