// Preferència pública d'estètica de l'estanteria: els altres usuaris la
// veuen en visitar el perfil. El color de la fusta, a més, determina el
// tema visual de tota l'app (vegeu `app/theme.dart`) -- no hi ha un
// selector de tema separat, per mantenir-ho tot homogeni.

enum ShelfLightStyle { neon, bulbs }

extension ShelfLightStyleX on ShelfLightStyle {
  static ShelfLightStyle fromDb(String? value) {
    switch (value) {
      case 'bulbs':
        return ShelfLightStyle.bulbs;
      case 'neon':
      default:
        return ShelfLightStyle.neon;
    }
  }

  String get databaseValue {
    switch (this) {
      case ShelfLightStyle.neon:
        return 'neon';
      case ShelfLightStyle.bulbs:
        return 'bulbs';
    }
  }
}

enum ShelfWoodColor { walnut, oak, ebony, cherry, birch }

extension ShelfWoodColorX on ShelfWoodColor {
  static ShelfWoodColor fromDb(String? value) {
    switch (value) {
      case 'oak':
        return ShelfWoodColor.oak;
      case 'ebony':
        return ShelfWoodColor.ebony;
      case 'cherry':
        return ShelfWoodColor.cherry;
      case 'birch':
        return ShelfWoodColor.birch;
      case 'walnut':
      default:
        return ShelfWoodColor.walnut;
    }
  }

  String get databaseValue {
    switch (this) {
      case ShelfWoodColor.walnut:
        return 'walnut';
      case ShelfWoodColor.oak:
        return 'oak';
      case ShelfWoodColor.ebony:
        return 'ebony';
      case ShelfWoodColor.cherry:
        return 'cherry';
      case ShelfWoodColor.birch:
        return 'birch';
    }
  }

  /// El bedoll és l'única fusta clara -- la resta són fosques. Útil per
  /// triar colors de text/icona que contrastin bé quan seuen directament
  /// sobre la fusta (`BookshelfBackground`, `WoodDrawerContainer`).
  bool get isLight => this == ShelfWoodColor.birch;
}

/// Estil de les cobertes de joc a les estanteries destacades. `cartridge`
/// és la carcassa retro (`CartridgeCover`); `plain` és una coberta neta
/// sense marc, per a qui no el vulgui. Enum obert a futures variants.
enum ShelfCoverStyle { plain, cartridge }

extension ShelfCoverStyleX on ShelfCoverStyle {
  static ShelfCoverStyle fromDb(String? value) {
    switch (value) {
      case 'plain':
        return ShelfCoverStyle.plain;
      case 'cartridge':
      default:
        return ShelfCoverStyle.cartridge;
    }
  }

  String get databaseValue {
    switch (this) {
      case ShelfCoverStyle.plain:
        return 'plain';
      case ShelfCoverStyle.cartridge:
        return 'cartridge';
    }
  }
}

/// Element decoratiu opcional a l'extrem d'una estanteria destacada
/// (preferits, estanteria fixada, targetes del llamp) -- no es mostra a
/// les graelles denses (Inici, cerca...).
enum ShelfDecoration { none, poppy, cactus, azalea }

extension ShelfDecorationX on ShelfDecoration {
  static ShelfDecoration fromDb(String? value) {
    switch (value) {
      case 'poppy':
        return ShelfDecoration.poppy;
      case 'cactus':
        return ShelfDecoration.cactus;
      case 'azalea':
        return ShelfDecoration.azalea;
      case 'none':
      default:
        return ShelfDecoration.none;
    }
  }

  String get databaseValue {
    switch (this) {
      case ShelfDecoration.none:
        return 'none';
      case ShelfDecoration.poppy:
        return 'poppy';
      case ShelfDecoration.cactus:
        return 'cactus';
      case ShelfDecoration.azalea:
        return 'azalea';
    }
  }

