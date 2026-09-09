import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @okAction.
  ///
  /// In ca, this message translates to:
  /// **'D\'acord'**
  String get okAction;

  /// No description provided for @profileLoadFailedGeneric.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar el perfil'**
  String get profileLoadFailedGeneric;

  /// No description provided for @monthJanuary.
  ///
  /// In ca, this message translates to:
  /// **'Gener'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In ca, this message translates to:
  /// **'Febrer'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In ca, this message translates to:
  /// **'Març'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In ca, this message translates to:
  /// **'Abril'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In ca, this message translates to:
  /// **'Maig'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In ca, this message translates to:
  /// **'Juny'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In ca, this message translates to:
  /// **'Juliol'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In ca, this message translates to:
  /// **'Agost'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In ca, this message translates to:
  /// **'Setembre'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In ca, this message translates to:
  /// **'Octubre'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In ca, this message translates to:
  /// **'Novembre'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In ca, this message translates to:
  /// **'Desembre'**
  String get monthDecember;

  /// No description provided for @gameStatusWantToPlay.
  ///
  /// In ca, this message translates to:
  /// **'Vull jugar-hi'**
  String get gameStatusWantToPlay;

  /// No description provided for @gameStatusPlaying.
  ///
  /// In ca, this message translates to:
  /// **'Jugant'**
  String get gameStatusPlaying;

  /// No description provided for @gameStatusCompleted.
  ///
  /// In ca, this message translates to:
  /// **'Completat'**
  String get gameStatusCompleted;

  /// No description provided for @gameStatusDropped.
  ///
  /// In ca, this message translates to:
  /// **'Abandonat'**
  String get gameStatusDropped;

  /// No description provided for @gameStatusPaused.
  ///
  /// In ca, this message translates to:
  /// **'Pausat'**
  String get gameStatusPaused;

  /// No description provided for @platformNotSpecified.
  ///
  /// In ca, this message translates to:
  /// **'No especificat'**
  String get platformNotSpecified;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In ca, this message translates to:
  /// **'Email o contrasenya incorrectes.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In ca, this message translates to:
  /// **'Has de confirmar el teu email abans d\'iniciar sessió.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorEmailExists.
  ///
  /// In ca, this message translates to:
  /// **'Ja existeix un compte amb aquest email.'**
  String get errorEmailExists;

  /// No description provided for @errorWeakPassword.
  ///
  /// In ca, this message translates to:
  /// **'La contrasenya és massa feble.'**
  String get errorWeakPassword;

  /// No description provided for @errorSamePassword.
  ///
  /// In ca, this message translates to:
  /// **'La nova contrasenya ha de ser diferent de l\'actual.'**
  String get errorSamePassword;

  /// No description provided for @errorRateLimited.
  ///
  /// In ca, this message translates to:
  /// **'Has fet massa peticions seguides. Espera una mica i torna-ho a provar.'**
  String get errorRateLimited;

  /// No description provided for @errorSignupDisabled.
  ///
  /// In ca, this message translates to:
  /// **'El registre no està disponible ara mateix.'**
  String get errorSignupDisabled;

  /// No description provided for @errorSessionExpired.
  ///
  /// In ca, this message translates to:
  /// **'La teva sessió ha caducat. Torna a iniciar sessió.'**
  String get errorSessionExpired;

  /// No description provided for @errorDuplicateRecord.
  ///
  /// In ca, this message translates to:
  /// **'Ja existeix un registre amb aquestes dades.'**
  String get errorDuplicateRecord;

  /// No description provided for @errorMissingRequiredData.
  ///
  /// In ca, this message translates to:
  /// **'Falten dades obligatòries.'**
  String get errorMissingRequiredData;

  /// No description provided for @errorReferencedNotFound.
  ///
  /// In ca, this message translates to:
  /// **'L\'element referenciat no existeix.'**
  String get errorReferencedNotFound;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In ca, this message translates to:
  /// **'No tens permís per fer aquesta acció.'**
  String get errorPermissionDenied;

  /// No description provided for @errorOperationFailed.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut completar l\'operació. Torna-ho a provar.'**
  String get errorOperationFailed;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In ca, this message translates to:
  /// **'El fitxer és massa gran.'**
  String get errorFileTooLarge;

  /// No description provided for @errorUploadFailed.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut pujar el fitxer. Torna-ho a provar.'**
  String get errorUploadFailed;

  /// No description provided for @errorServerOperationFailed.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut completar l\'operació al servidor.'**
  String get errorServerOperationFailed;

  /// No description provided for @errorUnexpected.
  ///
  /// In ca, this message translates to:
  /// **'Hi ha hagut un error inesperat. Torna-ho a provar.'**
  String get errorUnexpected;

  /// No description provided for @errorNotAuthenticated.
  ///
  /// In ca, this message translates to:
  /// **'Usuari no autenticat.'**
  String get errorNotAuthenticated;

  /// No description provided for @errorCannotFriendSelf.
  ///
  /// In ca, this message translates to:
  /// **'No et pots enviar una sol·licitud a tu mateix.'**
  String get errorCannotFriendSelf;

  /// No description provided for @errorFriendshipAlreadyExists.
  ///
  /// In ca, this message translates to:
  /// **'Ja existeix una relació amb aquest usuari.'**
  String get errorFriendshipAlreadyExists;

  /// No description provided for @errorDeleteAccountGeneric.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut eliminar el compte.'**
  String get errorDeleteAccountGeneric;

  /// No description provided for @errorSaveGameGeneric.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut desar el joc.'**
  String get errorSaveGameGeneric;

  /// No description provided for @actionStartedPlayingPrefix.
  ///
  /// In ca, this message translates to:
  /// **'està jugant a '**
  String get actionStartedPlayingPrefix;

  /// No description provided for @actionCompletedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'ha completat '**
  String get actionCompletedPrefix;

  /// No description provided for @actionDroppedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'ha abandonat '**
  String get actionDroppedPrefix;

  /// No description provided for @actionReviewPrefix.
  ///
  /// In ca, this message translates to:
  /// **'ha publicat una review de '**
  String get actionReviewPrefix;

  /// No description provided for @actionAddedToLibrarySuffix.
  ///
  /// In ca, this message translates to:
  /// **' a la seva biblioteca'**
  String get actionAddedToLibrarySuffix;

  /// No description provided for @actionAddedToLibraryVerb.
  ///
  /// In ca, this message translates to:
  /// **'ha afegit '**
  String get actionAddedToLibraryVerb;

  /// No description provided for @actionShelfPublishedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'ha publicat l\'estanteria '**
  String get actionShelfPublishedPrefix;

  /// No description provided for @friendshipFormedConnector.
  ///
  /// In ca, this message translates to:
  /// **'i '**
  String get friendshipFormedConnector;

  /// No description provided for @friendshipFormedSuffix.
  ///
  /// In ca, this message translates to:
  /// **'ara són amics! 🎉'**
  String get friendshipFormedSuffix;

  /// No description provided for @friendshipFormedUnknownFriend.
  ///
  /// In ca, this message translates to:
  /// **'algú'**
  String get friendshipFormedUnknownFriend;

  /// No description provided for @reviewNotFound.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut trobar la review.'**
  String get reviewNotFound;

  /// No description provided for @reviewLoadFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar la review: '**
  String get reviewLoadFailedPrefix;

  /// No description provided for @seeReview.
  ///
  /// In ca, this message translates to:
  /// **'Veure review'**
  String get seeReview;

  /// No description provided for @activityAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Activitat'**
  String get activityAppBarTitle;

  /// No description provided for @emptyFeed.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha activitat.'**
  String get emptyFeed;

  /// No description provided for @newActivityAvailable.
  ///
  /// In ca, this message translates to:
  /// **'Hi ha activitat nova'**
  String get newActivityAvailable;

  /// No description provided for @activityLoadFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar l\'activitat: '**
  String get activityLoadFailedPrefix;

  /// No description provided for @loadMoreFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar més activitats: '**
  String get loadMoreFailedPrefix;

  /// No description provided for @refreshFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut actualitzar l\'activitat: '**
  String get refreshFailedPrefix;

  /// No description provided for @navHome.
  ///
  /// In ca, this message translates to:
  /// **'Inici'**
  String get navHome;

  /// No description provided for @navLlamp.
  ///
  /// In ca, this message translates to:
  /// **'Descobreix'**
  String get navLlamp;

  /// No description provided for @navSocial.
  ///
  /// In ca, this message translates to:
  /// **'Social'**
  String get navSocial;

  /// No description provided for @navProfile.
  ///
  /// In ca, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @actionCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In ca, this message translates to:
  /// **'Guardar'**
  String get actionSave;

  /// No description provided for @actionAccept.
  ///
  /// In ca, this message translates to:
  /// **'Acceptar'**
  String get actionAccept;

  /// No description provided for @actionReject.
  ///
  /// In ca, this message translates to:
  /// **'Rebutjar'**
  String get actionReject;

  /// No description provided for @actionLogout.
  ///
  /// In ca, this message translates to:
  /// **'Tancar sessió'**
  String get actionLogout;

  /// No description provided for @actionEdit.
  ///
  /// In ca, this message translates to:
  /// **'Editar'**
  String get actionEdit;

  /// No description provided for @actionSeeMore.
  ///
  /// In ca, this message translates to:
  /// **'Veure més'**
  String get actionSeeMore;

  /// No description provided for @friendshipAdd.
  ///
  /// In ca, this message translates to:
  /// **'Afegir amic'**
  String get friendshipAdd;

  /// No description provided for @friendshipRequestSent.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud enviada'**
  String get friendshipRequestSent;

  /// No description provided for @friendshipFriends.
  ///
  /// In ca, this message translates to:
  /// **'Amics'**
  String get friendshipFriends;

  /// No description provided for @appName.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf'**
  String get appName;

  /// No description provided for @passwordRequirementsTitle.
  ///
  /// In ca, this message translates to:
  /// **'La contrasenya ha de tenir:'**
  String get passwordRequirementsTitle;

  /// No description provided for @passwordReqMinLength.
  ///
  /// In ca, this message translates to:
  /// **'Almenys 8 caràcters'**
  String get passwordReqMinLength;

  /// No description provided for @passwordReqUppercase.
  ///
  /// In ca, this message translates to:
  /// **'Una lletra majúscula'**
  String get passwordReqUppercase;

  /// No description provided for @passwordReqLowercase.
  ///
  /// In ca, this message translates to:
  /// **'Una lletra minúscula'**
  String get passwordReqLowercase;

  /// No description provided for @passwordReqNumber.
  ///
  /// In ca, this message translates to:
  /// **'Un número'**
  String get passwordReqNumber;

  /// No description provided for @passwordReqSymbol.
  ///
  /// In ca, this message translates to:
  /// **'Un símbol'**
  String get passwordReqSymbol;

  /// No description provided for @loginEmailOrNicknameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Email o usuari'**
  String get loginEmailOrNicknameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya'**
  String get loginPasswordLabel;

  /// No description provided for @loginForgotPassword.
  ///
  /// In ca, this message translates to:
  /// **'He oblidat la contrasenya'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In ca, this message translates to:
  /// **'Inicia sessió'**
  String get loginSubmit;

  /// No description provided for @loginCreateAccount.
  ///
  /// In ca, this message translates to:
  /// **'Crear compte'**
  String get loginCreateAccount;

  /// No description provided for @loginAboutLink.
  ///
  /// In ca, this message translates to:
  /// **'Sobre GameShelf'**
  String get loginAboutLink;

  /// No description provided for @loginNoUserWithNickname.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha trobat cap usuari amb aquest nickname.'**
  String get loginNoUserWithNickname;

  /// No description provided for @loginEnterEmailToReset.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix el teu email per recuperar la contrasenya.'**
  String get loginEnterEmailToReset;

  /// No description provided for @loginResetEmailSentTitle.
  ///
  /// In ca, this message translates to:
  /// **'Revisa el teu correu'**
  String get loginResetEmailSentTitle;

  /// No description provided for @loginResetEmailSentBody.
  ///
  /// In ca, this message translates to:
  /// **'T\'hem enviat un enllaç per restablir la contrasenya. Revisa la safata d\'entrada i també la carpeta de correu brossa.'**
  String get loginResetEmailSentBody;

  /// No description provided for @loginResetEmailFailed.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut enviar el correu'**
  String get loginResetEmailFailed;

  /// No description provided for @registerNicknameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nickname'**
  String get registerNicknameLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In ca, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya'**
  String get registerPasswordLabel;

  /// No description provided for @registerEmptyFields.
  ///
  /// In ca, this message translates to:
  /// **'Omple tots els camps.'**
  String get registerEmptyFields;

  /// No description provided for @registerUserCreationFailed.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut crear l\'usuari.'**
  String get registerUserCreationFailed;

  /// No description provided for @registerSubmit.
  ///
  /// In ca, this message translates to:
  /// **'Crear compte'**
  String get registerSubmit;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In ca, this message translates to:
  /// **'Ja tens compte? Inicia sessió'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerLegalPrefix.
  ///
  /// In ca, this message translates to:
  /// **'En crear un compte, acceptes la '**
  String get registerLegalPrefix;

  /// No description provided for @registerLegalAnd.
  ///
  /// In ca, this message translates to:
  /// **' i la '**
  String get registerLegalAnd;

  /// No description provided for @registerLegalSuffix.
  ///
  /// In ca, this message translates to:
  /// **'.'**
  String get registerLegalSuffix;

  /// No description provided for @forgotEnterEmail.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix el teu email.'**
  String get forgotEnterEmail;

  /// No description provided for @forgotEmailFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut enviar el correu: '**
  String get forgotEmailFailedPrefix;

  /// No description provided for @forgotTitle.
  ///
  /// In ca, this message translates to:
  /// **'Recuperar contrasenya'**
  String get forgotTitle;

  /// No description provided for @forgotBody.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix el teu email i t\'enviarem un enllaç per crear una nova contrasenya.'**
  String get forgotBody;

  /// No description provided for @forgotEmailLabel.
  ///
  /// In ca, this message translates to:
  /// **'Email'**
  String get forgotEmailLabel;

  /// No description provided for @forgotSubmit.
  ///
  /// In ca, this message translates to:
  /// **'Enviar correu'**
  String get forgotSubmit;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Tornar al login'**
  String get forgotBackToLogin;

  /// No description provided for @forgotSentTitle.
  ///
  /// In ca, this message translates to:
  /// **'Revisa el teu correu'**
  String get forgotSentTitle;

  /// No description provided for @forgotSentBody.
  ///
  /// In ca, this message translates to:
  /// **'T\'hem enviat un enllaç per restablir la teva contrasenya a:'**
  String get forgotSentBody;

  /// No description provided for @resetAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Restablir contrasenya'**
  String get resetAppBarTitle;

  /// No description provided for @resetTitle.
  ///
  /// In ca, this message translates to:
  /// **'Nova contrasenya'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix una nova contrasenya per al teu compte.'**
  String get resetBody;

  /// No description provided for @resetNewPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nova contrasenya'**
  String get resetNewPasswordLabel;

  /// No description provided for @resetConfirmPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Repeteix la contrasenya'**
  String get resetConfirmPasswordLabel;

  /// No description provided for @resetPasswordMismatch.
  ///
  /// In ca, this message translates to:
  /// **'Les contrasenyes no coincideixen.'**
  String get resetPasswordMismatch;

  /// No description provided for @resetSubmit.
  ///
  /// In ca, this message translates to:
  /// **'Canviar contrasenya'**
  String get resetSubmit;

  /// No description provided for @resetBackToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Tornar a iniciar sessió'**
  String get resetBackToLogin;

  /// No description provided for @resetLinkExpired.
  ///
  /// In ca, this message translates to:
  /// **'L\'enllaç de recuperació ha caducat. Torna a sol·licitar el canvi de contrasenya.'**
  String get resetLinkExpired;

  /// No description provided for @resetSuccessTitle.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya actualitzada'**
  String get resetSuccessTitle;

  /// No description provided for @resetSuccessBody.
  ///
  /// In ca, this message translates to:
  /// **'La teva contrasenya s\'ha canviat correctament. Ara pots iniciar sessió amb la nova contrasenya.'**
  String get resetSuccessBody;

  /// No description provided for @resetSuccessButton.
  ///
  /// In ca, this message translates to:
  /// **'Iniciar sessió'**
  String get resetSuccessButton;

  /// No description provided for @resetFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut canviar la contrasenya: '**
  String get resetFailedPrefix;

  /// No description provided for @confirmEmailTitle.
  ///
  /// In ca, this message translates to:
  /// **'Confirma el teu email'**
  String get confirmEmailTitle;

  /// No description provided for @confirmEmailSentTo.
  ///
  /// In ca, this message translates to:
  /// **'T\'hem enviat un correu de confirmació a:'**
  String get confirmEmailSentTo;

  /// No description provided for @confirmEmailInstructions.
  ///
  /// In ca, this message translates to:
  /// **'Obre el correu i fes clic a l\'enllaç per activar el teu compte.'**
  String get confirmEmailInstructions;

  /// No description provided for @confirmEmailBackToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Tornar a iniciar sessió'**
  String get confirmEmailBackToLogin;

  /// No description provided for @callbackVerifying.
  ///
  /// In ca, this message translates to:
  /// **'Verificant el compte...'**
  String get callbackVerifying;

  /// No description provided for @callbackFailedTitle.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut verificar l\'enllaç.'**
  String get callbackFailedTitle;

  /// No description provided for @callbackUnknownError.
  ///
  /// In ca, this message translates to:
  /// **'Error desconegut'**
  String get callbackUnknownError;

  /// No description provided for @callbackBackToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Tornar al login'**
  String get callbackBackToLogin;

  /// No description provided for @addToLibrarySheetTitle.
  ///
  /// In ca, this message translates to:
  /// **'Afegir a GameShelf'**
  String get addToLibrarySheetTitle;

  /// No description provided for @addToLibraryFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut afegir el joc a la biblioteca: '**
  String get addToLibraryFailedPrefix;

  /// No description provided for @igdbLabel.
  ///
  /// In ca, this message translates to:
  /// **'IGDB'**
  String get igdbLabel;

  /// No description provided for @myReviewTitle.
  ///
  /// In ca, this message translates to:
  /// **'La meva review'**
  String get myReviewTitle;

  /// No description provided for @descriptionTitle.
  ///
  /// In ca, this message translates to:
  /// **'Descripció'**
  String get descriptionTitle;

  /// No description provided for @editAction.
  ///
  /// In ca, this message translates to:
  /// **'Editar'**
  String get editAction;

  /// No description provided for @addToLibraryAction.
  ///
  /// In ca, this message translates to:
  /// **'Afegir a la biblioteca'**
  String get addToLibraryAction;

  /// No description provided for @platformLabel.
  ///
  /// In ca, this message translates to:
  /// **'Plataforma'**
  String get platformLabel;

  /// No description provided for @confirmDatesTitle.
  ///
  /// In ca, this message translates to:
  /// **'Quan?'**
  String get confirmDatesTitle;

  /// No description provided for @confirmCompletedTitle.
  ///
  /// In ca, this message translates to:
  /// **'Joc completat'**
  String get confirmCompletedTitle;

  /// No description provided for @dateStartedLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data d\'inici'**
  String get dateStartedLabel;

  /// No description provided for @dateCompletedLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data de finalització'**
  String get dateCompletedLabel;

  /// No description provided for @dateDroppedLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data d\'abandonament'**
  String get dateDroppedLabel;

  /// No description provided for @datePausedLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data de pausa'**
  String get datePausedLabel;

  /// No description provided for @dateResumedLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data de represa'**
  String get dateResumedLabel;

  /// No description provided for @rateDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Puntua aquest joc'**
  String get rateDialogTitle;

  /// No description provided for @rateFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut desar la puntuació: '**
  String get rateFailedPrefix;

  /// No description provided for @editTitle.
  ///
  /// In ca, this message translates to:
  /// **'Editar {gameTitle}'**
  String editTitle(String gameTitle);

  /// No description provided for @statusTitle.
  ///
  /// In ca, this message translates to:
  /// **'Estat'**
  String get statusTitle;

  /// No description provided for @myRatingTitle.
  ///
  /// In ca, this message translates to:
  /// **'La meva valoració'**
  String get myRatingTitle;

  /// No description provided for @markAsFavorite.
  ///
  /// In ca, this message translates to:
  /// **'Marcar com a preferit'**
  String get markAsFavorite;

  /// No description provided for @hoursPlayedTitle.
  ///
  /// In ca, this message translates to:
  /// **'Hores jugades'**
  String get hoursPlayedTitle;

  /// No description provided for @hoursSuffix.
  ///
  /// In ca, this message translates to:
  /// **'hores'**
  String get hoursSuffix;

  /// No description provided for @reviewHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu la teva opinió...'**
  String get reviewHint;

  /// No description provided for @saveAction.
  ///
  /// In ca, this message translates to:
  /// **'Guardar'**
  String get saveAction;

  /// No description provided for @gameSearchHint.
  ///
  /// In ca, this message translates to:
  /// **'Buscar jocs...'**
  String get gameSearchHint;

  /// No description provided for @searchEmptyPrompt.
  ///
  /// In ca, this message translates to:
  /// **'Busca un joc per començar'**
  String get searchEmptyPrompt;

  /// No description provided for @sortDateAdded.
  ///
  /// In ca, this message translates to:
  /// **'Data d\'addició'**
  String get sortDateAdded;

  /// No description provided for @sortDatePlayed.
  ///
  /// In ca, this message translates to:
  /// **'Data que hi vas jugar'**
  String get sortDatePlayed;

  /// No description provided for @sortHoursPlayed.
  ///
  /// In ca, this message translates to:
  /// **'Hores jugades'**
  String get sortHoursPlayed;

  /// No description provided for @sortStatus.
  ///
  /// In ca, this message translates to:
  /// **'Estat'**
  String get sortStatus;

  /// No description provided for @sortTitle.
  ///
  /// In ca, this message translates to:
  /// **'Títol (A-Z)'**
  String get sortTitle;

  /// No description provided for @sortTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Ordenar'**
  String get sortTooltip;

  /// No description provided for @defaultNickname.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf'**
  String get defaultNickname;

  /// No description provided for @titleSuffix.
  ///
  /// In ca, this message translates to:
  /// **'\'s GameShelf'**
  String get titleSuffix;

  /// No description provided for @gamesCountSuffix.
  ///
  /// In ca, this message translates to:
  /// **'jocs'**
  String get gamesCountSuffix;

  /// No description provided for @homeSearchHint.
  ///
  /// In ca, this message translates to:
  /// **'Buscar a la meva biblioteca...'**
  String get homeSearchHint;

  /// No description provided for @searchCloseTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Tancar cerca'**
  String get searchCloseTooltip;

  /// No description provided for @homeFilterLibrary.
  ///
  /// In ca, this message translates to:
  /// **'Biblioteca'**
  String get homeFilterLibrary;

  /// No description provided for @homeFilterDropped.
  ///
  /// In ca, this message translates to:
  /// **'Dropped'**
  String get homeFilterDropped;

  /// No description provided for @filterWishlist.
  ///
  /// In ca, this message translates to:
  /// **'Wishlist'**
  String get filterWishlist;

  /// No description provided for @emptyLibraryTitle.
  ///
  /// In ca, this message translates to:
  /// **'La teva biblioteca està buida'**
  String get emptyLibraryTitle;

  /// No description provided for @emptyLibrarySubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix jocs i comença a construir la teva col·lecció.'**
  String get emptyLibrarySubtitle;

  /// No description provided for @emptyDroppedTitle.
  ///
  /// In ca, this message translates to:
  /// **'Cap joc abandonat'**
  String get emptyDroppedTitle;

  /// No description provided for @emptyDroppedSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Aquí apareixeran els jocs que decideixis deixar.'**
  String get emptyDroppedSubtitle;

  /// No description provided for @emptyWishlistTitle.
  ///
  /// In ca, this message translates to:
  /// **'No tens jocs pendents'**
  String get emptyWishlistTitle;

  /// No description provided for @emptyWishlistSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix jocs que vulguis jugar més endavant.'**
  String get emptyWishlistSubtitle;

  /// No description provided for @emptySearchTitle.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat jocs'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Prova amb un altre terme de cerca.'**
  String get emptySearchSubtitle;

  /// No description provided for @loadErrorPrefix.
  ///
  /// In ca, this message translates to:
  /// **'Error: '**
  String get loadErrorPrefix;

  /// No description provided for @deleteGameTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar joc'**
  String get deleteGameTitle;

  /// No description provided for @deleteGameBodyPrefix.
  ///
  /// In ca, this message translates to:
  /// **'Vols eliminar '**
  String get deleteGameBodyPrefix;

  /// No description provided for @deleteGameBodySuffix.
  ///
  /// In ca, this message translates to:
  /// **' de la biblioteca?'**
  String get deleteGameBodySuffix;

  /// No description provided for @addGameTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Afegir joc'**
  String get addGameTooltip;

  /// No description provided for @notificationsTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions'**
  String get notificationsTooltip;

  /// No description provided for @favoriteAddedMessage.
  ///
  /// In ca, this message translates to:
  /// **'Afegit als preferits'**
  String get favoriteAddedMessage;

  /// No description provided for @favoriteRemovedMessage.
  ///
  /// In ca, this message translates to:
  /// **'Tret dels preferits'**
  String get favoriteRemovedMessage;

  /// No description provided for @favoriteNotCompletedMessage.
  ///
  /// In ca, this message translates to:
  /// **'Només es poden marcar com a preferits els jocs completats'**
  String get favoriteNotCompletedMessage;

  /// No description provided for @favoriteUpdateFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut actualitzar el preferit: '**
  String get favoriteUpdateFailedPrefix;

  /// No description provided for @favoriteConfirmAddBody.
  ///
  /// In ca, this message translates to:
  /// **'Vols afegir aquest joc als teus preferits?'**
  String get favoriteConfirmAddBody;

  /// No description provided for @favoriteConfirmRemoveBody.
  ///
  /// In ca, this message translates to:
  /// **'Vols treure aquest joc dels teus preferits?'**
  String get favoriteConfirmRemoveBody;

  /// No description provided for @favoriteConfirmAddAction.
  ///
  /// In ca, this message translates to:
  /// **'Afegir als preferits'**
  String get favoriteConfirmAddAction;

  /// No description provided for @favoriteConfirmRemoveAction.
  ///
  /// In ca, this message translates to:
  /// **'Treure dels preferits'**
  String get favoriteConfirmRemoveAction;

  /// No description provided for @contactEmail.
  ///
  /// In ca, this message translates to:
  /// **'contacte@gameshelfapp.net'**
  String get contactEmail;

  /// No description provided for @lastUpdated.
  ///
  /// In ca, this message translates to:
  /// **'Última actualització: setembre de 2026.'**
  String get lastUpdated;

  /// No description provided for @privacyTitle.
  ///
  /// In ca, this message translates to:
  /// **'Política de privacitat'**
  String get privacyTitle;

  /// No description provided for @privacyIntro.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta política explica quines dades personals recull GameShelf, amb quina finalitat i quins drets tens sobre elles, d\'acord amb el Reglament (UE) 2016/679 (RGPD) i la Llei Orgànica 3/2018 de Protecció de Dades i Garantia dels Drets Digitals (LOPDGDD).'**
  String get privacyIntro;

  /// No description provided for @privacySection1Title.
  ///
  /// In ca, this message translates to:
  /// **'1. Responsable del tractament'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In ca, this message translates to:
  /// **'Jordi Bertomeu Primo, com a titular i desenvolupador de GameShelf, és el responsable del tractament de les dades que es descriuen en aquesta política.\nContacte: contacte@gameshelfapp.net'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In ca, this message translates to:
  /// **'2. Quines dades recollim'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Bullet1.
  ///
  /// In ca, this message translates to:
  /// **'Dades de registre: email i contrasenya (la contrasenya es guarda xifrada, mai en text pla).'**
  String get privacySection2Bullet1;

  /// No description provided for @privacySection2Bullet2.
  ///
  /// In ca, this message translates to:
  /// **'Dades de perfil: nickname, biografia i foto de perfil.'**
  String get privacySection2Bullet2;

  /// No description provided for @privacySection2Bullet3.
  ///
  /// In ca, this message translates to:
  /// **'Dades d\'ús del servei: la teva biblioteca de jocs, els estats (jugant, completat, etc.), valoracions, hores jugades i reviews que escriguis.'**
  String get privacySection2Bullet3;

  /// No description provided for @privacySection2Bullet4.
  ///
  /// In ca, this message translates to:
  /// **'Dades socials: sol·licituds i relacions d\'amistat amb altres usuaris, i l\'activitat que es genera a partir de la teva biblioteca (per mostrar-la als teus amics).'**
  String get privacySection2Bullet4;

  /// No description provided for @privacySection3Title.
  ///
  /// In ca, this message translates to:
  /// **'3. Amb quina finalitat les tractem'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Bullet1.
  ///
  /// In ca, this message translates to:
  /// **'Per crear i gestionar el teu compte i permetre l\'ús de les funcionalitats de l\'aplicació (biblioteca, cerca de jocs, funcions socials).'**
  String get privacySection3Bullet1;

  /// No description provided for @privacySection3Bullet2.
  ///
  /// In ca, this message translates to:
  /// **'Per enviar-te correus estrictament necessaris per al servei: confirmació de compte i recuperació de contrasenya.'**
  String get privacySection3Bullet2;

  /// No description provided for @privacySection3Body.
  ///
  /// In ca, this message translates to:
  /// **'La base legal per a aquests tractaments és l\'execució del contracte de servei que acceptes en crear un compte (art. 6.1.b RGPD).'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In ca, this message translates to:
  /// **'4. Amb qui compartim les dades'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Bullet1.
  ///
  /// In ca, this message translates to:
  /// **'Supabase Inc., com a encarregat del tractament: allotja la base de dades, l\'autenticació i els fitxers (com les fotos de perfil) en servidors situats a la Unió Europea.'**
  String get privacySection4Bullet1;

  /// No description provided for @privacySection4Bullet2.
  ///
  /// In ca, this message translates to:
  /// **'IGDB (propietat de Twitch/Amazon), com a proveïdor del catàleg de videojocs: només rep el text que introdueixes quan cerques un joc, mai dades personals del teu compte.'**
  String get privacySection4Bullet2;

  /// No description provided for @privacySection4Body.
  ///
  /// In ca, this message translates to:
  /// **'No compartim, venem ni cedim les teves dades a tercers amb finalitats publicitàries.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In ca, this message translates to:
  /// **'5. Durant quant de temps les guardem'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In ca, this message translates to:
  /// **'Mentre mantinguis el teu compte actiu. Pots eliminar permanentment el teu compte en qualsevol moment des de \"Editar perfil → Eliminar compte\"; en fer-ho, s\'esborren el teu perfil, biblioteca, amistats i activitat sense possibilitat de recuperació.'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In ca, this message translates to:
  /// **'6. Els teus drets'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body1.
  ///
  /// In ca, this message translates to:
  /// **'Tens dret a accedir, rectificar, suprimir, limitar o oposar-te al tractament de les teves dades, i a la seva portabilitat. Pots exercir la majoria d\'aquests drets directament des de l\'app (editar el teu perfil o eliminar el compte) o escrivint-nos a contacte@gameshelfapp.net.'**
  String get privacySection6Body1;

  /// No description provided for @privacySection6Body2.
  ///
  /// In ca, this message translates to:
  /// **'També tens dret a presentar una reclamació davant l\'Agència Espanyola de Protecció de Dades (www.aepd.es) si consideres que el tractament de les teves dades no s\'ajusta a la normativa.'**
  String get privacySection6Body2;

  /// No description provided for @privacySection7Title.
  ///
  /// In ca, this message translates to:
  /// **'7. Seguretat'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In ca, this message translates to:
  /// **'Les connexions es fan xifrades (HTTPS) i la base de dades aplica regles d\'accés (Row Level Security) perquè cada usuari només pugui llegir i modificar les seves pròpies dades privades.'**
  String get privacySection7Body;

  /// No description provided for @privacySection8Title.
  ///
  /// In ca, this message translates to:
  /// **'8. Menors d\'edat'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Body.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf no està dirigida a menors de 14 anys. No recollim conscientment dades de menors per sota d\'aquesta edat.'**
  String get privacySection8Body;

  /// No description provided for @privacySection9Title.
  ///
  /// In ca, this message translates to:
  /// **'9. Canvis a aquesta política'**
  String get privacySection9Title;

  /// No description provided for @privacySection9Body.
  ///
  /// In ca, this message translates to:
  /// **'Podem actualitzar aquesta política per adaptar-la a canvis legals o del servei. T\'avisarem dins l\'aplicació si els canvis són rellevants.'**
  String get privacySection9Body;

  /// No description provided for @cookiesTitle.
  ///
  /// In ca, this message translates to:
  /// **'Política de cookies'**
  String get cookiesTitle;

  /// No description provided for @cookiesNoThirdPartyTitle.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf no fa servir cookies de tercers'**
  String get cookiesNoThirdPartyTitle;

  /// No description provided for @cookiesNoThirdPartyBody.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf no utilitza cookies de publicitat, seguiment ni anàlisi (analytics) de cap tipus. No et rastregem entre webs ni compartim el teu comportament amb tercers amb finalitats comercials.'**
  String get cookiesNoThirdPartyBody;

  /// No description provided for @cookiesEssentialTitle.
  ///
  /// In ca, this message translates to:
  /// **'Emmagatzematge tècnic essencial'**
  String get cookiesEssentialTitle;

  /// No description provided for @cookiesEssentialBody1.
  ///
  /// In ca, this message translates to:
  /// **'Per mantenir la teva sessió iniciada, l\'aplicació guarda un testimoni de sessió (token d\'autenticació) a l\'emmagatzematge local del teu navegador, gestionat pel nostre proveïdor d\'autenticació (Supabase). Aquest emmagatzematge és estrictament necessari perquè l\'aplicació funcioni (no haver de tornar a iniciar sessió cada vegada) i no s\'utilitza amb cap altra finalitat.'**
  String get cookiesEssentialBody1;

  /// No description provided for @cookiesEssentialBody2.
  ///
  /// In ca, this message translates to:
  /// **'Com que es tracta d\'emmagatzematge tècnicament necessari i no de cookies de seguiment o publicitàries, l\'aplicació no mostra un bàner de consentiment de cookies.'**
  String get cookiesEssentialBody2;

  /// No description provided for @cookiesFutureChangesTitle.
  ///
  /// In ca, this message translates to:
  /// **'Canvis futurs'**
  String get cookiesFutureChangesTitle;

  /// No description provided for @cookiesFutureChangesBody.
  ///
  /// In ca, this message translates to:
  /// **'Si en el futur incorporéssim eines d\'anàlisi o publicitat que requereixin cookies no essencials, actualitzarem aquesta política i, si la normativa ho exigeix, et demanarem el teu consentiment abans d\'activar-les.'**
  String get cookiesFutureChangesBody;

  /// No description provided for @cookiesContactTitle.
  ///
  /// In ca, this message translates to:
  /// **'Contacte'**
  String get cookiesContactTitle;

  /// No description provided for @cookiesContactBody.
  ///
  /// In ca, this message translates to:
  /// **'Si tens dubtes sobre aquesta política, escriu-nos a contacte@gameshelfapp.net.'**
  String get cookiesContactBody;

  /// No description provided for @aboutTitle.
  ///
  /// In ca, this message translates to:
  /// **'Sobre GameShelf'**
  String get aboutTitle;

  /// No description provided for @aboutAppName.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf'**
  String get aboutAppName;

  /// No description provided for @aboutVersionLabel.
  ///
  /// In ca, this message translates to:
  /// **'Versió'**
  String get aboutVersionLabel;

  /// No description provided for @aboutDescription.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf és una aplicació social per als jugadors que permet fer seguiment de la teva biblioteca de videojocs: registra a què estàs jugant, marca els teus preferits, escriu reviews i comparteix la teva activitat amb amics, i descobreix nous videojocs.'**
  String get aboutDescription;

  /// No description provided for @aboutDeveloperTitle.
  ///
  /// In ca, this message translates to:
  /// **'Desenvolupador'**
  String get aboutDeveloperTitle;

  /// No description provided for @aboutDeveloperName.
  ///
  /// In ca, this message translates to:
  /// **'Jordi Bertomeu Primo'**
  String get aboutDeveloperName;

  /// No description provided for @aboutDeveloperBio.
  ///
  /// In ca, this message translates to:
  /// **'Full stack i video game developer que ha fet aquesta aplicació web en el seu temps lliure per pura necessitat i amor als videojocs.'**
  String get aboutDeveloperBio;

  /// No description provided for @aboutDeveloperPortfolioLabel.
  ///
  /// In ca, this message translates to:
  /// **'Veure portfoli'**
  String get aboutDeveloperPortfolioLabel;

  /// No description provided for @aboutDeveloperPortfolioUrl.
  ///
  /// In ca, this message translates to:
  /// **'https://jordi110398.github.io/portfolio/'**
  String get aboutDeveloperPortfolioUrl;

  /// No description provided for @aboutDevelopmentTitle.
  ///
  /// In ca, this message translates to:
  /// **'Sobre el desenvolupament'**
  String get aboutDevelopmentTitle;

  /// No description provided for @aboutDevelopmentBody.
  ///
  /// In ca, this message translates to:
  /// **'Bona part del codi de GameShelf s\'ha escrit amb l\'ajuda d\'eines d\'intel·ligència artificial. La idea, el disseny i totes les decisions del projecte són originals: la IA hi ha ajudat a escriure\'l, però la intenció darrere de GameShelf és honesta i pensada de debò per als jugadors.'**
  String get aboutDevelopmentBody;

  /// No description provided for @aboutContactTitle.
  ///
  /// In ca, this message translates to:
  /// **'Contacte'**
  String get aboutContactTitle;

  /// No description provided for @aboutCatalogDataTitle.
  ///
  /// In ca, this message translates to:
  /// **'Dades del catàleg de jocs'**
  String get aboutCatalogDataTitle;

  /// No description provided for @aboutCatalogDataBody.
  ///
  /// In ca, this message translates to:
  /// **'La informació dels jocs (títols, portades, descripcions) prové d\'IGDB.'**
  String get aboutCatalogDataBody;

  /// No description provided for @aboutLegalDocumentsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Documents legals'**
  String get aboutLegalDocumentsTitle;

  /// No description provided for @installAppTitle.
  ///
  /// In ca, this message translates to:
  /// **'Instal·la l\'app'**
  String get installAppTitle;

  /// No description provided for @installAppSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix GameShelf a la pantalla d\'inici del teu mòbil'**
  String get installAppSubtitle;

  /// No description provided for @installAppDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Com instal·lar-la'**
  String get installAppDialogTitle;

  /// No description provided for @installAppDialogBody.
  ///
  /// In ca, this message translates to:
  /// **'A Safari (iPhone/iPad): toca la icona de Compartir i selecciona \"Afegeix a la pantalla d\'inici\".\n\nAl navegador de l\'ordinador o a Chrome/Edge per Android: busca la icona d\'instal·lar a la barra d\'adreces, o l\'opció \"Instal·la GameShelf\" al menú (⋮).'**
  String get installAppDialogBody;

  /// No description provided for @installAppAcceptedMessage.
  ///
  /// In ca, this message translates to:
  /// **'GameShelf s\'ha afegit a la teva pantalla d\'inici!'**
  String get installAppAcceptedMessage;

  /// No description provided for @llampAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Descobreix'**
  String get llampAppBarTitle;

  /// No description provided for @sectionRecommendations.
  ///
  /// In ca, this message translates to:
  /// **'Recomanacions per a tu'**
  String get sectionRecommendations;

  /// No description provided for @emptyRecommendationsNoFriends.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix amics per començar a rebre recomanacions personalitzades.'**
  String get emptyRecommendationsNoFriends;

  /// No description provided for @emptyRecommendationsNoData.
  ///
  /// In ca, this message translates to:
  /// **'Juga i valora alguns jocs perquè puguem recomanar-te\'n més.'**
  String get emptyRecommendationsNoData;

  /// No description provided for @sectionFriendsShelves.
  ///
  /// In ca, this message translates to:
  /// **'Estanteries dels teus amics'**
  String get sectionFriendsShelves;

  /// No description provided for @emptyFriendsShelves.
  ///
  /// In ca, this message translates to:
  /// **'Els teus amics encara no han publicat cap estanteria.'**
  String get emptyFriendsShelves;

  /// No description provided for @myShelvesAction.
  ///
  /// In ca, this message translates to:
  /// **'Les meves estanteries'**
  String get myShelvesAction;

  /// No description provided for @llampLoadFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar el llamp: '**
  String get llampLoadFailedPrefix;

  /// No description provided for @myShelvesTitle.
  ///
  /// In ca, this message translates to:
  /// **'Les meves estanteries'**
  String get myShelvesTitle;

  /// No description provided for @emptyMyShelves.
  ///
  /// In ca, this message translates to:
  /// **'Encara no has creat cap estanteria. Crea\'n una per organitzar els jocs que vulguis destacar.'**
  String get emptyMyShelves;

  /// No description provided for @newShelfAction.
  ///
  /// In ca, this message translates to:
  /// **'Nova estanteria'**
  String get newShelfAction;

  /// No description provided for @newShelfDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Nova estanteria'**
  String get newShelfDialogTitle;

  /// No description provided for @shelfTitleHint.
  ///
  /// In ca, this message translates to:
  /// **'Nom de l\'estanteria'**
  String get shelfTitleHint;

  /// No description provided for @pinnedBadge.
  ///
  /// In ca, this message translates to:
  /// **'Fixada al perfil'**
  String get pinnedBadge;

  /// No description provided for @publishedBadge.
  ///
  /// In ca, this message translates to:
  /// **'Publicada al llamp'**
  String get publishedBadge;

  /// No description provided for @deleteShelfTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar estanteria'**
  String get deleteShelfTitle;

  /// No description provided for @deleteShelfBody.
  ///
  /// In ca, this message translates to:
  /// **'Segur que vols eliminar l\'estanteria \"{title}\"? Aquesta acció no es pot desfer.'**
  String deleteShelfBody(String title);

  /// No description provided for @createShelfFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut crear l\'estanteria: '**
  String get createShelfFailedPrefix;

  /// No description provided for @deleteShelfFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut eliminar l\'estanteria: '**
  String get deleteShelfFailedPrefix;

  /// No description provided for @editShelfTitle.
  ///
  /// In ca, this message translates to:
  /// **'Editar estanteria'**
  String get editShelfTitle;

  /// No description provided for @pinToProfileTitle.
  ///
  /// In ca, this message translates to:
  /// **'Fixar al perfil'**
  String get pinToProfileTitle;

  /// No description provided for @pinToProfileSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Es mostrarà al teu perfil (només una alhora).'**
  String get pinToProfileSubtitle;

  /// No description provided for @publishToLlampTitle.
  ///
  /// In ca, this message translates to:
  /// **'Publicar al llamp'**
  String get publishToLlampTitle;

  /// No description provided for @publishToLlampSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Els teus amics la veuran a la pestanya de Descobreix.'**
  String get publishToLlampSubtitle;

  /// No description provided for @addGameAction.
  ///
  /// In ca, this message translates to:
  /// **'Afegir joc'**
  String get addGameAction;

  /// No description provided for @pickGameSheetTitle.
  ///
  /// In ca, this message translates to:
  /// **'Tria un joc de la teva biblioteca'**
  String get pickGameSheetTitle;

  /// No description provided for @shelfFullMessage.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta estanteria ja té 8 jocs.'**
  String get shelfFullMessage;

  /// No description provided for @emptyLibraryForShelf.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens cap joc a la biblioteca.'**
  String get emptyLibraryForShelf;

  /// No description provided for @allGamesAlreadyInShelf.
  ///
  /// In ca, this message translates to:
  /// **'Ja has afegit tots els jocs de la teva biblioteca a aquesta estanteria.'**
  String get allGamesAlreadyInShelf;

  /// No description provided for @renameFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut canviar el nom: '**
  String get renameFailedPrefix;

  /// No description provided for @pinFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut fixar l\'estanteria: '**
  String get pinFailedPrefix;

  /// No description provided for @unpinFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut desfixar l\'estanteria: '**
  String get unpinFailedPrefix;

  /// No description provided for @publishFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut publicar l\'estanteria: '**
  String get publishFailedPrefix;

  /// No description provided for @addGameFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut afegir el joc: '**
  String get addGameFailedPrefix;

  /// No description provided for @removeGameFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut treure el joc: '**
  String get removeGameFailedPrefix;

  /// No description provided for @notificationAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions'**
  String get notificationAppBarTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In ca, this message translates to:
  /// **'Marcar totes com a llegides'**
  String get markAllAsRead;

  /// No description provided for @emptyList.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens cap notificació.'**
  String get emptyList;

  /// No description provided for @notificationLoadFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar les notificacions: '**
  String get notificationLoadFailedPrefix;

  /// No description provided for @listFriendRequest.
  ///
  /// In ca, this message translates to:
  /// **'t\'ha enviat una sol·licitud d\'amistat'**
  String get listFriendRequest;

  /// No description provided for @listFriendAccepted.
  ///
  /// In ca, this message translates to:
  /// **'ha acceptat la teva sol·licitud d\'amistat'**
  String get listFriendAccepted;

  /// No description provided for @listActivityLikePrefix.
  ///
  /// In ca, this message translates to:
  /// **'li ha agradat la teva activitat sobre '**
  String get listActivityLikePrefix;

  /// No description provided for @listActivityLikeUnknownGame.
  ///
  /// In ca, this message translates to:
  /// **'un joc'**
  String get listActivityLikeUnknownGame;

  /// No description provided for @bannerFriendRequestSuffix.
  ///
  /// In ca, this message translates to:
  /// **'t\'ha enviat una sol·licitud d\'amistat'**
  String get bannerFriendRequestSuffix;

  /// No description provided for @bannerFriendAcceptedSuffix.
  ///
  /// In ca, this message translates to:
  /// **'ha acceptat la teva sol·licitud'**
  String get bannerFriendAcceptedSuffix;

  /// No description provided for @bannerActivityLikeSuffix.
  ///
  /// In ca, this message translates to:
  /// **'ha donat una estrella'**
  String get bannerActivityLikeSuffix;

  /// No description provided for @bannerActivityLikeGamePrefix.
  ///
  /// In ca, this message translates to:
  /// **' a '**
  String get bannerActivityLikeGamePrefix;

  /// No description provided for @profileLoadFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar el perfil: '**
  String get profileLoadFailedPrefix;

  /// No description provided for @sendRequestFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut enviar la sol·licitud: '**
  String get sendRequestFailedPrefix;

  /// No description provided for @acceptRequestFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut acceptar la sol·licitud: '**
  String get acceptRequestFailedPrefix;

  /// No description provided for @rejectRequestFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut rebutjar la sol·licitud: '**
  String get rejectRequestFailedPrefix;

  /// No description provided for @removeFriendFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut eliminar l\'amic: '**
  String get removeFriendFailedPrefix;

  /// No description provided for @removeFriendTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar amic?'**
  String get removeFriendTitle;

  /// No description provided for @removeFriendBody.
  ///
  /// In ca, this message translates to:
  /// **'Vols eliminar @{nickname} dels teus amics?'**
  String removeFriendBody(String nickname);

  /// No description provided for @editProfileTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Editar perfil'**
  String get editProfileTooltip;

  /// No description provided for @shareProfileTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Compartir perfil'**
  String get shareProfileTooltip;

  /// No description provided for @logoutTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Tancar sessió'**
  String get logoutTooltip;

  /// No description provided for @noReviewsYet.
  ///
  /// In ca, this message translates to:
  /// **'Encara no has escrit cap review.'**
  String get noReviewsYet;

  /// No description provided for @seeAllReviews.
  ///
  /// In ca, this message translates to:
  /// **'Veure totes les reviews ({count})'**
  String seeAllReviews(int count);

  /// No description provided for @statGames.
  ///
  /// In ca, this message translates to:
  /// **'Jocs'**
  String get statGames;

  /// No description provided for @statCompleted.
  ///
  /// In ca, this message translates to:
  /// **'Completats'**
  String get statCompleted;

  /// No description provided for @statReviews.
  ///
  /// In ca, this message translates to:
  /// **'Reviews'**
  String get statReviews;

  /// No description provided for @statHours.
  ///
  /// In ca, this message translates to:
  /// **'Hores'**
  String get statHours;

  /// No description provided for @myReviewsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Les meves reviews'**
  String get myReviewsTitle;

  /// No description provided for @completedTitle.
  ///
  /// In ca, this message translates to:
  /// **'Completats'**
  String get completedTitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In ca, this message translates to:
  /// **'Preferits'**
  String get favoritesTitle;

  /// No description provided for @gameshelfOf.
  ///
  /// In ca, this message translates to:
  /// **'{nickname}\'s GameShelf'**
  String gameshelfOf(String nickname);

  /// No description provided for @profileFilterLibrary.
  ///
  /// In ca, this message translates to:
  /// **'Library'**
  String get profileFilterLibrary;

  /// No description provided for @profileFilterDropped.
  ///
  /// In ca, this message translates to:
  /// **'Dropped'**
  String get profileFilterDropped;

  /// No description provided for @filterWantToPlay.
  ///
  /// In ca, this message translates to:
  /// **'Want to play'**
  String get filterWantToPlay;

  /// No description provided for @emptyGamesDropped.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té jocs abandonats.'**
  String get emptyGamesDropped;

  /// No description provided for @emptyGamesWantToPlay.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té jocs pendents.'**
  String get emptyGamesWantToPlay;

  /// No description provided for @emptyGamesPlaying.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té jocs en curs.'**
  String get emptyGamesPlaying;

  /// No description provided for @emptyGamesCompleted.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té jocs completats.'**
  String get emptyGamesCompleted;

  /// No description provided for @emptyGamesPaused.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té jocs pausats.'**
  String get emptyGamesPaused;

  /// No description provided for @emptyGamesAny.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari encara no té jocs.'**
  String get emptyGamesAny;

  /// No description provided for @editAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Editar perfil'**
  String get editAppBarTitle;

  /// No description provided for @changePhoto.
  ///
  /// In ca, this message translates to:
  /// **'Canviar foto'**
  String get changePhoto;

  /// No description provided for @cropAvatarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Ajusta la foto'**
  String get cropAvatarTitle;

  /// No description provided for @cropFailedMessage.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut retallar la imatge.'**
  String get cropFailedMessage;

  /// No description provided for @nicknameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @bioLabel.
  ///
  /// In ca, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// No description provided for @bioHint.
  ///
  /// In ca, this message translates to:
  /// **'Explica alguna cosa sobre tu...'**
  String get bioHint;

  /// No description provided for @emailLabel.
  ///
  /// In ca, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @saving.
  ///
  /// In ca, this message translates to:
  /// **'Guardant...'**
  String get saving;

  /// No description provided for @saveChanges.
  ///
  /// In ca, this message translates to:
  /// **'Guardar canvis'**
  String get saveChanges;

  /// No description provided for @informationTitle.
  ///
  /// In ca, this message translates to:
  /// **'Informació'**
  String get informationTitle;

  /// No description provided for @securityTitle.
  ///
  /// In ca, this message translates to:
  /// **'Seguretat'**
  String get securityTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In ca, this message translates to:
  /// **'Canviar contrasenya'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Actualitza la contrasenya del teu compte'**
  String get changePasswordSubtitle;

  /// No description provided for @dangerZoneTitle.
  ///
  /// In ca, this message translates to:
  /// **'Zona de perill'**
  String get dangerZoneTitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar compte'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Elimina permanentment el teu compte i les teves dades'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar compte?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogBody.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta acció és permanent. S\'eliminaran el teu perfil, biblioteca, reviews, amistats i activitat.'**
  String get deleteAccountDialogBody;

  /// No description provided for @deleteAccountFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut eliminar el compte: '**
  String get deleteAccountFailedPrefix;

  /// No description provided for @changePasswordDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Canviar contrasenya'**
  String get changePasswordDialogTitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nova contrasenya'**
  String get newPasswordLabel;

  /// No description provided for @repeatPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Repeteix la contrasenya'**
  String get repeatPasswordLabel;

  /// No description provided for @passwordRequirementsIntro.
  ///
  /// In ca, this message translates to:
  /// **'La contrasenya ha de tenir:'**
  String get passwordRequirementsIntro;

  /// No description provided for @reqMinLength.
  ///
  /// In ca, this message translates to:
  /// **'Almenys 8 caràcters'**
  String get reqMinLength;

  /// No description provided for @reqUppercase.
  ///
  /// In ca, this message translates to:
  /// **'Una lletra majúscula'**
  String get reqUppercase;

  /// No description provided for @reqLowercase.
  ///
  /// In ca, this message translates to:
  /// **'Una lletra minúscula'**
  String get reqLowercase;

  /// No description provided for @reqNumber.
  ///
  /// In ca, this message translates to:
  /// **'Un número'**
  String get reqNumber;

  /// No description provided for @reqSymbol.
  ///
  /// In ca, this message translates to:
  /// **'Un símbol'**
  String get reqSymbol;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In ca, this message translates to:
  /// **'Les contrasenyes no coincideixen.'**
  String get passwordsDontMatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya canviada correctament.'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut canviar la contrasenya: '**
  String get changePasswordFailedPrefix;

  /// No description provided for @changeAction.
  ///
  /// In ca, this message translates to:
  /// **'Canviar'**
  String get changeAction;

  /// No description provided for @shareAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Compartir perfil'**
  String get shareAppBarTitle;

  /// No description provided for @shareQrCaption.
  ///
  /// In ca, this message translates to:
  /// **'Escaneja per trobar-me a GameShelf'**
  String get shareQrCaption;

  /// No description provided for @shareDownloadAction.
  ///
  /// In ca, this message translates to:
  /// **'Descarregar imatge'**
  String get shareDownloadAction;

  /// No description provided for @shareDownloadedMessage.
  ///
  /// In ca, this message translates to:
  /// **'Imatge descarregada.'**
  String get shareDownloadedMessage;

  /// No description provided for @shareGenerateFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut generar la imatge: '**
  String get shareGenerateFailedPrefix;

  /// No description provided for @settingsTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Configuració'**
  String get settingsTooltip;

  /// No description provided for @settingsAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Configuració'**
  String get settingsAppBarTitle;

  /// No description provided for @settingsEditProfileSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Nickname, bio, foto, contrasenya i compte'**
  String get settingsEditProfileSubtitle;

  /// No description provided for @shelfStyleSectionTitle.
  ///
  /// In ca, this message translates to:
  /// **'Estètica'**
  String get shelfStyleSectionTitle;

  /// No description provided for @shelfStyleSectionSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'El color de la fusta defineix l\'aspecte de tota l\'app i de les teves estanteries.'**
  String get shelfStyleSectionSubtitle;

  /// No description provided for @shelfLightsLabel.
  ///
  /// In ca, this message translates to:
  /// **'Llums'**
  String get shelfLightsLabel;

  /// No description provided for @shelfLightsNeon.
  ///
  /// In ca, this message translates to:
  /// **'Neó'**
  String get shelfLightsNeon;

  /// No description provided for @shelfLightsBulbs.
  ///
  /// In ca, this message translates to:
  /// **'Bombetes'**
  String get shelfLightsBulbs;

  /// No description provided for @shelfWoodLabel.
  ///
  /// In ca, this message translates to:
  /// **'Color de la fusta'**
  String get shelfWoodLabel;

  /// No description provided for @shelfWoodWalnut.
  ///
  /// In ca, this message translates to:
  /// **'Noguera'**
  String get shelfWoodWalnut;

  /// No description provided for @shelfWoodOak.
  ///
  /// In ca, this message translates to:
  /// **'Roure'**
  String get shelfWoodOak;

  /// No description provided for @shelfWoodEbony.
  ///
  /// In ca, this message translates to:
  /// **'Banús'**
  String get shelfWoodEbony;

  /// No description provided for @shelfWoodCherry.
  ///
  /// In ca, this message translates to:
  /// **'Cirerer'**
  String get shelfWoodCherry;

  /// No description provided for @shelfWoodBirch.
  ///
  /// In ca, this message translates to:
  /// **'Bedoll'**
  String get shelfWoodBirch;

  /// No description provided for @shelfDecorationLabel.
  ///
  /// In ca, this message translates to:
  /// **'Decoració'**
  String get shelfDecorationLabel;

  /// No description provided for @shelfDecorationHint.
  ///
  /// In ca, this message translates to:
  /// **'Pots triar-ne més d\'una.'**
  String get shelfDecorationHint;

  /// No description provided for @shelfDecorationNone.
  ///
  /// In ca, this message translates to:
  /// **'Cap'**
  String get shelfDecorationNone;

  /// No description provided for @shelfDecorationPoppy.
  ///
  /// In ca, this message translates to:
  /// **'Rosella'**
  String get shelfDecorationPoppy;

  /// No description provided for @shelfDecorationCactus.
  ///
  /// In ca, this message translates to:
  /// **'Cactus'**
  String get shelfDecorationCactus;

  /// No description provided for @shelfDecorationAzalea.
  ///
  /// In ca, this message translates to:
  /// **'Azalea'**
  String get shelfDecorationAzalea;

  /// No description provided for @shelfCoverStyleLabel.
  ///
  /// In ca, this message translates to:
  /// **'Cobertes de joc'**
  String get shelfCoverStyleLabel;

  /// No description provided for @shelfCoverStylePlain.
  ///
  /// In ca, this message translates to:
  /// **'Planes'**
  String get shelfCoverStylePlain;

  /// No description provided for @shelfCoverStyleCartridge.
  ///
  /// In ca, this message translates to:
  /// **'Cartutx'**
  String get shelfCoverStyleCartridge;

  /// No description provided for @shelfStyleChangeFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut canviar l\'estètica: '**
  String get shelfStyleChangeFailedPrefix;

  /// No description provided for @languageSectionTitle.
  ///
  /// In ca, this message translates to:
  /// **'Idioma'**
  String get languageSectionTitle;

  /// No description provided for @languageCatalan.
  ///
  /// In ca, this message translates to:
  /// **'Català'**
  String get languageCatalan;

  /// No description provided for @languageSpanish.
  ///
  /// In ca, this message translates to:
  /// **'Castellà'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In ca, this message translates to:
  /// **'Anglès'**
  String get languageEnglish;

  /// No description provided for @languageChangeFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut canviar l\'idioma: '**
  String get languageChangeFailedPrefix;

  /// No description provided for @changePasswordPageTitle.
  ///
  /// In ca, this message translates to:
  /// **'Canviar contrasenya'**
  String get changePasswordPageTitle;

  /// No description provided for @fillAllFields.
  ///
  /// In ca, this message translates to:
  /// **'Omple tots els camps.'**
  String get fillAllFields;

  /// No description provided for @passwordMinLength6.
  ///
  /// In ca, this message translates to:
  /// **'La contrasenya ha de tenir almenys 6 caràcters.'**
  String get passwordMinLength6;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya actualitzada correctament.'**
  String get passwordUpdatedSuccess;

  /// No description provided for @newPasswordFieldLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nova contrasenya'**
  String get newPasswordFieldLabel;

  /// No description provided for @repeatPasswordFieldLabel.
  ///
  /// In ca, this message translates to:
  /// **'Repetir contrasenya'**
  String get repeatPasswordFieldLabel;

  /// No description provided for @updating.
  ///
  /// In ca, this message translates to:
  /// **'Actualitzant...'**
  String get updating;

  /// No description provided for @socialAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Social'**
  String get socialAppBarTitle;

  /// No description provided for @socialSearchHint.
  ///
  /// In ca, this message translates to:
  /// **'Buscar usuaris...'**
  String get socialSearchHint;

  /// No description provided for @searchUsersFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut buscar els usuaris: '**
  String get searchUsersFailedPrefix;

  /// No description provided for @loadSocialFailedPrefix.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar les dades socials: '**
  String get loadSocialFailedPrefix;

  /// No description provided for @emptyFriendsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens amics'**
  String get emptyFriendsTitle;

  /// No description provided for @emptyFriendsSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Busca altres usuaris de GameShelf per afegir-los.'**
  String get emptyFriendsSubtitle;

  /// No description provided for @emptySearchResults.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat usuaris'**
  String get emptySearchResults;

  /// No description provided for @sectionRequests.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licituds'**
  String get sectionRequests;

  /// No description provided for @sectionFriends.
  ///
  /// In ca, this message translates to:
  /// **'Amics'**
  String get sectionFriends;

  /// No description provided for @sectionActivitySummary.
  ///
  /// In ca, this message translates to:
  /// **'Resum activitats'**
  String get sectionActivitySummary;

  /// No description provided for @seeMore.
  ///
  /// In ca, this message translates to:
  /// **'Veure més'**
  String get seeMore;

  /// No description provided for @reviewOfPrefix.
  ///
  /// In ca, this message translates to:
  /// **'Review de '**
  String get reviewOfPrefix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
