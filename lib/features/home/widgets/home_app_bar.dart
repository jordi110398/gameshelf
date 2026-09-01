import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/notifications/notifications_page.dart';
import 'package:gameshelf/features/search/search_page.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/features/social/social_page.dart';
import 'package:gameshelf/repositories/notification_repository.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
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
      leadingWidth: isMobile ? 82 : 150,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_esports,
              color: Colors.deepPurple,
              size: isMobile ? 22 : 28,
            ),
            const SizedBox(width: 6),
            Text(
              isMobile ? "GS" : "GameShelf",
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

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
          margin: EdgeInsets.only(right: isMobile ? 2 : 8),
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

        // MENÚ DE TRES PUNTS
        PopupMenuButton<String>(
          tooltip: "Més opcions",

          onSelected: (value) async {
            // ─────────────────────────
            // EL MEU PERFIL
            // ─────────────────────────
            if (value == "profile") {
              final profile = await ProfileRepository(
                Supabase.instance.client,
              ).getMyProfile();

              if (profile == null || !context.mounted) {
                return;
              }

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfilePage(profile: profile),
                ),
              );
            }

            // ─────────────────────────
            // SOCIAL
            // ─────────────────────────
            if (value == "social") {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SocialPage()),
              );
            }

            // ─────────────────────────
            // TANCAR SESSIÓ
            // ─────────────────────────
            if (value == "logout") {
              await AuthService().signOut();
            }
          },

          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "profile",
              child: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 12),
                  Text("El meu perfil"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "social",
              child: Row(
                children: [
                  Icon(Icons.people_outline),
                  SizedBox(width: 12),
                  Text("Social"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 12),
                  Text("Tancar sessió"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
