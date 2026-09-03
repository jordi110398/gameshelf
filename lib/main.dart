import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app/app.dart';

@JS('gsReload')
external void _reloadPage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  // Flutter amaga el missatge d'error real en release i el substitueix per
  // una caixa grisa buida, cosa que fa que un error de renderització
  // localitzat sembli que un tros de la pantalla "desapareix" sense cap
  // pista. Mostrem el missatge també en producció perquè, si torna a
  // passar, es pugui saber quin és l'error real.
  ErrorWidget.builder = (details) {
    return GestureDetector(
      onTap: () => _reloadPage(),
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              details.exceptionAsString(),
              style: const TextStyle(color: Colors.redAccent, fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Toca per recarregar',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  };

  // Registra el català per a timeago
  timeago.setLocaleMessages('ca', timeago.CaMessages());

  await Supabase.initialize(
    url: 'https://qpcruteqjhnhrzwunqeh.supabase.co',
    publishableKey: 'sb_publishable_2RB3HIc0YzcNpErzonle1g_xlIFWfuA',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      detectSessionInUri: false,
    ),
  );

  runApp(const GameShelfApp());
}