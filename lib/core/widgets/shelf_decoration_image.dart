import 'package:flutter/material.dart';
import 'package:gameshelf/models/shelf_style.dart';

/// Element decoratiu (una planta) a l'extrem d'una estanteria destacada.
/// El tipus ja ve resolt per `buildShelfLane` -- aquest widget només el
/// pinta. No pinta res quan és [ShelfDecoration.none].
///
/// `height` fixa l'alçada quan viu dins d'una fila d'alçada pròpia (com
/// les targetes del llamp); deixa'l `null` quan viu dins d'una graella
/// (`ShelfList`) que ja li dona una caixa amb `AspectRatio`, perquè
/// ompli exactament la mateixa mida que una coberta de joc.
class ShelfDecorationImage extends StatelessWidget {
  final double? height;
  final ShelfDecoration decoration;

  const ShelfDecorationImage({
    super.key,
    this.height,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final path = decoration.assetPath;

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
      cacheHeight: ((height ?? 240) * 2.5).round(),
    );
  }
}
