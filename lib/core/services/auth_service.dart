import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ─────────────────────────────────────────────
  // REGISTRAR USUARI
  // ─────────────────────────────────────────────

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nickname,
    String? emailRedirectTo,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
      data: {
        'nickname': nickname,
      },
    );
  }

  // ─────────────────────────────────────────────
  // INICIAR SESSIÓ
  // ─────────────────────────────────────────────

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ─────────────────────────────────────────────
  // CANVIAR CONTRASENYA
  // ─────────────────────────────────────────────

  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RECUPERAR CONTRASENYA
  // ─────────────────────────────────────────────

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      // Uri.base és l'origen des d'on s'executa l'app (localhost en
      // desenvolupament, el domini real un cop desplegada), així que
      // no cal fixar-lo a mà per a cada entorn.
      redirectTo: '${Uri.base.origin}/auth/reset-password',
    );
  }

  // ─────────────────────────────────────────────
  // TANCAR SESSIÓ
  // ─────────────────────────────────────────────

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}