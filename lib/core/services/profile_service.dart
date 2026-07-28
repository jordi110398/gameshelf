import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  Future<void> createProfile({
    required String nickname,
    required String email,
  }) async {
    final user = _supabase.auth.currentUser!;

    await _supabase.from("profiles").insert({
      "id": user.id,
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
}