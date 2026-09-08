/// Text de les pantalles de perfil (visualització, edició i canvi de
/// contrasenya), centralitzat de cara a una futura traducció. Vegeu
/// `app_strings.dart` per a l'explicació general d'aquest patró.
class ProfileStrings {
  const ProfileStrings._();

  // ─────────────────────────────────────────────
  // PERFIL (VISUALITZACIÓ)
  // ─────────────────────────────────────────────

  static const loadFailedPrefix = 'No s\'ha pogut carregar el perfil: ';
  static const sendRequestFailedPrefix =
      'No s\'ha pogut enviar la sol·licitud: ';
  static const acceptRequestFailedPrefix =
      'No s\'ha pogut acceptar la sol·licitud: ';
  static const rejectRequestFailedPrefix =
      'No s\'ha pogut rebutjar la sol·licitud: ';
  static const removeFriendFailedPrefix = 'No s\'ha pogut eliminar l\'amic: ';

  static const removeFriendTitle = 'Eliminar amic?';
  static String removeFriendBody(String nickname) =>
      'Vols eliminar @$nickname dels teus amics?';

  static const editProfileTooltip = 'Editar perfil';
  static const shareProfileTooltip = 'Compartir perfil';
  static const logoutTooltip = 'Tancar sessió';

  static const noReviewsYet = 'Encara no has escrit cap review.';
  static String seeAllReviews(int count) => 'Veure totes les reviews ($count)';

  static const statGames = 'Jocs';
  static const statCompleted = 'Completats';
  static const statReviews = 'Reviews';
  static const statHours = 'Hores';

  static const myReviewsTitle = 'Les meves reviews';
  static const completedTitle = 'Completats';
  static const favoritesTitle = 'Preferits';

  static String gameshelfOf(String nickname) => "$nickname's GameShelf";

  static const filterLibrary = 'Library';
  static const filterDropped = 'Dropped';
  static const filterWantToPlay = 'Want to play';

  static const emptyGamesDropped = 'Aquest usuari no té jocs abandonats.';
  static const emptyGamesWantToPlay = 'Aquest usuari no té jocs pendents.';
  static const emptyGamesPlaying = 'Aquest usuari no té jocs en curs.';
  static const emptyGamesCompleted = 'Aquest usuari no té jocs completats.';
  static const emptyGamesPaused = 'Aquest usuari no té jocs pausats.';
  static const emptyGamesAny = 'Aquest usuari encara no té jocs.';

  // ─────────────────────────────────────────────
  // EDITAR PERFIL
  // ─────────────────────────────────────────────

  static const editAppBarTitle = 'Editar perfil';
  static const changePhoto = 'Canviar foto';
  static const cropAvatarTitle = 'Ajusta la foto';
  static const cropFailedMessage = 'No s\'ha pogut retallar la imatge.';

  static const nicknameLabel = 'Nickname';
  static const bioLabel = 'Bio';
  static const bioHint = 'Explica alguna cosa sobre tu...';
  static const emailLabel = 'Email';

  static const saving = 'Guardant...';
  static const saveChanges = 'Guardar canvis';

  static const informationTitle = 'Informació';

  static const securityTitle = 'Seguretat';
  static const changePasswordTitle = 'Canviar contrasenya';
  static const changePasswordSubtitle =
      'Actualitza la contrasenya del teu compte';

  static const dangerZoneTitle = 'Zona de perill';
  static const deleteAccountTitle = 'Eliminar compte';
  static const deleteAccountSubtitle =
      'Elimina permanentment el teu compte i les teves dades';

  static const deleteAccountDialogTitle = 'Eliminar compte?';
  static const deleteAccountDialogBody =
      'Aquesta acció és permanent. '
      'S\'eliminaran el teu perfil, biblioteca, reviews, '
      'amistats i activitat.';
  static const deleteAccountFailedPrefix =
      'No s\'ha pogut eliminar el compte: ';

  // ─────────────────────────────────────────────
  // DIÀLEG CANVIAR CONTRASENYA (des d'editar perfil)
  // ─────────────────────────────────────────────

  static const changePasswordDialogTitle = 'Canviar contrasenya';
  static const newPasswordLabel = 'Nova contrasenya';
  static const repeatPasswordLabel = 'Repeteix la contrasenya';
  static const passwordRequirementsIntro = 'La contrasenya ha de tenir:';
  static const reqMinLength = 'Almenys 8 caràcters';
  static const reqUppercase = 'Una lletra majúscula';
  static const reqLowercase = 'Una lletra minúscula';
  static const reqNumber = 'Un número';
  static const reqSymbol = 'Un símbol';
  static const passwordsDontMatch = 'Les contrasenyes no coincideixen.';
  static const changePasswordSuccess = 'Contrasenya canviada correctament.';
  static const changePasswordFailedPrefix =
      'No s\'ha pogut canviar la contrasenya: ';
  static const changeAction = 'Canviar';

  // ─────────────────────────────────────────────
  // COMPARTIR PERFIL
  // ─────────────────────────────────────────────

  static const shareAppBarTitle = 'Compartir perfil';
  static const shareQrCaption = 'Escaneja per trobar-me a GameShelf';
  static const shareDownloadAction = 'Descarregar imatge';
  static const shareDownloadedMessage = 'Imatge descarregada.';
  static const shareGenerateFailedPrefix = 'No s\'ha pogut generar la imatge: ';

  // ─────────────────────────────────────────────
  // CONFIGURACIÓ
  // ─────────────────────────────────────────────

  static const settingsTooltip = 'Configuració';
  static const settingsAppBarTitle = 'Configuració';

  static const settingsEditProfileSubtitle =
      'Nickname, bio, foto, contrasenya i compte';

  static const shelfStyleSectionTitle = 'Estètica';
  static const shelfStyleSectionSubtitle =
      'El color de la fusta defineix l\'aspecte de tota l\'app i de les '
      'teves estanteries.';
  static const shelfLightsLabel = 'Llums';
  static const shelfLightsNeon = 'Neó';
  static const shelfLightsBulbs = 'Bombetes';
  static const shelfWoodLabel = 'Color de la fusta';
  static const shelfWoodWalnut = 'Noguera';
  static const shelfWoodOak = 'Roure';
  static const shelfWoodEbony = 'Banús';
  static const shelfWoodCherry = 'Cirerer';
  static const shelfWoodBirch = 'Bedoll';
  static const shelfDecorationLabel = 'Decoració';
  static const shelfDecorationNone = 'Cap';
  static const shelfDecorationPoppy = 'Rosella';
  static const shelfDecorationCactus = 'Cactus';
  static const shelfDecorationAzalea = 'Azalea';
  static const shelfStyleChangeFailedPrefix =
      'No s\'ha pogut canviar l\'estètica: ';

  // ─────────────────────────────────────────────
  // PÀGINA CANVIAR CONTRASENYA (standalone)
  // ─────────────────────────────────────────────

  static const changePasswordPageTitle = 'Canviar contrasenya';
  static const fillAllFields = 'Omple tots els camps.';
  static const passwordMinLength6 =
      'La contrasenya ha de tenir almenys 6 caràcters.';
  static const passwordUpdatedSuccess =
      'Contrasenya actualitzada correctament.';
  static const newPasswordFieldLabel = 'Nova contrasenya';
  static const repeatPasswordFieldLabel = 'Repetir contrasenya';
  static const updating = 'Actualitzant...';
}
