/// Text de les pantalles d'autenticació (login, registre, recuperació de
/// contrasenya, confirmació d'email), centralitzat de cara a una futura
/// traducció. Vegeu `app_strings.dart` per a l'explicació general d'aquest
/// patró.
class AuthStrings {
  const AuthStrings._();

  static const appName = 'GameShelf';

  // ─────────────────────────────────────────────
  // REQUISITS DE CONTRASENYA (compartits entre registre i canvi)
  // ─────────────────────────────────────────────

  static const passwordRequirementsTitle = 'La contrasenya ha de tenir:';
  static const passwordReqMinLength = 'Almenys 8 caràcters';
  static const passwordReqUppercase = 'Una lletra majúscula';
  static const passwordReqLowercase = 'Una lletra minúscula';
  static const passwordReqNumber = 'Un número';
  static const passwordReqSymbol = 'Un símbol';

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────

  static const loginEmailOrNicknameLabel = 'Email o usuari';
  static const loginPasswordLabel = 'Contrasenya';
  static const loginForgotPassword = 'He oblidat la contrasenya';
  static const loginSubmit = 'Inicia sessió';
  static const loginCreateAccount = 'Crear compte';
  static const loginAboutLink = 'Sobre GameShelf';

  static const loginNoUserWithNickname =
      'No s\'ha trobat cap usuari amb aquest nickname.';
  static const loginEnterEmailToReset =
      'Introdueix el teu email per recuperar la contrasenya.';

  static const loginResetEmailSentTitle = 'Revisa el teu correu';
  static const loginResetEmailSentBody =
      'T\'hem enviat un enllaç per restablir la contrasenya. '
      'Revisa la safata d\'entrada i també la carpeta de correu brossa.';
  static const loginResetEmailFailed = 'No s\'ha pogut enviar el correu';

  // ─────────────────────────────────────────────
  // REGISTRE
  // ─────────────────────────────────────────────

  static const registerNicknameLabel = 'Nickname';
  static const registerEmailLabel = 'Email';
  static const registerPasswordLabel = 'Contrasenya';
  static const registerEmptyFields = 'Omple tots els camps.';
  static const registerUserCreationFailed = 'No s\'ha pogut crear l\'usuari.';
  static const registerSubmit = 'Crear compte';
  static const registerAlreadyHaveAccount = 'Ja tens compte? Inicia sessió';

  static const registerLegalPrefix = 'En crear un compte, acceptes la ';
  static const registerLegalAnd = ' i la ';
  static const registerLegalSuffix = '.';

  // ─────────────────────────────────────────────
  // RECUPERAR CONTRASENYA (forgot_password_page)
  // ─────────────────────────────────────────────

  static const forgotEnterEmail = 'Introdueix el teu email.';
  static const forgotEmailFailedPrefix = 'No s\'ha pogut enviar el correu: ';

  static const forgotTitle = 'Recuperar contrasenya';
  static const forgotBody =
      'Introdueix el teu email i t\'enviarem '
      'un enllaç per crear una nova contrasenya.';
  static const forgotEmailLabel = 'Email';
  static const forgotSubmit = 'Enviar correu';
  static const forgotBackToLogin = 'Tornar al login';

  static const forgotSentTitle = 'Revisa el teu correu';
  static const forgotSentBody =
      'T\'hem enviat un enllaç per restablir la teva contrasenya a:';

  // ─────────────────────────────────────────────
  // RESTABLIR CONTRASENYA (reset_password_page)
  // ─────────────────────────────────────────────

  static const resetAppBarTitle = 'Restablir contrasenya';
  static const resetTitle = 'Nova contrasenya';
  static const resetBody = 'Introdueix una nova contrasenya per al teu compte.';
  static const resetNewPasswordLabel = 'Nova contrasenya';
  static const resetConfirmPasswordLabel = 'Repeteix la contrasenya';
  static const resetPasswordMismatch = 'Les contrasenyes no coincideixen.';
  static const resetSubmit = 'Canviar contrasenya';
  static const resetBackToLogin = 'Tornar a iniciar sessió';

  static const resetLinkExpired =
      'L\'enllaç de recuperació ha caducat. '
      'Torna a sol·licitar el canvi de contrasenya.';

  static const resetSuccessTitle = 'Contrasenya actualitzada';
  static const resetSuccessBody =
      'La teva contrasenya s\'ha canviat correctament. '
      'Ara pots iniciar sessió amb la nova contrasenya.';
  static const resetSuccessButton = 'Iniciar sessió';

  static const resetFailedPrefix = 'No s\'ha pogut canviar la contrasenya: ';

  // ─────────────────────────────────────────────
  // CONFIRMACIÓ D'EMAIL
  // ─────────────────────────────────────────────

  static const confirmEmailTitle = 'Confirma el teu email';
  static const confirmEmailSentTo = 'T\'hem enviat un correu de confirmació a:';
  static const confirmEmailInstructions =
      'Obre el correu i fes clic a l\'enllaç per activar el teu compte.';
  static const confirmEmailBackToLogin = 'Tornar a iniciar sessió';

  // ─────────────────────────────────────────────
  // CALLBACK D'AUTENTICACIÓ
  // ─────────────────────────────────────────────

  static const callbackVerifying = 'Verificant el compte...';
  static const callbackFailedTitle = 'No s\'ha pogut verificar l\'enllaç.';
  static const callbackUnknownError = 'Error desconegut';
  static const callbackBackToLogin = 'Tornar al login';
}
