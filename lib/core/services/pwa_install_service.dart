import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  /// Dispara el diàleg natiu d'instal·lació si el navegador el suporta
  /// (Android/Chrome/Edge), o mostra instruccions manuals si no (per
  /// exemple iOS Safari, que no exposa cap API per fer-ho programàtic).
  Future<void> promptOrShowInstallInstructions(BuildContext context) async {
    if (isNativePromptAvailable) {
      final accepted = await promptInstall();

      if (!context.mounted || !accepted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.installAppAcceptedMessage)),
      );

      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.installAppDialogTitle),
          content: Text(context.l10n.installAppDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.actionAccept),
            ),
          ],
        );
      },
    );
  }
}
