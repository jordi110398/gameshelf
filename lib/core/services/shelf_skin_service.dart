import 'package:flutter/foundation.dart';
import 'package:gameshelf/models/shelf_style.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Estètica de l'estanteria (llums + fusta + decoració) de l'usuari
/// actual, per aplicar-la a tota la decoració "genèrica" de l'app
/// (Inici, Social, el propi perfil) sense haver de recarregar cada
/// pantalla a mà -- `BookshelfBackground`/`ShelfLightFixture`/
/// `WoodDrawerContainer` hi escolten quan no se'ls passa un color/estil
/// explícit.
///
/// Quan es mostra l'estanteria d'UNA ALTRA PERSONA (el seu perfil, una
/// targeta del llamp), es continua passant explícitament
/// `profile.shelfWoodColor`/`shelfLightStyle`/`shelfDecoration` d'aquell
/// perfil -- això només és per a la pròpia experiència de l'usuari que
/// mira l'app.
class ShelfSkinService {
  ShelfSkinService._();

  static final ShelfSkinService instance = ShelfSkinService._();

  final ValueNotifier<ShelfLightStyle> lightStyle = ValueNotifier(
    ShelfLightStyle.neon,
  );
  final ValueNotifier<ShelfWoodColor> woodColor = ValueNotifier(
    ShelfWoodColor.walnut,
  );
  final ValueNotifier<ShelfDecoration> decoration = ValueNotifier(
    ShelfDecoration.none,
  );

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

      if (profile != null) {
        lightStyle.value = profile.shelfLightStyle;
        woodColor.value = profile.shelfWoodColor;
        decoration.value = profile.shelfDecoration;
      }
    } catch (_) {
      // Es queda amb els valors per defecte si encara no hi ha sessió o
      // falla la càrrega.
    }
  }

  Future<void> setLightStyle(ShelfLightStyle value) async {
    lightStyle.value = value;

    await ProfileRepository(
      Supabase.instance.client,
    ).updateShelfSkin(lightStyle: value);
  }

  Future<void> setWoodColor(ShelfWoodColor value) async {
    woodColor.value = value;

    await ProfileRepository(
      Supabase.instance.client,
    ).updateShelfSkin(woodColor: value);
  }

  Future<void> setDecoration(ShelfDecoration value) async {
    decoration.value = value;

    await ProfileRepository(
      Supabase.instance.client,
    ).updateShelfSkin(decoration: value);
  }
}
