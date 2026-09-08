import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

const _ledgeGradients = {
  ShelfWoodColor.walnut: [Color(0xFF3A322C), Color(0xFF141110)],
  ShelfWoodColor.oak: [Color(0xFF5C4023), Color(0xFF231708)],
  ShelfWoodColor.ebony: [Color(0xFF2C2C2F), Color(0xFF0C0C0D)],
  ShelfWoodColor.cherry: [Color(0xFF5C2A22), Color(0xFF230D0A)],
  ShelfWoodColor.birch: [Color(0xFFB79F74), Color(0xFF5A4B31)],
};

/// El "prestatge" físic (planxa de fusta) que suporta una filera de jocs.
/// Passa [color] explícitament quan pertany a un perfil concret; deixa'l
/// `null` per seguir en temps real la preferència de l'usuari actual
/// (`ShelfSkinService`), com `BookshelfBackground`.
class ShelfLedge extends StatelessWidget {
  final ShelfWoodColor? color;

  const ShelfLedge({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return _buildLedge(color!);
    }

    return ValueListenableBuilder<ShelfWoodColor>(
      valueListenable: ShelfSkinService.instance.woodColor,
      builder: (context, ambientColor, _) => _buildLedge(ambientColor),
    );
  }

  Widget _buildLedge(ShelfWoodColor resolvedColor) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _ledgeGradients[resolvedColor]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}
