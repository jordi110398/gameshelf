import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createProfile({
    required String nickname,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("No hi ha cap usuari autenticat.");
    }

    await _client.from('profiles').insert({
      'id': user.id,
      'nickname': nickname,
    });
  }
}