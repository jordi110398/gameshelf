import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/app_logo.dart';
import 'package:gameshelf/features/notifications/notifications_page.dart';
import 'package:gameshelf/features/search/search_page.dart';
import 'package:gameshelf/repositories/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onLibraryChanged;

  const HomeAppBar({super.key, required this.onLibraryChanged});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final _notificationRepository = NotificationRepository(
    Supabase.instance.client,
  );

  int _unreadCount = 0;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();

    _refreshUnreadCount();

    // Comprova cada 30s si hi ha notificacions noves.
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refreshUnreadCount(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshUnreadCount() async {
    final count = await _notificationRepository.getUnreadCount();

    if (!mounted) return;

    setState(() {
      _unreadCount = count;
    });
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );

    await _refreshUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,

      // LOGO + NOM
      leadingWidth: AppLogo.width(context),
      leading: const AppLogo(),

      // AFEGIR JOC (al mig)
      title: Container(
        width: isMobile ? 38 : 42,
        height: isMobile ? 38 : 42,
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.add, color: Colors.white),
          tooltip: "Afegir joc",
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            );

            widget.onLibraryChanged();
          },
        ),
      ),

      // ACCIONS
      actions: [
        // NOTIFICACIONS
        Container(
          width: isMobile ? 38 : 42,
          height: isMobile ? 38 : 42,
          margin: EdgeInsets.only(right: isMobile ? 14 : 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Badge(
            isLabelVisible: _unreadCount > 0,
            label: Text('$_unreadCount'),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.notifications_outlined),
              tooltip: "Notificacions",
              onPressed: _openNotifications,
            ),
          ),
        ),
      ],
    );
  }
}
