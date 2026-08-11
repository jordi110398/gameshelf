import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:flutter/foundation.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  Future<void> createProfile({
    required String userId,
    required String nickname,
    required String email,
  }) async {
    await _supabase.from("profiles").insert({
      "id": userId,
      "nickname": nickname,
      "email": email,
    });
  }

  Future<String?> getEmailFromNickname(String nickname) async {
    final response = await _supabase.functions.invoke(
      "get-email-from-nickname",
      body: {
        "nickname": nickname,
      },
    );

    if (response.data == null) {
      return null;
    }

    return response.data["email"] as String?;
  }

  Future<Profile?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;

    debugPrint("USER ID: ${user?.id}");

    if (user == null) return null;

    final response = await _supabase
        .from("profiles")
        .select()
        .eq("id", user.id)
        .maybeSingle();

    debugPrint("PROFILE RESPONSE: $response");

    if (response == null) return null;

    return Profile.fromMap(response);
  }
}