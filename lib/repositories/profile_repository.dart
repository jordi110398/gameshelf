import 'package:gameshelf/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient client;

  ProfileRepository(this.client);

  Future<Profile?> getMyProfile() async {
    final user = client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromMap(response);
  }

  Future<Profile?> getProfileById(String id) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromMap(response);
  }

  Future<List<Profile>> searchProfiles(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final response = await client
        .from('profiles')
        .select()
        .ilike('nickname', '%$trimmedQuery%')
        .order('nickname')
        .limit(20);

    return (response as List)
        .map((item) => Profile.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createMyProfile({
    required String nickname,
    String? bio,
    String? avatarUrl,
  }) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await client.from('profiles').insert({
      'id': user.id,
      'nickname': nickname,
      'email': user.email,
      'bio': bio,
      'avatar_url': avatarUrl,
    });
  }

  Future<void> updateMyProfile(Profile profile) async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    await client
        .from('profiles')
        .update({
          'nickname': profile.nickname,
          'bio': profile.bio,
          'avatar_url': profile.avatarUrl,
        })
        .eq('id', user.id);
  }

  Future<ProfileStats> getMyStats() async {
    final user = client.auth.currentUser;

    if (user == null) {
      throw Exception('Usuari no autenticat');
    }

    final response = await client
        .from('user_games')
        .select('status, review, hours_played')
        .eq('user_id', user.id);

    final games = response as List;

    int completed = 0;
    int reviews = 0;
    int hours = 0;

    for (final game in games) {
      if (game['status'] == 'completed') {
        completed++;
      }

      final review = game['review'] as String?;

      if (review != null && review.trim().isNotEmpty) {
        reviews++;
      }

      hours += (game['hours_played'] as num?)?.toInt() ?? 0;
    }

    return ProfileStats(
      games: games.length,
      completed: completed,
      reviews: reviews,
      hours: hours,
    );
  }

  Future<List<Profile>> getProfilesByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    final profiles = <Profile>[];

    for (final id in ids) {
      final profile = await getProfileById(id);

      if (profile != null) {
        profiles.add(profile);
      }
    }

    return profiles;
  }
}

class ProfileStats {
  final int games;
  final int completed;
  final int reviews;
  final int hours;

  const ProfileStats({
    required this.games,
    required this.completed,
    required this.reviews,
    required this.hours,
  });
}
