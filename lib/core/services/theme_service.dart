import 'package:flutter/foundation.dart';
import 'package:gameshelf/models/shelf_style.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Preferència de tema de l'usuari actual, compartida per tota l'app.
/// Comença en [AppThemeOption.dark] (l'únic tema que hi havia fins ara)
/// i es corregeix un cop es pot llegir el perfil, sense bloquejar
/// l'arrencada de l'app.
class ThemeService {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  final ValueNotifier<AppThemeOption> current = ValueNotifier(
    AppThemeOption.dark,
  );

  bool _listening = false;

  /// Carrega el tema desat i es manté escoltant per tornar-lo a carregar
  /// cada cop que hi hagi una sessió nova (l'usuari encara no n'hi havia
  /// cap, o ha canviat de compte).
  void init() {
    load();

    if (_listening) return;
    _listening = true;

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        load();
      }
    });
  }

  Future<void> load() async {
    try {
      final repository = ProfileRepository(Supabase.instance.client);
      final profile = await repository.getMyProfile();

      final preference = profile?.themePreference;
      if (preference != null) {
        current.value = preference;
      }
    } catch (_) {
      // Es queda amb el tema per defecte si encara no hi ha sessió o
      // falla la càrrega; no és crític prou per mostrar cap error.
    }
  }

  Future<void> setTheme(AppThemeOption value) async {
    current.value = value;

    await ProfileRepository(
      Supabase.instance.client,
    ).updateThemePreference(value);
  }
}
