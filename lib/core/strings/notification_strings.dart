/// Text de la safata de notificacions i del banner emergent, centralitzat
/// de cara a una futura traducció. Vegeu `app_strings.dart` per a
/// l'explicació general d'aquest patró.
class NotificationStrings {
  const NotificationStrings._();

  static const appBarTitle = 'Notificacions';
  static const markAllAsRead = 'Marcar totes com a llegides';
  static const emptyList = 'Encara no tens cap notificació.';

  static const loadFailedPrefix =
      'No s\'han pogut carregar les notificacions: ';

  // ─────────────────────────────────────────────
  // MISSATGE PER TIPUS (llista de notificacions)
  // ─────────────────────────────────────────────

  static const listFriendRequest = 't\'ha enviat una sol·licitud d\'amistat';
  static const listFriendAccepted =
      'ha acceptat la teva sol·licitud d\'amistat';
  static const listActivityLikePrefix = 'li ha agradat la teva activitat sobre ';
  static const listActivityLikeUnknownGame = 'un joc';

  // ─────────────────────────────────────────────
  // BANNER EMERGENT
  // ─────────────────────────────────────────────

  static const bannerFriendRequestSuffix =
      't\'ha enviat una sol·licitud d\'amistat';
  static const bannerFriendAcceptedSuffix = 'ha acceptat la teva sol·licitud';
  static const bannerActivityLikeSuffix = 'ha donat una estrella';
  static const bannerActivityLikeGamePrefix = ' a ';
}
