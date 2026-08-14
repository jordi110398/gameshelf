import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

    // Registra el català per a timeago
  timeago.setLocaleMessages('ca', timeago.CaMessages());

  await Supabase.initialize(
    url: 'https://qpcruteqjhnhrzwunqeh.supabase.co',
    publishableKey: 'sb_publishable_2RB3HIc0YzcNpErzonle1g_xlIFWfuA',
  );

  runApp(const GameShelfApp());
}