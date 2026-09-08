import 'package:flutter/material.dart';
import 'package:gameshelf/app/theme.dart';
import 'package:gameshelf/core/router/app_router.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

class GameShelfApp extends StatelessWidget {
  const GameShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ShelfWoodColor>(
      valueListenable: ShelfSkinService.instance.woodColor,
      builder: (context, wood, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'GameShelf',
          theme: AppTheme.forWood(wood),
          routerConfig: appRouter,
        );
      },
    );
  }
}
