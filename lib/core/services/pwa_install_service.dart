import 'dart:js_interop';

import 'package:flutter/foundation.dart';

@JS('gsInstallAvailable')
external bool _gsInstallAvailable();

@JS('gsPromptInstall')
external JSPromise<JSBoolean> _gsPromptInstall();

@JS('gsIsStandalone')
external bool _gsIsStandalone();

/// Pont amb l'esdeveniment natiu `beforeinstallprompt` (capturat a
/// `web/index.html`) perquè l'app pugui oferir el seu propi botó
/// "Instal·la l'app" a Android/Chrome/Edge, en lloc de dependre que
/// l'usuari trobi l'opció al menú del navegador.
class PwaInstallService {
  const PwaInstallService();

  /// L'app ja s'executa en mode instal·lat (standalone).
  bool get isStandalone {
    if (!kIsWeb) return false;
    return _gsIsStandalone();
  }

  /// El navegador ha oferit l'esdeveniment natiu d'instal·lació
  /// (Android/Chrome/Edge). A iOS Safari sempre serà `false`.
  bool get isNativePromptAvailable {
    if (!kIsWeb) return false;
    return _gsInstallAvailable();
  }

  /// Mostra el diàleg natiu d'instal·lació. Retorna `true` si l'usuari
  /// ha acceptat instal·lar l'app.
  Future<bool> promptInstall() async {
    if (!kIsWeb || !isNativePromptAvailable) return false;
    final accepted = await _gsPromptInstall().toDart;
    return accepted.toDart;
  }
}
