import 'package:flutter/material.dart';
import 'package:gameshelf/core/utils/platform_visuals.dart';

/// Color per defecte de la carcassa quan no hi ha plataforma coneguda.
const kCartridgeDefaultColor = Color(0xFF574B66);

/// Color de la carcassa dels cartutxos preferits, per sobre del color de
/// plataforma.
const kCartridgeFavoriteColor = Color(0xFFD4AF37);

/// Color de carcassa segons plataforma (o daurat si és preferit). `null`
/// quan no hi ha ni `platform` ni `favorite` -- fa servir el color per
/// defecte.
Color cartridgeShellColorFor({String? platform, bool favorite = false}) {
  if (favorite) return kCartridgeFavoriteColor;
  return platformVisualFor(platform)?.color ?? kCartridgeDefaultColor;
}

/// Embolcalla una coberta de joc perquè sembli un cartutx retro: una
/// carcassa de plàstic amb una petita pestanya a dalt i l'etiqueta
/// (la coberta real) encastada al mig.
class CartridgeCover extends StatelessWidget {
  final Widget cover;
  final Color shellColor;

  /// La pestanya sobresurt per sobre del propi widget (`Clip.none`):
  /// en graelles denses (p. ex. Inici), amaga-la perquè no es talli
  /// contra la fila anterior.
  final bool showNotch;

  const CartridgeCover({
    super.key,
    required this.cover,
    this.shellColor = kCartridgeDefaultColor,
    this.showNotch = true,
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
        // Sense pestanya no cal l'espai reservat a dalt per allotjar-la.
        padding: EdgeInsets.fromLTRB(4, showNotch ? 10 : 5, 4, 5),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(4), child: cover),

            // Pestanya superior, com el relleu d'un cartutx de veritat.
            if (showNotch)
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
