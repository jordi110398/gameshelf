// Preferències personalitzables del perfil: aparença de l'estanteria
// (pública -- els altres usuaris la veuen en visitar el perfil) i tema de
// l'app (personal -- només afecta com tu veus l'aplicació).

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

enum AppThemeOption { light, dark, gba }

extension AppThemeOptionX on AppThemeOption {
  static AppThemeOption fromDb(String? value) {
    switch (value) {
      case 'light':
        return AppThemeOption.light;
      case 'gba':
        return AppThemeOption.gba;
      case 'dark':
      default:
        return AppThemeOption.dark;
    }
  }

  String get databaseValue {
    switch (this) {
      case AppThemeOption.light:
        return 'light';
      case AppThemeOption.dark:
        return 'dark';
      case AppThemeOption.gba:
        return 'gba';
    }
  }
}
