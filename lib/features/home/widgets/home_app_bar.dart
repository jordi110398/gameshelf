import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/services/pwa_install_service.dart';
import 'package:gameshelf/core/strings/home_strings.dart';
import 'package:gameshelf/core/strings/legal_strings.dart';
import 'package:gameshelf/core/widgets/app_logo.dart';
import 'package:gameshelf/features/notifications/notifications_page.dart';
import 'package:gameshelf/features/notifications/widgets/notification_banner.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/features/search/search_page.dart';
import 'package:gameshelf/models/notification_item.dart';
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

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  final _notificationRepository = NotificationRepository(
    Supabase.instance.client,
  );
  final _installService = const PwaInstallService();

  int _unreadCount = 0;
  Timer? _pollTimer;

  // Evita mostrar el banner de notificacions que ja existien abans d'obrir
  // l'app: només avisem de les que arriben de nou durant la sessió.
  bool _initialCheckDone = false;
  String? _lastSeenNotificationId;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _checkForNotifications();

    // Comprova cada 30s si hi ha notificacions noves.
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkForNotifications(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkForNotifications() async {
    final count = await _notificationRepository.getUnreadCount();

    if (!mounted) return;

    setState(() {
      _unreadCount = count;
    });

    if (count == 0) return;

    final latest = await _notificationRepository.getNotifications(limit: 1);

    if (!mounted || latest.isEmpty) return;

    final newest = latest.first;

    if (!_initialCheckDone) {
      // Primer cop que comprovem: no és "nova", ja existia.
      _initialCheckDone = true;
      _lastSeenNotificationId = newest.id;
      return;
    }

    if (newest.id != _lastSeenNotificationId) {
      _lastSeenNotificationId = newest.id;
      _pulseStar();
      _showBanner(newest);
    }
  }

  Future<void> _pulseStar() async {
    for (var i = 0; i < 3; i++) {
      if (!mounted) return;
      await _pulseController.forward();
      if (!mounted) return;
      await _pulseController.reverse();
    }
  }

  void _showBanner(NotificationItem notification) {
    showNotificationBanner(
      context,
      notification,
      onTap: () async {
        final profile = await ProfileRepository(
          Supabase.instance.client,
        ).getProfileById(notification.actorId);

        if (profile == null || !mounted) return;

        await pushFade(context, (_) => UserProfilePage(profile: profile));

        await _checkForNotifications();
      },
    );
  }

  Future<void> _openNotifications() async {
    await pushFade(context, (_) => const NotificationsPage());

    await _checkForNotifications();
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
          tooltip: HomeStrings.addGameTooltip,
          onPressed: () async {
            await pushFade(context, (_) => const SearchPage());

            widget.onLibraryChanged();
          },
        ),
      ),

      // ACCIONS
      actions: [
        // INSTAL·LAR L'APP
        if (!_installService.isStandalone)
          Container(
            width: isMobile ? 38 : 42,
            height: isMobile ? 38 : 42,
            margin: EdgeInsets.only(right: isMobile ? 10 : 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.install_mobile_outlined),
              tooltip: LegalStrings.installAppTitle,
              onPressed: () =>
                  _installService.promptOrShowInstallInstructions(context),
            ),
          ),

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
              icon: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final t = _pulseController.value;

                  final baseColor = _unreadCount > 0
                      ? Colors.amber
                      : Theme.of(context).colorScheme.onSurface;

                  final color = Color.lerp(baseColor, Colors.deepPurple, t);

                  return Transform.scale(
                    scale: 1 + (t * 0.4),
                    child: Icon(
                      _unreadCount > 0 ? Icons.star : Icons.star_outline,
                      color: color,
                    ),
                  );
                },
              ),
              tooltip: HomeStrings.notificationsTooltip,
              onPressed: _openNotifications,
            ),
          ),
        ),
      ],
    );
  }
}
