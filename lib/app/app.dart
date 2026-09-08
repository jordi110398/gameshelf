import 'package:flutter/material.dart';
import 'package:gameshelf/app/theme.dart';
import 'package:gameshelf/core/router/app_router.dart';
import 'package:gameshelf/core/services/theme_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  ThemeData _themeFor(AppThemeOption option) {
    switch (option) {
      case AppThemeOption.light:
        return AppTheme.light;
      case AppThemeOption.dark:
        return AppTheme.dark;
      case AppThemeOption.gba:
        return AppTheme.gba;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeOption>(
      valueListenable: ThemeService.instance.current,
      builder: (context, themeOption, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'GameShelf',
          theme: _themeFor(themeOption),
          routerConfig: appRouter,
        );
      },
    );
  }
}
