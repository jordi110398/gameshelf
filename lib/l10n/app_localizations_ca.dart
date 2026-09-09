// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get okAction => 'D\'acord';

  @override
  String get profileLoadFailedGeneric => 'No s\'ha pogut carregar el perfil';

  @override
  String get monthJanuary => 'Gener';

  @override
  String get monthFebruary => 'Febrer';

  @override
  String get monthMarch => 'Març';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Maig';

  @override
  String get monthJune => 'Juny';

  @override
  String get monthJuly => 'Juliol';

  @override
  String get monthAugust => 'Agost';

  @override
  String get monthSeptember => 'Setembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Novembre';

  @override
  String get monthDecember => 'Desembre';

  @override
  String get gameStatusWantToPlay => 'Vull jugar-hi';

  @override
  String get gameStatusPlaying => 'Jugant';

  @override
  String get gameStatusCompleted => 'Completat';

  @override
  String get gameStatusDropped => 'Abandonat';

  @override
  String get gameStatusPaused => 'Pausat';

  @override
  String get platformNotSpecified => 'No especificat';

  @override
  String get errorInvalidCredentials => 'Email o contrasenya incorrectes.';

  @override
  String get errorEmailNotConfirmed =>
      'Has de confirmar el teu email abans d\'iniciar sessió.';

  @override
  String get errorEmailExists => 'Ja existeix un compte amb aquest email.';

  @override
  String get errorWeakPassword => 'La contrasenya és massa feble.';

  @override
  String get errorSamePassword =>
      'La nova contrasenya ha de ser diferent de l\'actual.';

  @override
  String get errorRateLimited =>
      'Has fet massa peticions seguides. Espera una mica i torna-ho a provar.';

  @override
  String get errorSignupDisabled =>
      'El registre no està disponible ara mateix.';

  @override
  String get errorSessionExpired =>
      'La teva sessió ha caducat. Torna a iniciar sessió.';

  @override
  String get errorDuplicateRecord =>
      'Ja existeix un registre amb aquestes dades.';

  @override
  String get errorMissingRequiredData => 'Falten dades obligatòries.';

  @override
  String get errorReferencedNotFound => 'L\'element referenciat no existeix.';

  @override
  String get errorPermissionDenied => 'No tens permís per fer aquesta acció.';

  @override
  String get errorOperationFailed =>
      'No s\'ha pogut completar l\'operació. Torna-ho a provar.';

  @override
  String get errorFileTooLarge => 'El fitxer és massa gran.';

  @override
  String get errorUploadFailed =>
      'No s\'ha pogut pujar el fitxer. Torna-ho a provar.';

  @override
  String get errorServerOperationFailed =>
      'No s\'ha pogut completar l\'operació al servidor.';

  @override
  String get errorUnexpected =>
      'Hi ha hagut un error inesperat. Torna-ho a provar.';

  @override
  String get errorNotAuthenticated => 'Usuari no autenticat.';

  @override
  String get errorCannotFriendSelf =>
      'No et pots enviar una sol·licitud a tu mateix.';

  @override
  String get errorFriendshipAlreadyExists =>
      'Ja existeix una relació amb aquest usuari.';

  @override
  String get errorDeleteAccountGeneric => 'No s\'ha pogut eliminar el compte.';

  @override
  String get errorSaveGameGeneric => 'No s\'ha pogut desar el joc.';

  @override
  String get actionStartedPlayingPrefix => 'està jugant a ';

  @override
  String get actionCompletedPrefix => 'ha completat ';

  @override
  String get actionDroppedPrefix => 'ha abandonat ';

  @override
  String get actionReviewPrefix => 'ha publicat una review de ';

  @override
  String get actionAddedToLibrarySuffix => ' a la seva biblioteca';

  @override
  String get actionAddedToLibraryVerb => 'ha afegit ';

  @override
  String get actionShelfPublishedPrefix => 'ha publicat l\'estanteria ';

  @override
  String get friendshipFormedConnector => 'i ';

  @override
  String get friendshipFormedSuffix => 'ara són amics! 🎉';

  @override
  String get friendshipFormedUnknownFriend => 'algú';

  @override
  String get reviewNotFound => 'No s\'ha pogut trobar la review.';

  @override
  String get reviewLoadFailedPrefix => 'No s\'ha pogut carregar la review: ';

  @override
  String get seeReview => 'Veure review';

  @override
  String get activityAppBarTitle => 'Activitat';

  @override
  String get emptyFeed => 'Encara no hi ha activitat.';

  @override
  String get newActivityAvailable => 'Hi ha activitat nova';

  @override
  String get activityLoadFailedPrefix =>
      'No s\'ha pogut carregar l\'activitat: ';

  @override
  String get loadMoreFailedPrefix =>
      'No s\'han pogut carregar més activitats: ';

  @override
  String get refreshFailedPrefix => 'No s\'ha pogut actualitzar l\'activitat: ';

  @override
  String get navHome => 'Inici';

  @override
  String get navLlamp => 'Descobreix';

  @override
  String get navSocial => 'Social';

  @override
  String get navProfile => 'Perfil';

  @override
  String get actionCancel => 'Cancel·lar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionAccept => 'Acceptar';

  @override
  String get actionReject => 'Rebutjar';

  @override
  String get actionLogout => 'Tancar sessió';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionSeeMore => 'Veure més';

  @override
  String get friendshipAdd => 'Afegir amic';

  @override
  String get friendshipRequestSent => 'Sol·licitud enviada';

  @override
  String get friendshipFriends => 'Amics';

  @override
  String get appName => 'GameShelf';

  @override
  String get passwordRequirementsTitle => 'La contrasenya ha de tenir:';

  @override
  String get passwordReqMinLength => 'Almenys 8 caràcters';

  @override
  String get passwordReqUppercase => 'Una lletra majúscula';

  @override
  String get passwordReqLowercase => 'Una lletra minúscula';

  @override
  String get passwordReqNumber => 'Un número';

  @override
  String get passwordReqSymbol => 'Un símbol';

  @override
  String get loginEmailOrNicknameLabel => 'Email o usuari';

  @override
  String get loginPasswordLabel => 'Contrasenya';

  @override
  String get loginForgotPassword => 'He oblidat la contrasenya';

  @override
  String get loginSubmit => 'Inicia sessió';

  @override
  String get loginCreateAccount => 'Crear compte';

  @override
  String get loginAboutLink => 'Sobre GameShelf';

  @override
  String get loginNoUserWithNickname =>
      'No s\'ha trobat cap usuari amb aquest nickname.';

  @override
  String get loginEnterEmailToReset =>
      'Introdueix el teu email per recuperar la contrasenya.';

  @override
  String get loginResetEmailSentTitle => 'Revisa el teu correu';

  @override
  String get loginResetEmailSentBody =>
      'T\'hem enviat un enllaç per restablir la contrasenya. Revisa la safata d\'entrada i també la carpeta de correu brossa.';

  @override
  String get loginResetEmailFailed => 'No s\'ha pogut enviar el correu';

  @override
  String get registerNicknameLabel => 'Nickname';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Contrasenya';

  @override
  String get registerEmptyFields => 'Omple tots els camps.';

  @override
  String get registerUserCreationFailed => 'No s\'ha pogut crear l\'usuari.';

  @override
  String get registerSubmit => 'Crear compte';

  @override
  String get registerAlreadyHaveAccount => 'Ja tens compte? Inicia sessió';

  @override
  String get registerLegalPrefix => 'En crear un compte, acceptes la ';

  @override
  String get registerLegalAnd => ' i la ';

  @override
  String get registerLegalSuffix => '.';

  @override
  String get forgotEnterEmail => 'Introdueix el teu email.';

  @override
  String get forgotEmailFailedPrefix => 'No s\'ha pogut enviar el correu: ';

  @override
  String get forgotTitle => 'Recuperar contrasenya';

  @override
  String get forgotBody =>
      'Introdueix el teu email i t\'enviarem un enllaç per crear una nova contrasenya.';

  @override
  String get forgotEmailLabel => 'Email';

  @override
  String get forgotSubmit => 'Enviar correu';

  @override
  String get forgotBackToLogin => 'Tornar al login';

  @override
  String get forgotSentTitle => 'Revisa el teu correu';

  @override
  String get forgotSentBody =>
      'T\'hem enviat un enllaç per restablir la teva contrasenya a:';

  @override
  String get resetAppBarTitle => 'Restablir contrasenya';

  @override
  String get resetTitle => 'Nova contrasenya';

  @override
  String get resetBody => 'Introdueix una nova contrasenya per al teu compte.';

  @override
  String get resetNewPasswordLabel => 'Nova contrasenya';

  @override
  String get resetConfirmPasswordLabel => 'Repeteix la contrasenya';

  @override
  String get resetPasswordMismatch => 'Les contrasenyes no coincideixen.';

  @override
  String get resetSubmit => 'Canviar contrasenya';

  @override
  String get resetBackToLogin => 'Tornar a iniciar sessió';

  @override
  String get resetLinkExpired =>
      'L\'enllaç de recuperació ha caducat. Torna a sol·licitar el canvi de contrasenya.';

  @override
  String get resetSuccessTitle => 'Contrasenya actualitzada';

  @override
  String get resetSuccessBody =>
      'La teva contrasenya s\'ha canviat correctament. Ara pots iniciar sessió amb la nova contrasenya.';

  @override
  String get resetSuccessButton => 'Iniciar sessió';

  @override
  String get resetFailedPrefix => 'No s\'ha pogut canviar la contrasenya: ';

  @override
  String get confirmEmailTitle => 'Confirma el teu email';

  @override
  String get confirmEmailSentTo => 'T\'hem enviat un correu de confirmació a:';

  @override
  String get confirmEmailInstructions =>
      'Obre el correu i fes clic a l\'enllaç per activar el teu compte.';

  @override
  String get confirmEmailBackToLogin => 'Tornar a iniciar sessió';

  @override
  String get callbackVerifying => 'Verificant el compte...';

  @override
  String get callbackFailedTitle => 'No s\'ha pogut verificar l\'enllaç.';

  @override
  String get callbackUnknownError => 'Error desconegut';

  @override
  String get callbackBackToLogin => 'Tornar al login';

  @override
  String get addToLibrarySheetTitle => 'Afegir a GameShelf';

  @override
  String get addToLibraryFailedPrefix =>
      'No s\'ha pogut afegir el joc a la biblioteca: ';

  @override
  String get igdbLabel => 'IGDB';

  @override
  String get myReviewTitle => 'La meva review';

  @override
  String get descriptionTitle => 'Descripció';

  @override
  String get editAction => 'Editar';

  @override
  String get addToLibraryAction => 'Afegir a la biblioteca';

  @override
  String get platformLabel => 'Plataforma';

  @override
  String get confirmDatesTitle => 'Quan?';

  @override
  String get confirmCompletedTitle => 'Joc completat';

  @override
  String get dateStartedLabel => 'Data d\'inici';

  @override
  String get dateCompletedLabel => 'Data de finalització';

  @override
  String get dateDroppedLabel => 'Data d\'abandonament';

  @override
  String get datePausedLabel => 'Data de pausa';

  @override
  String get dateResumedLabel => 'Data de represa';

  @override
  String get rateDialogTitle => 'Puntua aquest joc';

  @override
  String get rateFailedPrefix => 'No s\'ha pogut desar la puntuació: ';

  @override
  String editTitle(String gameTitle) {
    return 'Editar $gameTitle';
  }

  @override
  String get statusTitle => 'Estat';

  @override
  String get myRatingTitle => 'La meva valoració';

  @override
  String get markAsFavorite => 'Marcar com a preferit';

  @override
  String get hoursPlayedTitle => 'Hores jugades';

  @override
  String get hoursSuffix => 'hores';

  @override
  String get reviewHint => 'Escriu la teva opinió...';

  @override
  String get saveAction => 'Guardar';

  @override
  String get gameSearchHint => 'Buscar jocs...';

  @override
  String get searchEmptyPrompt => 'Busca un joc per començar';

  @override
  String get sortDateAdded => 'Data d\'addició';

  @override
  String get sortDatePlayed => 'Data que hi vas jugar';

  @override
  String get sortHoursPlayed => 'Hores jugades';

  @override
  String get sortStatus => 'Estat';

  @override
  String get sortTitle => 'Títol (A-Z)';

  @override
  String get sortTooltip => 'Ordenar';

  @override
  String get defaultNickname => 'GameShelf';

  @override
  String get titleSuffix => '\'s GameShelf';

  @override
  String get gamesCountSuffix => 'jocs';

  @override
  String get homeSearchHint => 'Buscar a la meva biblioteca...';

  @override
  String get searchCloseTooltip => 'Tancar cerca';

  @override
  String get homeFilterLibrary => 'Biblioteca';

  @override
  String get homeFilterDropped => 'Dropped';

  @override
  String get filterWishlist => 'Wishlist';

  @override
  String get emptyLibraryTitle => 'La teva biblioteca està buida';

  @override
  String get emptyLibrarySubtitle =>
      'Afegeix jocs i comença a construir la teva col·lecció.';

  @override
  String get emptyDroppedTitle => 'Cap joc abandonat';

  @override
  String get emptyDroppedSubtitle =>
      'Aquí apareixeran els jocs que decideixis deixar.';

  @override
  String get emptyWishlistTitle => 'No tens jocs pendents';

  @override
  String get emptyWishlistSubtitle =>
      'Afegeix jocs que vulguis jugar més endavant.';

  @override
  String get emptySearchTitle => 'No s\'han trobat jocs';

  @override
  String get emptySearchSubtitle => 'Prova amb un altre terme de cerca.';

  @override
  String get loadErrorPrefix => 'Error: ';

  @override
  String get deleteGameTitle => 'Eliminar joc';

  @override
  String get deleteGameBodyPrefix => 'Vols eliminar ';

  @override
  String get deleteGameBodySuffix => ' de la biblioteca?';

  @override
  String get addGameTooltip => 'Afegir joc';

  @override
  String get notificationsTooltip => 'Notificacions';

  @override
  String get favoriteAddedMessage => 'Afegit als preferits';

  @override
  String get favoriteRemovedMessage => 'Tret dels preferits';

  @override
  String get favoriteNotCompletedMessage =>
      'Només es poden marcar com a preferits els jocs completats';

  @override
  String get favoriteUpdateFailedPrefix =>
      'No s\'ha pogut actualitzar el preferit: ';

  @override
  String get favoriteConfirmAddBody =>
      'Vols afegir aquest joc als teus preferits?';

  @override
  String get favoriteConfirmRemoveBody =>
      'Vols treure aquest joc dels teus preferits?';

  @override
  String get favoriteConfirmAddAction => 'Afegir als preferits';

  @override
  String get favoriteConfirmRemoveAction => 'Treure dels preferits';

  @override
  String get contactEmail => 'contacte@gameshelfapp.net';

  @override
  String get lastUpdated => 'Última actualització: setembre de 2026.';

  @override
  String get privacyTitle => 'Política de privacitat';

  @override
  String get privacyIntro =>
      'Aquesta política explica quines dades personals recull GameShelf, amb quina finalitat i quins drets tens sobre elles, d\'acord amb el Reglament (UE) 2016/679 (RGPD) i la Llei Orgànica 3/2018 de Protecció de Dades i Garantia dels Drets Digitals (LOPDGDD).';

  @override
  String get privacySection1Title => '1. Responsable del tractament';

  @override
  String get privacySection1Body =>
      'Jordi Bertomeu Primo, com a titular i desenvolupador de GameShelf, és el responsable del tractament de les dades que es descriuen en aquesta política.\nContacte: contacte@gameshelfapp.net';

  @override
  String get privacySection2Title => '2. Quines dades recollim';

  @override
  String get privacySection2Bullet1 =>
      'Dades de registre: email i contrasenya (la contrasenya es guarda xifrada, mai en text pla).';

  @override
  String get privacySection2Bullet2 =>
      'Dades de perfil: nickname, biografia i foto de perfil.';

  @override
  String get privacySection2Bullet3 =>
      'Dades d\'ús del servei: la teva biblioteca de jocs, els estats (jugant, completat, etc.), valoracions, hores jugades i reviews que escriguis.';

  @override
  String get privacySection2Bullet4 =>
      'Dades socials: sol·licituds i relacions d\'amistat amb altres usuaris, i l\'activitat que es genera a partir de la teva biblioteca (per mostrar-la als teus amics).';

  @override
  String get privacySection3Title => '3. Amb quina finalitat les tractem';

  @override
  String get privacySection3Bullet1 =>
      'Per crear i gestionar el teu compte i permetre l\'ús de les funcionalitats de l\'aplicació (biblioteca, cerca de jocs, funcions socials).';

  @override
  String get privacySection3Bullet2 =>
      'Per enviar-te correus estrictament necessaris per al servei: confirmació de compte i recuperació de contrasenya.';

  @override
  String get privacySection3Body =>
      'La base legal per a aquests tractaments és l\'execució del contracte de servei que acceptes en crear un compte (art. 6.1.b RGPD).';

  @override
  String get privacySection4Title => '4. Amb qui compartim les dades';

  @override
  String get privacySection4Bullet1 =>
      'Supabase Inc., com a encarregat del tractament: allotja la base de dades, l\'autenticació i els fitxers (com les fotos de perfil) en servidors situats a la Unió Europea.';

  @override
  String get privacySection4Bullet2 =>
      'IGDB (propietat de Twitch/Amazon), com a proveïdor del catàleg de videojocs: només rep el text que introdueixes quan cerques un joc, mai dades personals del teu compte.';

  @override
  String get privacySection4Body =>
      'No compartim, venem ni cedim les teves dades a tercers amb finalitats publicitàries.';

  @override
  String get privacySection5Title => '5. Durant quant de temps les guardem';

  @override
  String get privacySection5Body =>
      'Mentre mantinguis el teu compte actiu. Pots eliminar permanentment el teu compte en qualsevol moment des de \"Editar perfil → Eliminar compte\"; en fer-ho, s\'esborren el teu perfil, biblioteca, amistats i activitat sense possibilitat de recuperació.';

  @override
  String get privacySection6Title => '6. Els teus drets';

  @override
  String get privacySection6Body1 =>
      'Tens dret a accedir, rectificar, suprimir, limitar o oposar-te al tractament de les teves dades, i a la seva portabilitat. Pots exercir la majoria d\'aquests drets directament des de l\'app (editar el teu perfil o eliminar el compte) o escrivint-nos a contacte@gameshelfapp.net.';

  @override
  String get privacySection6Body2 =>
      'També tens dret a presentar una reclamació davant l\'Agència Espanyola de Protecció de Dades (www.aepd.es) si consideres que el tractament de les teves dades no s\'ajusta a la normativa.';

  @override
  String get privacySection7Title => '7. Seguretat';

  @override
  String get privacySection7Body =>
      'Les connexions es fan xifrades (HTTPS) i la base de dades aplica regles d\'accés (Row Level Security) perquè cada usuari només pugui llegir i modificar les seves pròpies dades privades.';

  @override
  String get privacySection8Title => '8. Menors d\'edat';

  @override
  String get privacySection8Body =>
      'GameShelf no està dirigida a menors de 14 anys. No recollim conscientment dades de menors per sota d\'aquesta edat.';

  @override
  String get privacySection9Title => '9. Canvis a aquesta política';

  @override
  String get privacySection9Body =>
      'Podem actualitzar aquesta política per adaptar-la a canvis legals o del servei. T\'avisarem dins l\'aplicació si els canvis són rellevants.';

  @override
  String get cookiesTitle => 'Política de cookies';

  @override
  String get cookiesNoThirdPartyTitle =>
      'GameShelf no fa servir cookies de tercers';

  @override
  String get cookiesNoThirdPartyBody =>
      'GameShelf no utilitza cookies de publicitat, seguiment ni anàlisi (analytics) de cap tipus. No et rastregem entre webs ni compartim el teu comportament amb tercers amb finalitats comercials.';

  @override
  String get cookiesEssentialTitle => 'Emmagatzematge tècnic essencial';

  @override
  String get cookiesEssentialBody1 =>
      'Per mantenir la teva sessió iniciada, l\'aplicació guarda un testimoni de sessió (token d\'autenticació) a l\'emmagatzematge local del teu navegador, gestionat pel nostre proveïdor d\'autenticació (Supabase). Aquest emmagatzematge és estrictament necessari perquè l\'aplicació funcioni (no haver de tornar a iniciar sessió cada vegada) i no s\'utilitza amb cap altra finalitat.';

  @override
  String get cookiesEssentialBody2 =>
      'Com que es tracta d\'emmagatzematge tècnicament necessari i no de cookies de seguiment o publicitàries, l\'aplicació no mostra un bàner de consentiment de cookies.';

  @override
  String get cookiesFutureChangesTitle => 'Canvis futurs';

  @override
  String get cookiesFutureChangesBody =>
      'Si en el futur incorporéssim eines d\'anàlisi o publicitat que requereixin cookies no essencials, actualitzarem aquesta política i, si la normativa ho exigeix, et demanarem el teu consentiment abans d\'activar-les.';

  @override
  String get cookiesContactTitle => 'Contacte';

  @override
  String get cookiesContactBody =>
      'Si tens dubtes sobre aquesta política, escriu-nos a contacte@gameshelfapp.net.';

  @override
  String get aboutTitle => 'Sobre GameShelf';

  @override
  String get aboutAppName => 'GameShelf';

  @override
  String get aboutVersionLabel => 'Versió';

  @override
  String get aboutDescription =>
      'GameShelf és una aplicació social per als jugadors que permet fer seguiment de la teva biblioteca de videojocs: registra a què estàs jugant, marca els teus preferits, escriu reviews i comparteix la teva activitat amb amics, i descobreix nous videojocs.';

  @override
  String get aboutDeveloperTitle => 'Desenvolupador';

  @override
  String get aboutDeveloperName => 'Jordi Bertomeu Primo';

  @override
  String get aboutDeveloperBio =>
      'Full stack i video game developer que ha fet aquesta aplicació web en el seu temps lliure per pura necessitat i amor als videojocs.';

  @override
  String get aboutDeveloperPortfolioLabel => 'Veure portfoli';

  @override
  String get aboutDeveloperPortfolioUrl =>
      'https://jordi110398.github.io/portfolio/';

  @override
  String get aboutDevelopmentTitle => 'Sobre el desenvolupament';

  @override
  String get aboutDevelopmentBody =>
      'Bona part del codi de GameShelf s\'ha escrit amb l\'ajuda d\'eines d\'intel·ligència artificial. La idea, el disseny i totes les decisions del projecte són originals: la IA hi ha ajudat a escriure\'l, però la intenció darrere de GameShelf és honesta i pensada de debò per als jugadors.';

  @override
  String get aboutContactTitle => 'Contacte';

  @override
  String get aboutCatalogDataTitle => 'Dades del catàleg de jocs';

  @override
  String get aboutCatalogDataBody =>
      'La informació dels jocs (títols, portades, descripcions) prové d\'IGDB.';

  @override
  String get aboutLegalDocumentsTitle => 'Documents legals';

  @override
  String get installAppTitle => 'Instal·la l\'app';

  @override
  String get installAppSubtitle =>
      'Afegeix GameShelf a la pantalla d\'inici del teu mòbil';

  @override
  String get installAppDialogTitle => 'Com instal·lar-la';

  @override
  String get installAppDialogBody =>
      'A Safari (iPhone/iPad): toca la icona de Compartir i selecciona \"Afegeix a la pantalla d\'inici\".\n\nAl navegador de l\'ordinador o a Chrome/Edge per Android: busca la icona d\'instal·lar a la barra d\'adreces, o l\'opció \"Instal·la GameShelf\" al menú (⋮).';

  @override
  String get installAppAcceptedMessage =>
      'GameShelf s\'ha afegit a la teva pantalla d\'inici!';

  @override
  String get llampAppBarTitle => 'Descobreix';

  @override
  String get sectionRecommendations => 'Recomanacions per a tu';

  @override
  String get emptyRecommendationsNoFriends =>
      'Afegeix amics per començar a rebre recomanacions personalitzades.';

  @override
  String get emptyRecommendationsNoData =>
      'Juga i valora alguns jocs perquè puguem recomanar-te\'n més.';

  @override
  String get sectionFriendsShelves => 'Estanteries dels teus amics';

  @override
  String get emptyFriendsShelves =>
      'Els teus amics encara no han publicat cap estanteria.';

  @override
  String get myShelvesAction => 'Les meves estanteries';

  @override
  String get llampLoadFailedPrefix => 'No s\'ha pogut carregar el llamp: ';

  @override
  String get myShelvesTitle => 'Les meves estanteries';

  @override
  String get emptyMyShelves =>
      'Encara no has creat cap estanteria. Crea\'n una per organitzar els jocs que vulguis destacar.';

  @override
  String get newShelfAction => 'Nova estanteria';

  @override
  String get newShelfDialogTitle => 'Nova estanteria';

  @override
  String get shelfTitleHint => 'Nom de l\'estanteria';

  @override
  String get pinnedBadge => 'Fixada al perfil';

  @override
  String get publishedBadge => 'Publicada al llamp';

  @override
  String get deleteShelfTitle => 'Eliminar estanteria';

  @override
  String deleteShelfBody(String title) {
    return 'Segur que vols eliminar l\'estanteria \"$title\"? Aquesta acció no es pot desfer.';
  }

  @override
  String get createShelfFailedPrefix => 'No s\'ha pogut crear l\'estanteria: ';

  @override
  String get deleteShelfFailedPrefix =>
      'No s\'ha pogut eliminar l\'estanteria: ';

  @override
  String get editShelfTitle => 'Editar estanteria';

  @override
  String get pinToProfileTitle => 'Fixar al perfil';

  @override
  String get pinToProfileSubtitle =>
      'Es mostrarà al teu perfil (només una alhora).';

  @override
  String get publishToLlampTitle => 'Publicar al llamp';

  @override
  String get publishToLlampSubtitle =>
      'Els teus amics la veuran a la pestanya de Descobreix.';

  @override
  String get addGameAction => 'Afegir joc';

  @override
  String get pickGameSheetTitle => 'Tria un joc de la teva biblioteca';

  @override
  String get shelfFullMessage => 'Aquesta estanteria ja té 8 jocs.';

  @override
  String get emptyLibraryForShelf => 'Encara no tens cap joc a la biblioteca.';

  @override
  String get allGamesAlreadyInShelf =>
      'Ja has afegit tots els jocs de la teva biblioteca a aquesta estanteria.';

  @override
  String get renameFailedPrefix => 'No s\'ha pogut canviar el nom: ';

  @override
  String get pinFailedPrefix => 'No s\'ha pogut fixar l\'estanteria: ';

  @override
  String get unpinFailedPrefix => 'No s\'ha pogut desfixar l\'estanteria: ';

  @override
  String get publishFailedPrefix => 'No s\'ha pogut publicar l\'estanteria: ';

  @override
  String get addGameFailedPrefix => 'No s\'ha pogut afegir el joc: ';

  @override
  String get removeGameFailedPrefix => 'No s\'ha pogut treure el joc: ';

  @override
  String get notificationAppBarTitle => 'Notificacions';

  @override
  String get markAllAsRead => 'Marcar totes com a llegides';

  @override
  String get emptyList => 'Encara no tens cap notificació.';

  @override
  String get notificationLoadFailedPrefix =>
      'No s\'han pogut carregar les notificacions: ';

  @override
  String get listFriendRequest => 't\'ha enviat una sol·licitud d\'amistat';

  @override
  String get listFriendAccepted => 'ha acceptat la teva sol·licitud d\'amistat';

  @override
  String get listActivityLikePrefix => 'li ha agradat la teva activitat sobre ';

  @override
  String get listActivityLikeUnknownGame => 'un joc';

  @override
  String get bannerFriendRequestSuffix =>
      't\'ha enviat una sol·licitud d\'amistat';

  @override
  String get bannerFriendAcceptedSuffix => 'ha acceptat la teva sol·licitud';

  @override
  String get bannerActivityLikeSuffix => 'ha donat una estrella';

  @override
  String get bannerActivityLikeGamePrefix => ' a ';

  @override
  String get profileLoadFailedPrefix => 'No s\'ha pogut carregar el perfil: ';

  @override
  String get sendRequestFailedPrefix =>
      'No s\'ha pogut enviar la sol·licitud: ';

  @override
  String get acceptRequestFailedPrefix =>
      'No s\'ha pogut acceptar la sol·licitud: ';

  @override
  String get rejectRequestFailedPrefix =>
      'No s\'ha pogut rebutjar la sol·licitud: ';

  @override
  String get removeFriendFailedPrefix => 'No s\'ha pogut eliminar l\'amic: ';

  @override
  String get removeFriendTitle => 'Eliminar amic?';

  @override
  String removeFriendBody(String nickname) {
    return 'Vols eliminar @$nickname dels teus amics?';
  }

  @override
  String get editProfileTooltip => 'Editar perfil';

  @override
  String get shareProfileTooltip => 'Compartir perfil';

  @override
  String get logoutTooltip => 'Tancar sessió';

  @override
  String get noReviewsYet => 'Encara no has escrit cap review.';

  @override
  String seeAllReviews(int count) {
    return 'Veure totes les reviews ($count)';
  }

  @override
  String get statGames => 'Jocs';

  @override
  String get statCompleted => 'Completats';

  @override
  String get statReviews => 'Reviews';

  @override
  String get statHours => 'Hores';

  @override
  String get myReviewsTitle => 'Les meves reviews';

  @override
  String get completedTitle => 'Completats';

  @override
  String get favoritesTitle => 'Preferits';

  @override
  String gameshelfOf(String nickname) {
    return '$nickname\'s GameShelf';
  }

  @override
  String get profileFilterLibrary => 'Library';

  @override
  String get profileFilterDropped => 'Dropped';

  @override
  String get filterWantToPlay => 'Want to play';

  @override
  String get emptyGamesDropped => 'Aquest usuari no té jocs abandonats.';

  @override
  String get emptyGamesWantToPlay => 'Aquest usuari no té jocs pendents.';

  @override
  String get emptyGamesPlaying => 'Aquest usuari no té jocs en curs.';

  @override
  String get emptyGamesCompleted => 'Aquest usuari no té jocs completats.';

  @override
  String get emptyGamesPaused => 'Aquest usuari no té jocs pausats.';

  @override
  String get emptyGamesAny => 'Aquest usuari encara no té jocs.';

  @override
  String get editAppBarTitle => 'Editar perfil';

  @override
  String get changePhoto => 'Canviar foto';

  @override
  String get cropAvatarTitle => 'Ajusta la foto';

  @override
  String get cropFailedMessage => 'No s\'ha pogut retallar la imatge.';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Explica alguna cosa sobre tu...';

  @override
  String get emailLabel => 'Email';

  @override
  String get saving => 'Guardant...';

  @override
  String get saveChanges => 'Guardar canvis';

  @override
  String get informationTitle => 'Informació';

  @override
  String get securityTitle => 'Seguretat';

  @override
  String get changePasswordTitle => 'Canviar contrasenya';

  @override
  String get changePasswordSubtitle =>
      'Actualitza la contrasenya del teu compte';

  @override
  String get dangerZoneTitle => 'Zona de perill';

  @override
  String get deleteAccountTitle => 'Eliminar compte';

  @override
  String get deleteAccountSubtitle =>
      'Elimina permanentment el teu compte i les teves dades';

  @override
  String get deleteAccountDialogTitle => 'Eliminar compte?';

  @override
  String get deleteAccountDialogBody =>
      'Aquesta acció és permanent. S\'eliminaran el teu perfil, biblioteca, reviews, amistats i activitat.';

  @override
  String get deleteAccountFailedPrefix => 'No s\'ha pogut eliminar el compte: ';

  @override
  String get changePasswordDialogTitle => 'Canviar contrasenya';

  @override
  String get newPasswordLabel => 'Nova contrasenya';

  @override
  String get repeatPasswordLabel => 'Repeteix la contrasenya';

  @override
  String get passwordRequirementsIntro => 'La contrasenya ha de tenir:';

  @override
  String get reqMinLength => 'Almenys 8 caràcters';

  @override
  String get reqUppercase => 'Una lletra majúscula';

  @override
  String get reqLowercase => 'Una lletra minúscula';

  @override
  String get reqNumber => 'Un número';

  @override
  String get reqSymbol => 'Un símbol';

  @override
  String get passwordsDontMatch => 'Les contrasenyes no coincideixen.';

  @override
  String get changePasswordSuccess => 'Contrasenya canviada correctament.';

  @override
  String get changePasswordFailedPrefix =>
      'No s\'ha pogut canviar la contrasenya: ';

  @override
  String get changeAction => 'Canviar';

  @override
  String get shareAppBarTitle => 'Compartir perfil';

  @override
  String get shareQrCaption => 'Escaneja per trobar-me a GameShelf';

  @override
  String get shareDownloadAction => 'Descarregar imatge';

  @override
  String get shareDownloadedMessage => 'Imatge descarregada.';

  @override
  String get shareGenerateFailedPrefix => 'No s\'ha pogut generar la imatge: ';

  @override
  String get settingsTooltip => 'Configuració';

  @override
  String get settingsAppBarTitle => 'Configuració';

  @override
  String get settingsEditProfileSubtitle =>
      'Nickname, bio, foto, contrasenya i compte';

  @override
  String get shelfStyleSectionTitle => 'Estètica';

  @override
  String get shelfStyleSectionSubtitle =>
      'El color de la fusta defineix l\'aspecte de tota l\'app i de les teves estanteries.';

  @override
  String get shelfLightsLabel => 'Llums';

  @override
  String get shelfLightsNeon => 'Neó';

  @override
  String get shelfLightsBulbs => 'Bombetes';

  @override
  String get shelfWoodLabel => 'Color de la fusta';

  @override
  String get shelfWoodWalnut => 'Noguera';

  @override
  String get shelfWoodOak => 'Roure';

  @override
  String get shelfWoodEbony => 'Banús';

  @override
  String get shelfWoodCherry => 'Cirerer';

  @override
  String get shelfWoodBirch => 'Bedoll';

  @override
  String get shelfDecorationLabel => 'Decoració';

  @override
  String get shelfDecorationHint => 'Pots triar-ne més d\'una.';

  @override
  String get shelfDecorationNone => 'Cap';

  @override
  String get shelfDecorationPoppy => 'Rosella';

  @override
  String get shelfDecorationCactus => 'Cactus';

  @override
  String get shelfDecorationAzalea => 'Azalea';

  @override
  String get shelfCoverStyleLabel => 'Cobertes de joc';

  @override
  String get shelfCoverStylePlain => 'Planes';

  @override
  String get shelfCoverStyleCartridge => 'Cartutx';

  @override
  String get shelfStyleChangeFailedPrefix =>
      'No s\'ha pogut canviar l\'estètica: ';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get languageCatalan => 'Català';

  @override
  String get languageSpanish => 'Castellà';

  @override
  String get languageEnglish => 'Anglès';

  @override
  String get languageChangeFailedPrefix => 'No s\'ha pogut canviar l\'idioma: ';

  @override
  String get changePasswordPageTitle => 'Canviar contrasenya';

  @override
  String get fillAllFields => 'Omple tots els camps.';

  @override
  String get passwordMinLength6 =>
      'La contrasenya ha de tenir almenys 6 caràcters.';

  @override
  String get passwordUpdatedSuccess => 'Contrasenya actualitzada correctament.';

  @override
  String get newPasswordFieldLabel => 'Nova contrasenya';

  @override
  String get repeatPasswordFieldLabel => 'Repetir contrasenya';

  @override
  String get updating => 'Actualitzant...';

  @override
  String get socialAppBarTitle => 'Social';

  @override
  String get socialSearchHint => 'Buscar usuaris...';

  @override
  String get searchUsersFailedPrefix => 'No s\'han pogut buscar els usuaris: ';

  @override
  String get loadSocialFailedPrefix =>
      'No s\'han pogut carregar les dades socials: ';

  @override
  String get emptyFriendsTitle => 'Encara no tens amics';

  @override
  String get emptyFriendsSubtitle =>
      'Busca altres usuaris de GameShelf per afegir-los.';

  @override
  String get emptySearchResults => 'No s\'han trobat usuaris';

  @override
  String get sectionRequests => 'Sol·licituds';

  @override
  String get sectionFriends => 'Amics';

  @override
  String get sectionActivitySummary => 'Resum activitats';

  @override
  String get seeMore => 'Veure més';

  @override
  String get reviewOfPrefix => 'Review de ';
}
