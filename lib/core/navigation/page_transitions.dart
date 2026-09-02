import 'package:flutter/material.dart';

/// Ruta amb una transició de fade + petit desplaçament cap amunt, en lloc
/// del slide horitzontal per defecte de Material, per donar una sensació
/// més suau en navegar entre pantalles.
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  FadeSlidePageRoute({required WidgetBuilder builder})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
}

/// Equivalent a `Navigator.push(context, MaterialPageRoute(builder: ...))`
/// però amb la transició de fade+slide de [FadeSlidePageRoute].
Future<T?> pushFade<T>(BuildContext context, WidgetBuilder builder) {
  return Navigator.push<T>(context, FadeSlidePageRoute<T>(builder: builder));
}
