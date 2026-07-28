import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qpcruteqjhnhrzwunqeh.supabase.co',
    anonKey: 'sb_publishable_2RB3HIc0YzcNpErzonle1g_xlIFWfuA',
  );

  runApp(const GameShelfApp());
}