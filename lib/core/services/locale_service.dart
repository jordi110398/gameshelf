import 'package:flutter/widgets.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Idioma actiu de l'app -- preferència personal (com `email`), no
/// pública. Mateix patró que `ShelfSkinService`: un `ValueListenableBuilder`
/// a `GameShelfApp` reconstrueix `MaterialApp.router` amb el nou `Locale`
/// quan canvia.
class LocaleService {
  LocaleService._();

  static final LocaleService instance = LocaleService._();

  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('ca'));

  bool _listening = false;

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
      final profile = await ProfileRepository(
        Supabase.instance.client,
      ).getMyProfile();

      if (profile?.language != null) {
        locale.value = Locale(profile!.language!);
      }
    } catch (_) {
      // Es queda amb el valor per defecte si encara no hi ha sessió o
      // falla la càrrega.
    }
  }

  Future<void> setLocale(Locale value) async {
    locale.value = value;

    await ProfileRepository(
      Supabase.instance.client,
    ).updateLanguage(value.languageCode);
  }
}
