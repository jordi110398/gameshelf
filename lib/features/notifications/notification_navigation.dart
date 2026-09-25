import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/services/tab_navigation_service.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/models/notification_item.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Obre la destinació d'una notificació en tocar-la. Una estanteria
/// publicada pot no estar fixada al perfil de qui l'ha creat (i per tant
/// no s'hi veuria), així que en aquest cas porta a la pestanya de
/// Descobreix en lloc del perfil -- reutilitzat des de la safata de
/// notificacions i des del banner flotant.
Future<void> openNotificationTarget(
  BuildContext context,
  NotificationItem item,
) async {
  if (item.type == NotificationType.shelfPublished) {
    TabNavigationService.instance.requestTab(1);
    Navigator.of(context).popUntil((route) => route.isFirst);
    return;
  }

  final profile = await ProfileRepository(
    Supabase.instance.client,
  ).getProfileById(item.actorId);

  if (profile == null || !context.mounted) return;

  await pushFade(context, (_) => UserProfilePage(profile: profile));
}
