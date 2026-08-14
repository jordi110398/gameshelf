import 'package:flutter/material.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/gestures.dart';

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
    final profile = await ProfileRepository(Supabase.instance.client)
        .getProfileById(item.userId);

    if (profile == null || !context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfilePage(profile: profile)),
    );
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
              backgroundImage: item.userAvatarUrl != null && item.userAvatarUrl!.isNotEmpty
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap = () => _openProfile(context),
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

                if (item.type == ActivityType.completed && item.rating != null) ...[
                  const SizedBox(height: 6),
                  Text('⭐ ${item.rating}/5', style: const TextStyle(fontSize: 13)),
                ],

                if (item.type == ActivityType.review && item.reviewSnippet != null) ...[
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
                    onPressed: () {
                      // TODO: obrir pantalla amb la review completa
                    },
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