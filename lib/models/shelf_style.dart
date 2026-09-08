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

/// Quantes decoracions mostrar i de quin tipus, per ocupar els slots
/// buits d'una estanteria (com si cada planta fos un joc més) sense
/// repetir sempre la mateixa: comença per [primary] (la triada a
/// Configuració) i, si calen més d'una, hi intercala els altres tipus.
/// Buida si [primary] és `none` o si l'estanteria ja està plena.
List<ShelfDecoration> decorationSlotsFor({
  required ShelfDecoration primary,
  required int gameCount,
  int capacity = 8,
  int maxSlots = 3,
}) {
  if (primary == ShelfDecoration.none) return const [];

  final emptySlots = capacity - gameCount;
  if (emptySlots <= 0) return const [];

  final slotCount = emptySlots < maxSlots ? emptySlots : maxSlots;

  final otherTypes = ShelfDecoration.values
      .where((d) => d != ShelfDecoration.none && d != primary)
      .toList();

  return List.generate(slotCount, (i) {
    if (i == 0 || otherTypes.isEmpty) return primary;
    return otherTypes[(i - 1) % otherTypes.length];
  });
}
