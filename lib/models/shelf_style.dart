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
}
