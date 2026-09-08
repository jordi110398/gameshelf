import 'package:flutter/material.dart';

/// Embolcalla una coberta de joc perquè sembli un cartutx retro: una
/// carcassa de plàstic amb una petita pestanya a dalt i l'etiqueta
/// (la coberta real) encastada al mig.
class CartridgeCover extends StatelessWidget {
  final Widget cover;
  final Color shellColor;

  const CartridgeCover({
    super.key,
    required this.cover,
    this.shellColor = const Color(0xFF574B66),
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: shellColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 10, 4, 5),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(4), child: cover),

            // Pestanya superior, com el relleu d'un cartutx de veritat.
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 16,
                  height: 7,
                  decoration: BoxDecoration(
                    color: shellColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
