/// Text del feed d'activitat (targeta i pantalla completa), centralitzat
/// de cara a una futura traducció. Vegeu `app_strings.dart` per a
/// l'explicació general d'aquest patró.
class ActivityStrings {
  const ActivityStrings._();

  // ─────────────────────────────────────────────
  // TEXT D'ACCIÓ PER TIPUS D'ACTIVITAT
  // ─────────────────────────────────────────────

  static const actionStartedPlayingPrefix = 'està jugant a ';
  static const actionCompletedPrefix = 'ha completat ';
  static const actionDroppedPrefix = 'ha abandonat ';
  static const actionReviewPrefix = 'ha publicat una review de ';
  static const actionAddedToLibrarySuffix = ' a la seva biblioteca';
  static const actionAddedToLibraryVerb = 'ha afegit ';
  static const actionShelfPublishedPrefix = 'ha publicat l\'estanteria ';

  static const friendshipFormedConnector = 'i ';
  static const friendshipFormedSuffix = 'ara són amics! 🎉';
  static const friendshipFormedUnknownFriend = 'algú';

  // ─────────────────────────────────────────────
  // TARGETA D'ACTIVITAT
  // ─────────────────────────────────────────────

  static const reviewNotFound = 'No s\'ha pogut trobar la review.';
  static const reviewLoadFailedPrefix = 'No s\'ha pogut carregar la review: ';
  static const seeReview = 'Veure review';

  // ─────────────────────────────────────────────
  // PANTALLA COMPLETA D'ACTIVITAT
  // ─────────────────────────────────────────────

  static const appBarTitle = 'Activitat';
  static const emptyFeed = 'Encara no hi ha activitat.';
  static const newActivityAvailable = 'Hi ha activitat nova';

  static const loadFailedPrefix = 'No s\'ha pogut carregar l\'activitat: ';
  static const loadMoreFailedPrefix =
      'No s\'han pogut carregar més activitats: ';
  static const refreshFailedPrefix =
      'No s\'ha pogut actualitzar l\'activitat: ';
}
