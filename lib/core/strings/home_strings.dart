/// Text de la pantalla d'Inici (biblioteca), centralitzat de cara a una
/// futura traducció. Vegeu `app_strings.dart` per a l'explicació general
/// d'aquest patró.
class HomeStrings {
  const HomeStrings._();

  // ─────────────────────────────────────────────
  // ORDENAR
  // ─────────────────────────────────────────────

  static const sortDateAdded = "Data d'addició";
  static const sortHoursPlayed = 'Hores jugades';
  static const sortStatus = 'Estat';
  static const sortTitle = 'Títol (A-Z)';
  static const sortTooltip = 'Ordenar';

  // ─────────────────────────────────────────────
  // CAPÇALERA I CERCA
  // ─────────────────────────────────────────────

  static const defaultNickname = 'GameShelf';
  static const titleSuffix = "'s GameShelf";
  static const gamesCountSuffix = 'jocs';

  static const searchHint = 'Buscar a la meva biblioteca...';
  static const searchCloseTooltip = 'Tancar cerca';

  // ─────────────────────────────────────────────
  // FILTRES
  // ─────────────────────────────────────────────

  static const filterLibrary = 'Biblioteca';
  static const filterDropped = 'Dropped';
  static const filterWishlist = 'Wishlist';

  // ─────────────────────────────────────────────
  // ESTAT BUIT
  // ─────────────────────────────────────────────

  static const emptyLibraryTitle = 'La teva biblioteca està buida';
  static const emptyLibrarySubtitle =
      'Afegeix jocs i comença a construir la teva col·lecció.';

  static const emptyDroppedTitle = 'Cap joc abandonat';
  static const emptyDroppedSubtitle =
      'Aquí apareixeran els jocs que decideixis deixar.';

  static const emptyWishlistTitle = 'No tens jocs pendents';
  static const emptyWishlistSubtitle =
      'Afegeix jocs que vulguis jugar més endavant.';

  static const emptySearchTitle = 'No s\'han trobat jocs';
  static const emptySearchSubtitle = 'Prova amb un altre terme de cerca.';

  static const loadErrorPrefix = 'Error: ';

  // ─────────────────────────────────────────────
  // ELIMINAR JOC
  // ─────────────────────────────────────────────

  static const deleteGameTitle = 'Eliminar joc';
  static const deleteGameBodyPrefix = 'Vols eliminar ';
  static const deleteGameBodySuffix = ' de la biblioteca?';

  // ─────────────────────────────────────────────
  // BARRA SUPERIOR
  // ─────────────────────────────────────────────

  static const addGameTooltip = 'Afegir joc';
  static const notificationsTooltip = 'Notificacions';
}
