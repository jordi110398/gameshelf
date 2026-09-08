import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Element decoratiu (una planta) a l'extrem d'una estanteria destacada.
/// Passa [decoration] explícitament quan pertany a un perfil concret;
/// deixa'l `null` per seguir en temps real la preferència de l'usuari
/// actual (`ShelfSkinService`), com `BookshelfBackground`. No pinta res
/// quan la preferència resolta és [ShelfDecoration.none].
class ShelfDecorationImage extends StatelessWidget {
  final double height;
  final ShelfDecoration? decoration;

  const ShelfDecorationImage({super.key, this.height = 100, this.decoration});

  @override
  Widget build(BuildContext context) {
    if (decoration != null) {
      return _build(decoration!);
    }

    return ValueListenableBuilder<ShelfDecoration>(
      valueListenable: ShelfSkinService.instance.decoration,
      builder: (context, ambientDecoration, _) => _build(ambientDecoration),
    );
  }

  Widget _build(ShelfDecoration resolved) {
    final path = resolved.assetPath;

    if (path == null) return const SizedBox.shrink();

    return Image.asset(
      path,
      height: height,
      fit: BoxFit.contain,
      // Alineat a baix: la imatge (quadrada) no omple tota l'alçada
      // reservada, i sense això `Image` la centra, deixant el test que
      // el vas (la part de baix del PNG) no toqui la lleixa.
      alignment: Alignment.bottomCenter,
      // Els PNG originals són molt més grans (renders 1080x1080); limita
      // la memòria de descodificació al que realment es necessita.
      cacheHeight: (height * 2.5).round(),
    );
  }
}
