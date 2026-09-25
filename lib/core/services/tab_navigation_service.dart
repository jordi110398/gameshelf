import 'package:flutter/foundation.dart';

/// Permet que una pantalla fora de l'`IndexedStack` de `MainShellPage`
/// (p. ex. Notificacions, en resposta a un tap) demani canviar de
/// pestanya un cop s'hi torni enrere -- mateix patró de servei singleton
/// que `ShelfSkinService`/`LocaleService`.
class TabNavigationService {
  TabNavigationService._();

  static final instance = TabNavigationService._();

  /// `null` quan no hi ha cap petició pendent. `MainShellPage` el
  /// consumeix (torna a `null`) just després d'aplicar-lo.
  final ValueNotifier<int?> requestedTab = ValueNotifier(null);

  void requestTab(int index) => requestedTab.value = index;
}
