/// Text de les pantalles de detall/edició de joc i cerca, centralitzat de
/// cara a una futura traducció. Vegeu `app_strings.dart` per a l'explicació
/// general d'aquest patró.
class GameStrings {
  const GameStrings._();

  // ─────────────────────────────────────────────
  // DETALL DE JOC
  // ─────────────────────────────────────────────

  static const addToLibrarySheetTitle = 'Afegir a GameShelf';
  static const addToLibraryFailedPrefix =
      'No s\'ha pogut afegir el joc a la biblioteca: ';

  static const igdbLabel = 'IGDB';
  static const myReviewTitle = 'La meva review';
  static const descriptionTitle = 'Descripció';

  static const editAction = 'Editar';
  static const addToLibraryAction = 'Afegir a la biblioteca';

  // ─────────────────────────────────────────────
  // EDITAR JOC
  // ─────────────────────────────────────────────

  static String editTitle(String gameTitle) => 'Editar $gameTitle';
  static const statusTitle = 'Estat';
  static const myRatingTitle = 'La meva valoració';
  static const markAsFavorite = 'Marcar com a favorit';
  static const hoursPlayedTitle = 'Hores jugades';
  static const hoursSuffix = 'hores';
  static const reviewHint = 'Escriu la teva opinió...';
  static const saveAction = 'Guardar';

  // ─────────────────────────────────────────────
  // CERCA
  // ─────────────────────────────────────────────

  static const searchHint = 'Buscar jocs...';
  static const searchEmptyPrompt = 'Busca un joc per començar';
}
