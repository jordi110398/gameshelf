import 'package:flutter/material.dart';
import 'package:gameshelf/app/theme.dart';
import 'package:gameshelf/core/router/app_router.dart';
import 'package:gameshelf/features/auth/login/login_page.dart';

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GameShelf',
      theme: AppTheme.dark,
      

      routerConfig: appRouter,
    );
  }
}