import 'package:flutter/material.dart';
import 'package:gameshelf/app/theme.dart';
import 'package:gameshelf/features/home/home_page.dart';

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameShelf',
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}