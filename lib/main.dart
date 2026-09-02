import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

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