  /// `null` per a `none` -- vegeu `ShelfDecorationImage`.
  String? get assetPath {
    switch (this) {
      case ShelfDecoration.none:
        return null;
      case ShelfDecoration.poppy:
        return 'assets/decorations/poppy.png';
      case ShelfDecoration.cactus:
        return 'assets/decorations/cactus.png';
      case ShelfDecoration.azalea:
        return 'assets/decorations/azalea.png';
    }
  }
}

/// Conjunt de plantes triades a Configuració (0 o més -- `none` mai hi
/// és present, un conjunt buit ja ho representa).
extension ShelfDecorationSetX on Set<ShelfDecoration> {
  List<String> get databaseValues => where(
    (d) => d != ShelfDecoration.none,
  ).map((d) => d.databaseValue).toList();
}

Set<ShelfDecoration> shelfDecorationsFromDb(List<dynamic>? values) {
  if (values == null) return const {};

  return values
      .map((v) => ShelfDecorationX.fromDb(v as String?))
      .where((d) => d != ShelfDecoration.none)
      .toSet();
}

/// Element d'una lleixa destacada: o bé un joc, o bé una planta ocupant
/// el seu lloc (vegeu `buildShelfLane`).
sealed class ShelfLaneItem<T> {
  const ShelfLaneItem();
}

class ShelfLaneGame<T> extends ShelfLaneItem<T> {
  final T value;
  const ShelfLaneGame(this.value);
}

class ShelfLaneDecoration<T> extends ShelfLaneItem<T> {
  final ShelfDecoration decoration;
  const ShelfLaneDecoration(this.decoration);
}

/// Combina els jocs d'una estanteria destacada amb les plantes triades a
/// Configuració, ocupant slots buits com si cada planta fos un joc més.
///
/// Amb poques jocs (menys de [manyGamesThreshold]) només se'n mostra
/// una, al final, sense repartir-la: barrejar-ne vàries quan la lleixa
/// és quasi buida sembla un hivernacle, no una estanteria de jocs. Amb
/// moltes jocs, se'n reparteixen fins a [maxDecorationSlots] (ciclant
/// els tipus triats) intercalades entre els jocs. Sense cap planta
/// triada, o amb l'estanteria ja plena, retorna només els jocs.
List<ShelfLaneItem<T>> buildShelfLane<T>({
  required List<T> games,
  required Set<ShelfDecoration> decorations,
  int capacity = 8,
  int maxDecorationSlots = 3,
  int manyGamesThreshold = 4,
}) {
  final selected = decorations.where((d) => d != ShelfDecoration.none).toList();

  if (selected.isEmpty) {
    return [for (final g in games) ShelfLaneGame<T>(g)];
  }

  final emptySlots = capacity - games.length;

  if (emptySlots <= 0) {
    return [for (final g in games) ShelfLaneGame<T>(g)];
  }

  final manyGames = games.length >= manyGamesThreshold;

  // Mai es repeteix un mateix tipus: repetir-lo (p. ex. amb només dues
  // plantes triades i 3 slots) donava patrons estranys com A-B-A.
  final decorationCount = manyGames
      ? [
          emptySlots,
          maxDecorationSlots,
          selected.length,
        ].reduce((a, b) => a < b ? a : b)
      : 1;

  final types = selected.take(decorationCount).toList();

  if (!manyGames) {
    return [
      for (final g in games) ShelfLaneGame<T>(g),
      for (final d in types) ShelfLaneDecoration<T>(d),
    ];
  }

  // Reparteix les decoracions uniformement entre els jocs perquè sembli
  // una estanteria viscuda, no un bloc de plantes al final.
  final lane = <ShelfLaneItem<T>>[];
  final step = games.length / (types.length + 1);
  var placed = 0;

  for (var i = 0; i < games.length; i++) {
    lane.add(ShelfLaneGame<T>(games[i]));

    if (placed < types.length && (i + 1) >= (placed + 1) * step) {
      lane.add(ShelfLaneDecoration<T>(types[placed]));
      placed++;
    }
  }

  while (placed < types.length) {
    lane.add(ShelfLaneDecoration<T>(types[placed]));
    placed++;
  }

  return lane;
}
