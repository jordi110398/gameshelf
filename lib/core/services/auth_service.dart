import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  // Usuari actual
  User? get currentUser => _client.auth.currentUser;

  // Stream de canvis d'autenticació
  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  // Registrar usuari
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Iniciar sessió
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Tancar sessió
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
}