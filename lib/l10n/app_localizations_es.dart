// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get okAction => 'De acuerdo';

  @override
  String get profileLoadFailedGeneric => 'No se ha podido cargar el perfil';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get gameStatusWantToPlay => 'Quiero jugarlo';

  @override
  String get gameStatusPlaying => 'Jugando';

  @override
  String get gameStatusCompleted => 'Completado';

  @override
  String get gameStatusDropped => 'Abandonado';

  @override
  String get gameStatusPaused => 'Pausado';

  @override
  String get platformNotSpecified => 'No especificado';

  @override
  String get errorInvalidCredentials => 'Email o contraseña incorrectos.';

  @override
  String get errorEmailNotConfirmed =>
      'Debes confirmar tu email antes de iniciar sesión.';

  @override
  String get errorEmailExists => 'Ya existe una cuenta con este email.';

  @override
  String get errorWeakPassword => 'La contraseña es demasiado débil.';

  @override
  String get errorSamePassword =>
      'La nueva contraseña debe ser diferente de la actual.';

  @override
  String get errorRateLimited =>
      'Has hecho demasiadas peticiones seguidas. Espera un momento e inténtalo de nuevo.';

  @override
  String get errorSignupDisabled =>
      'El registro no está disponible en este momento.';

  @override
  String get errorSessionExpired =>
      'Tu sesión ha caducado. Vuelve a iniciar sesión.';

  @override
  String get errorDuplicateRecord => 'Ya existe un registro con estos datos.';

  @override
  String get errorMissingRequiredData => 'Faltan datos obligatorios.';

  @override
  String get errorReferencedNotFound => 'El elemento referenciado no existe.';

  @override
  String get errorPermissionDenied =>
      'No tienes permiso para hacer esta acción.';

  @override
  String get errorOperationFailed =>
      'No se ha podido completar la operación. Inténtalo de nuevo.';

  @override
  String get errorFileTooLarge => 'El archivo es demasiado grande.';

  @override
  String get errorUploadFailed =>
      'No se ha podido subir el archivo. Inténtalo de nuevo.';

  @override
  String get errorServerOperationFailed =>
      'No se ha podido completar la operación en el servidor.';

  @override
  String get errorUnexpected =>
      'Ha ocurrido un error inesperado. Inténtalo de nuevo.';

  @override
  String get errorNotAuthenticated => 'Usuario no autenticado.';

  @override
  String get errorCannotFriendSelf =>
      'No puedes enviarte una solicitud a ti mismo.';

  @override
  String get errorFriendshipAlreadyExists =>
      'Ya existe una relación con este usuario.';

  @override
  String get errorDeleteAccountGeneric => 'No se ha podido eliminar la cuenta.';

  @override
  String get errorSaveGameGeneric => 'No se ha podido guardar el juego.';

  @override
  String get actionStartedPlayingPrefix => 'está jugando a ';

  @override
  String get actionCompletedPrefix => 'ha completado ';

  @override
  String get actionDroppedPrefix => 'ha abandonado ';

  @override
  String get actionReviewPrefix => 'ha publicado una review de ';

  @override
  String get actionAddedToLibrarySuffix => ' a su biblioteca';

  @override
  String get actionAddedToLibraryVerb => 'ha añadido ';

  @override
  String get actionShelfPublishedPrefix => 'ha publicado la estantería ';

  @override
  String get friendshipFormedConnector => 'y ';

  @override
  String get friendshipFormedSuffix => 'ahora son amigos! 🎉';

  @override
  String get friendshipFormedUnknownFriend => 'alguien';

  @override
  String get reviewNotFound => 'No se ha podido encontrar la review.';

  @override
  String get reviewLoadFailedPrefix => 'No se ha podido cargar la review: ';

  @override
  String get seeReview => 'Ver review';

  @override
  String get activityAppBarTitle => 'Actividad';

  @override
  String get emptyFeed => 'Todavía no hay actividad.';

  @override
  String get newActivityAvailable => 'Hay actividad nueva';

  @override
  String get activityLoadFailedPrefix =>
      'No se ha podido cargar la actividad: ';

  @override
  String get loadMoreFailedPrefix =>
      'No se han podido cargar más actividades: ';

  @override
  String get refreshFailedPrefix => 'No se ha podido actualizar la actividad: ';

  @override
  String get navHome => 'Inicio';

  @override
  String get navLlamp => 'Descubre';

  @override
  String get navSocial => 'Social';

  @override
  String get navProfile => 'Perfil';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionAccept => 'Aceptar';

  @override
  String get actionReject => 'Rechazar';

  @override
  String get actionLogout => 'Cerrar sesión';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionSeeMore => 'Ver más';

  @override
  String get friendshipAdd => 'Añadir amigo';

  @override
  String get friendshipRequestSent => 'Solicitud enviada';

  @override
  String get friendshipFriends => 'Amigos';

  @override
  String get appName => 'GameShelf';

  @override
  String get passwordRequirementsTitle => 'La contraseña debe tener:';

  @override
  String get passwordReqMinLength => 'Al menos 8 caracteres';

  @override
  String get passwordReqUppercase => 'Una letra mayúscula';

  @override
  String get passwordReqLowercase => 'Una letra minúscula';

  @override
  String get passwordReqNumber => 'Un número';

  @override
  String get passwordReqSymbol => 'Un símbolo';

  @override
  String get loginEmailOrNicknameLabel => 'Email o usuario';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginForgotPassword => 'He olvidado la contraseña';

  @override
  String get loginSubmit => 'Iniciar sesión';

  @override
  String get loginCreateAccount => 'Crear cuenta';

  @override
  String get loginAboutLink => 'Sobre GameShelf';

  @override
  String get loginNoUserWithNickname =>
      'No se ha encontrado ningún usuario con ese nickname.';

  @override
  String get loginEnterEmailToReset =>
      'Introduce tu email para recuperar la contraseña.';

  @override
  String get loginResetEmailSentTitle => 'Revisa tu correo';

  @override
  String get loginResetEmailSentBody =>
      'Te hemos enviado un enlace para restablecer la contraseña. Revisa la bandeja de entrada y también la carpeta de spam.';

  @override
  String get loginResetEmailFailed => 'No se ha podido enviar el correo';

  @override
  String get registerNicknameLabel => 'Nickname';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerEmptyFields => 'Rellena todos los campos.';

  @override
  String get registerUserCreationFailed => 'No se ha podido crear el usuario.';

  @override
  String get registerSubmit => 'Crear cuenta';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get registerLegalPrefix => 'Al crear una cuenta, aceptas la ';

  @override
  String get registerLegalAnd => ' y la ';

  @override
  String get registerLegalSuffix => '.';

  @override
  String get forgotEnterEmail => 'Introduce tu email.';

  @override
  String get forgotEmailFailedPrefix => 'No se ha podido enviar el correo: ';

  @override
  String get forgotTitle => 'Recuperar contraseña';

  @override
  String get forgotBody =>
      'Introduce tu email y te enviaremos un enlace para crear una nueva contraseña.';

  @override
  String get forgotEmailLabel => 'Email';

  @override
  String get forgotSubmit => 'Enviar correo';

  @override
  String get forgotBackToLogin => 'Volver al login';

  @override
  String get forgotSentTitle => 'Revisa tu correo';

  @override
  String get forgotSentBody =>
      'Te hemos enviado un enlace para restablecer tu contraseña a:';

  @override
  String get resetAppBarTitle => 'Restablecer contraseña';

  @override
  String get resetTitle => 'Nueva contraseña';

  @override
  String get resetBody => 'Introduce una nueva contraseña para tu cuenta.';

  @override
  String get resetNewPasswordLabel => 'Nueva contraseña';

  @override
  String get resetConfirmPasswordLabel => 'Repite la contraseña';

  @override
  String get resetPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get resetSubmit => 'Cambiar contraseña';

  @override
  String get resetBackToLogin => 'Volver a iniciar sesión';

  @override
  String get resetLinkExpired =>
      'El enlace de recuperación ha caducado. Vuelve a solicitar el cambio de contraseña.';

  @override
  String get resetSuccessTitle => 'Contraseña actualizada';

  @override
  String get resetSuccessBody =>
      'Tu contraseña se ha cambiado correctamente. Ahora puedes iniciar sesión con la nueva contraseña.';

  @override
  String get resetSuccessButton => 'Iniciar sesión';

  @override
  String get resetFailedPrefix => 'No se ha podido cambiar la contraseña: ';

  @override
  String get confirmEmailTitle => 'Confirma tu email';

  @override
  String get confirmEmailSentTo =>
      'Te hemos enviado un correo de confirmación a:';

  @override
  String get confirmEmailInstructions =>
      'Abre el correo y haz clic en el enlace para activar tu cuenta.';

  @override
  String get confirmEmailBackToLogin => 'Volver a iniciar sesión';

  @override
  String get callbackVerifying => 'Verificando la cuenta...';

  @override
  String get callbackFailedTitle => 'No se ha podido verificar el enlace.';

  @override
  String get callbackUnknownError => 'Error desconocido';

  @override
  String get callbackBackToLogin => 'Volver al login';

  @override
  String get addToLibrarySheetTitle => 'Añadir a GameShelf';

  @override
  String get addToLibraryFailedPrefix =>
      'No se ha podido añadir el juego a la biblioteca: ';

  @override
  String get igdbLabel => 'IGDB';

  @override
  String get myReviewTitle => 'Mi review';

  @override
  String get descriptionTitle => 'Descripción';

  @override
  String get editAction => 'Editar';

  @override
  String get addToLibraryAction => 'Añadir a la biblioteca';

  @override
  String get platformLabel => 'Plataforma';

  @override
  String get confirmDatesTitle => '¿Cuándo?';

  @override
  String get confirmCompletedTitle => 'Juego completado';

  @override
  String get dateStartedLabel => 'Fecha de inicio';

  @override
  String get dateCompletedLabel => 'Fecha de finalización';

  @override
  String get dateDroppedLabel => 'Fecha de abandono';

  @override
  String get datePausedLabel => 'Fecha de pausa';

  @override
  String get dateResumedLabel => 'Fecha de reanudación';

  @override
  String get rateDialogTitle => 'Puntúa este juego';

  @override
  String get rateFailedPrefix => 'No se ha podido guardar la puntuación: ';

  @override
  String editTitle(String gameTitle) {
    return 'Editar $gameTitle';
  }

  @override
  String get statusTitle => 'Estado';

  @override
  String get myRatingTitle => 'Mi valoración';

  @override
  String get markAsFavorite => 'Marcar como favorito';

  @override
  String get hoursPlayedTitle => 'Horas jugadas';

  @override
  String get hoursSuffix => 'horas';

  @override
  String get reviewHint => 'Escribe tu opinión...';

  @override
  String get saveAction => 'Guardar';

  @override
  String get gameSearchHint => 'Buscar juegos...';

  @override
  String get searchEmptyPrompt => 'Busca un juego para empezar';

  @override
  String get sortDateAdded => 'Fecha de adición';

  @override
  String get sortDatePlayed => 'Fecha en que jugaste';

  @override
  String get sortHoursPlayed => 'Horas jugadas';

  @override
  String get sortStatus => 'Estado';

  @override
  String get sortTitle => 'Título (A-Z)';

  @override
  String get sortTooltip => 'Ordenar';

  @override
  String get defaultNickname => 'GameShelf';

  @override
  String get titleSuffix => '\'s GameShelf';

  @override
  String get gamesCountSuffix => 'juegos';

  @override
  String get homeSearchHint => 'Buscar en mi biblioteca...';

  @override
  String get searchCloseTooltip => 'Cerrar búsqueda';

  @override
  String get homeFilterLibrary => 'Biblioteca';

  @override
  String get homeFilterDropped => 'Dropped';

  @override
  String get filterWishlist => 'Wishlist';

  @override
  String get emptyLibraryTitle => 'Tu biblioteca está vacía';

  @override
  String get emptyLibrarySubtitle =>
      'Añade juegos y empieza a construir tu colección.';

  @override
  String get emptyDroppedTitle => 'Ningún juego abandonado';

  @override
  String get emptyDroppedSubtitle =>
      'Aquí aparecerán los juegos que decidas dejar.';

  @override
  String get emptyWishlistTitle => 'No tienes juegos pendientes';

  @override
  String get emptyWishlistSubtitle =>
      'Añade juegos que quieras jugar más adelante.';

  @override
  String get emptySearchTitle => 'No se han encontrado juegos';

  @override
  String get emptySearchSubtitle => 'Prueba con otro término de búsqueda.';

  @override
  String get loadErrorPrefix => 'Error: ';

  @override
  String get deleteGameTitle => 'Eliminar juego';

  @override
  String get deleteGameBodyPrefix => '¿Quieres eliminar ';

  @override
  String get deleteGameBodySuffix => ' de la biblioteca?';

  @override
  String get addGameTooltip => 'Añadir juego';

  @override
  String get notificationsTooltip => 'Notificaciones';

  @override
  String get favoriteAddedMessage => 'Añadido a favoritos';

  @override
  String get favoriteRemovedMessage => 'Quitado de favoritos';

  @override
  String get favoriteNotCompletedMessage =>
      'Solo se pueden marcar como favoritos los juegos completados';

  @override
  String get favoriteUpdateFailedPrefix =>
      'No se ha podido actualizar el favorito: ';

  @override
  String get favoriteConfirmAddBody =>
      '¿Quieres añadir este juego a tus favoritos?';

  @override
  String get favoriteConfirmRemoveBody =>
      '¿Quieres quitar este juego de tus favoritos?';

  @override
  String get favoriteConfirmAddAction => 'Añadir a favoritos';

  @override
  String get favoriteConfirmRemoveAction => 'Quitar de favoritos';

  @override
  String get contactEmail => 'contacte@gameshelfapp.net';

  @override
  String get lastUpdated => 'Última actualización: septiembre de 2026.';

  @override
  String get privacyTitle => 'Política de privacidad';

  @override
  String get privacyIntro =>
      'Esta política explica qué datos personales recoge GameShelf, con qué finalidad y qué derechos tienes sobre ellos, de acuerdo con el Reglamento (UE) 2016/679 (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos y Garantía de los Derechos Digitales (LOPDGDD).';

  @override
  String get privacySection1Title => '1. Responsable del tratamiento';

  @override
  String get privacySection1Body =>
      'Jordi Bertomeu Primo, como titular y desarrollador de GameShelf, es el responsable del tratamiento de los datos que se describen en esta política.\nContacto: contacte@gameshelfapp.net';

  @override
  String get privacySection2Title => '2. Qué datos recogemos';

  @override
  String get privacySection2Bullet1 =>
      'Datos de registro: email y contraseña (la contraseña se guarda cifrada, nunca en texto plano).';

  @override
  String get privacySection2Bullet2 =>
      'Datos de perfil: nickname, biografía y foto de perfil.';

  @override
  String get privacySection2Bullet3 =>
      'Datos de uso del servicio: tu biblioteca de juegos, los estados (jugando, completado, etc.), valoraciones, horas jugadas y reviews que escribas.';

  @override
  String get privacySection2Bullet4 =>
      'Datos sociales: solicitudes y relaciones de amistad con otros usuarios, y la actividad que se genera a partir de tu biblioteca (para mostrarla a tus amigos).';

  @override
  String get privacySection3Title => '3. Con qué finalidad los tratamos';

  @override
  String get privacySection3Bullet1 =>
      'Para crear y gestionar tu cuenta y permitir el uso de las funcionalidades de la aplicación (biblioteca, búsqueda de juegos, funciones sociales).';

  @override
  String get privacySection3Bullet2 =>
      'Para enviarte correos estrictamente necesarios para el servicio: confirmación de cuenta y recuperación de contraseña.';

  @override
  String get privacySection3Body =>
      'La base legal para estos tratamientos es la ejecución del contrato de servicio que aceptas al crear una cuenta (art. 6.1.b RGPD).';

  @override
  String get privacySection4Title => '4. Con quién compartimos los datos';

  @override
  String get privacySection4Bullet1 =>
      'Supabase Inc., como encargado del tratamiento: aloja la base de datos, la autenticación y los archivos (como las fotos de perfil) en servidores situados en la Unión Europea.';

  @override
  String get privacySection4Bullet2 =>
      'IGDB (propiedad de Twitch/Amazon), como proveedor del catálogo de videojuegos: solo recibe el texto que introduces al buscar un juego, nunca datos personales de tu cuenta.';

  @override
  String get privacySection4Body =>
      'No compartimos, vendemos ni cedemos tus datos a terceros con fines publicitarios.';

  @override
  String get privacySection5Title => '5. Durante cuánto tiempo los guardamos';

  @override
  String get privacySection5Body =>
      'Mientras mantengas tu cuenta activa. Puedes eliminar permanentemente tu cuenta en cualquier momento desde \"Editar perfil → Eliminar cuenta\"; al hacerlo, se borran tu perfil, biblioteca, amistades y actividad sin posibilidad de recuperación.';

  @override
  String get privacySection6Title => '6. Tus derechos';

  @override
  String get privacySection6Body1 =>
      'Tienes derecho a acceder, rectificar, suprimir, limitar u oponerte al tratamiento de tus datos, y a su portabilidad. Puedes ejercer la mayoría de estos derechos directamente desde la app (editar tu perfil o eliminar la cuenta) o escribiéndonos a contacte@gameshelfapp.net.';

  @override
  String get privacySection6Body2 =>
      'También tienes derecho a presentar una reclamación ante la Agencia Española de Protección de Datos (www.aepd.es) si consideras que el tratamiento de tus datos no se ajusta a la normativa.';

  @override
  String get privacySection7Title => '7. Seguridad';

  @override
  String get privacySection7Body =>
      'Las conexiones se realizan cifradas (HTTPS) y la base de datos aplica reglas de acceso (Row Level Security) para que cada usuario solo pueda leer y modificar sus propios datos privados.';

  @override
  String get privacySection8Title => '8. Menores de edad';

  @override
  String get privacySection8Body =>
      'GameShelf no está dirigida a menores de 14 años. No recogemos conscientemente datos de menores por debajo de esa edad.';

  @override
  String get privacySection9Title => '9. Cambios en esta política';

  @override
  String get privacySection9Body =>
      'Podemos actualizar esta política para adaptarla a cambios legales o del servicio. Te avisaremos dentro de la aplicación si los cambios son relevantes.';

  @override
  String get cookiesTitle => 'Política de cookies';

  @override
  String get cookiesNoThirdPartyTitle => 'GameShelf no usa cookies de terceros';

  @override
  String get cookiesNoThirdPartyBody =>
      'GameShelf no utiliza cookies de publicidad, seguimiento ni análisis (analytics) de ningún tipo. No te rastreamos entre webs ni compartimos tu comportamiento con terceros con fines comerciales.';

  @override
  String get cookiesEssentialTitle => 'Almacenamiento técnico esencial';

  @override
  String get cookiesEssentialBody1 =>
      'Para mantener tu sesión iniciada, la aplicación guarda un testigo de sesión (token de autenticación) en el almacenamiento local de tu navegador, gestionado por nuestro proveedor de autenticación (Supabase). Este almacenamiento es estrictamente necesario para que la aplicación funcione (no tener que volver a iniciar sesión cada vez) y no se utiliza con ninguna otra finalidad.';

  @override
  String get cookiesEssentialBody2 =>
      'Como se trata de almacenamiento técnicamente necesario y no de cookies de seguimiento o publicitarias, la aplicación no muestra un banner de consentimiento de cookies.';

  @override
  String get cookiesFutureChangesTitle => 'Cambios futuros';

  @override
  String get cookiesFutureChangesBody =>
      'Si en el futuro incorporásemos herramientas de análisis o publicidad que requieran cookies no esenciales, actualizaremos esta política y, si la normativa lo exige, te pediremos tu consentimiento antes de activarlas.';

  @override
  String get cookiesContactTitle => 'Contacto';

  @override
  String get cookiesContactBody =>
      'Si tienes dudas sobre esta política, escríbenos a contacte@gameshelfapp.net.';

  @override
  String get aboutTitle => 'Sobre GameShelf';

  @override
  String get aboutAppName => 'GameShelf';

  @override
  String get aboutVersionLabel => 'Versión';

  @override
  String get aboutDescription =>
      'GameShelf es una aplicación social para jugadores que permite hacer seguimiento de tu biblioteca de videojuegos: registra a qué estás jugando, marca tus favoritos, escribe reviews y comparte tu actividad con amigos, y descubre nuevos videojuegos.';

  @override
  String get aboutDeveloperTitle => 'Desarrollador';

  @override
  String get aboutDeveloperName => 'Jordi Bertomeu Primo';

  @override
  String get aboutDeveloperBio =>
      'Full stack y video game developer que ha hecho esta aplicación web en su tiempo libre por pura necesidad y amor a los videojuegos.';

  @override
  String get aboutDeveloperPortfolioLabel => 'Ver portfolio';

  @override
  String get aboutDeveloperPortfolioUrl =>
      'https://jordi110398.github.io/portfolio/';

  @override
  String get aboutDevelopmentTitle => 'Sobre el desarrollo';

  @override
  String get aboutDevelopmentBody =>
      'Buena parte del código de GameShelf se ha escrito con la ayuda de herramientas de inteligencia artificial. La idea, el diseño y todas las decisiones del proyecto son originales: la IA ha ayudado a escribirlo, pero la intención detrás de GameShelf es honesta y pensada de verdad para los jugadores.';

  @override
  String get aboutContactTitle => 'Contacto';

  @override
  String get aboutCatalogDataTitle => 'Datos del catálogo de juegos';

  @override
  String get aboutCatalogDataBody =>
      'La información de los juegos (títulos, portadas, descripciones) proviene de IGDB.';

  @override
  String get aboutLegalDocumentsTitle => 'Documentos legales';

  @override
  String get installAppTitle => 'Instala la app';

  @override
  String get installAppSubtitle =>
      'Añade GameShelf a la pantalla de inicio de tu móvil';

  @override
  String get installAppDialogTitle => 'Cómo instalarla';

  @override
  String get installAppDialogBody =>
      'En Safari (iPhone/iPad): toca el icono de Compartir y selecciona \"Añadir a la pantalla de inicio\".\n\nEn el navegador del ordenador o en Chrome/Edge para Android: busca el icono de instalar en la barra de direcciones, o la opción \"Instalar GameShelf\" en el menú (⋮).';

  @override
  String get installAppAcceptedMessage =>
      '¡GameShelf se ha añadido a tu pantalla de inicio!';

  @override
  String get llampAppBarTitle => 'Descubre';

  @override
  String get sectionRecommendations => 'Recomendaciones para ti';

  @override
  String get emptyRecommendationsNoFriends =>
      'Añade amigos para empezar a recibir recomendaciones personalizadas.';

  @override
  String get emptyRecommendationsNoData =>
      'Juega y valora algunos juegos para que podamos recomendarte más.';

  @override
  String get sectionFriendsShelves => 'Estanterías de tus amigos';

  @override
  String get emptyFriendsShelves =>
      'Tus amigos todavía no han publicado ninguna estantería.';

  @override
  String get myShelvesAction => 'Mis estanterías';

  @override
  String get llampLoadFailedPrefix => 'No se ha podido cargar el descubre: ';

  @override
  String get myShelvesTitle => 'Mis estanterías';

  @override
  String get emptyMyShelves =>
      'Todavía no has creado ninguna estantería. Crea una para organizar los juegos que quieras destacar.';

  @override
  String get newShelfAction => 'Nueva estantería';

  @override
  String get newShelfDialogTitle => 'Nueva estantería';

  @override
  String get shelfTitleHint => 'Nombre de la estantería';

  @override
  String get pinnedBadge => 'Fijada al perfil';

  @override
  String get publishedBadge => 'Publicada en descubre';

  @override
  String get deleteShelfTitle => 'Eliminar estantería';

  @override
  String deleteShelfBody(String title) {
    return '¿Seguro que quieres eliminar la estantería \"$title\"? Esta acción no se puede deshacer.';
  }

  @override
  String get createShelfFailedPrefix => 'No se ha podido crear la estantería: ';

  @override
  String get deleteShelfFailedPrefix =>
      'No se ha podido eliminar la estantería: ';

  @override
  String get editShelfTitle => 'Editar estantería';

  @override
  String get pinToProfileTitle => 'Fijar al perfil';

  @override
  String get pinToProfileSubtitle =>
      'Se mostrará en tu perfil (solo una a la vez).';

  @override
  String get publishToLlampTitle => 'Publicar en descubre';

  @override
  String get publishToLlampSubtitle =>
      'Tus amigos la verán en la pestaña de Descubre.';

  @override
  String get addGameAction => 'Añadir juego';

  @override
  String get pickGameSheetTitle => 'Elige un juego de tu biblioteca';

  @override
  String get shelfFullMessage => 'Esta estantería ya tiene 8 juegos.';

  @override
  String get emptyLibraryForShelf =>
      'Todavía no tienes ningún juego en la biblioteca.';

  @override
  String get allGamesAlreadyInShelf =>
      'Ya has añadido todos los juegos de tu biblioteca a esta estantería.';

  @override
  String get renameFailedPrefix => 'No se ha podido cambiar el nombre: ';

  @override
  String get pinFailedPrefix => 'No se ha podido fijar la estantería: ';

  @override
  String get unpinFailedPrefix => 'No se ha podido desfijar la estantería: ';

  @override
  String get publishFailedPrefix => 'No se ha podido publicar la estantería: ';

  @override
  String get addGameFailedPrefix => 'No se ha podido añadir el juego: ';

  @override
  String get removeGameFailedPrefix => 'No se ha podido quitar el juego: ';

  @override
  String get notificationAppBarTitle => 'Notificaciones';

  @override
  String get markAllAsRead => 'Marcar todas como leídas';

  @override
  String get emptyList => 'Todavía no tienes ninguna notificación.';

  @override
  String get notificationLoadFailedPrefix =>
      'No se han podido cargar las notificaciones: ';

  @override
  String get listFriendRequest => 'te ha enviado una solicitud de amistad';

  @override
  String get listFriendAccepted => 'ha aceptado tu solicitud de amistad';

  @override
  String get listActivityLikePrefix => 'le ha gustado tu actividad sobre ';

  @override
  String get listActivityLikeUnknownGame => 'un juego';

  @override
  String get bannerFriendRequestSuffix =>
      'te ha enviado una solicitud de amistad';

  @override
  String get bannerFriendAcceptedSuffix => 'ha aceptado tu solicitud';

  @override
  String get bannerActivityLikeSuffix => 'ha dado una estrella';

  @override
  String get bannerActivityLikeGamePrefix => ' a ';

  @override
  String get profileLoadFailedPrefix => 'No se ha podido cargar el perfil: ';

  @override
  String get sendRequestFailedPrefix => 'No se ha podido enviar la solicitud: ';

  @override
  String get acceptRequestFailedPrefix =>
      'No se ha podido aceptar la solicitud: ';

  @override
  String get rejectRequestFailedPrefix =>
      'No se ha podido rechazar la solicitud: ';

  @override
  String get removeFriendFailedPrefix => 'No se ha podido eliminar al amigo: ';

  @override
  String get removeFriendTitle => '¿Eliminar amigo?';

  @override
  String removeFriendBody(String nickname) {
    return '¿Quieres eliminar a @$nickname de tus amigos?';
  }

  @override
  String get editProfileTooltip => 'Editar perfil';

  @override
  String get shareProfileTooltip => 'Compartir perfil';

  @override
  String get logoutTooltip => 'Cerrar sesión';

  @override
  String get noReviewsYet => 'Todavía no has escrito ninguna review.';

  @override
  String seeAllReviews(int count) {
    return 'Ver todas las reviews ($count)';
  }

  @override
  String get statGames => 'Juegos';

  @override
  String get statCompleted => 'Completados';

  @override
  String get statReviews => 'Reviews';

  @override
  String get statHours => 'Horas';

  @override
  String get myReviewsTitle => 'Mis reviews';

  @override
  String get completedTitle => 'Completados';

  @override
  String get favoritesTitle => 'Favoritos';

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
  String get emptyGamesDropped => 'Este usuario no tiene juegos abandonados.';

  @override
  String get emptyGamesWantToPlay => 'Este usuario no tiene juegos pendientes.';

  @override
  String get emptyGamesPlaying => 'Este usuario no tiene juegos en curso.';

  @override
  String get emptyGamesCompleted => 'Este usuario no tiene juegos completados.';

  @override
  String get emptyGamesPaused => 'Este usuario no tiene juegos pausados.';

  @override
  String get emptyGamesAny => 'Este usuario todavía no tiene juegos.';

  @override
  String get editAppBarTitle => 'Editar perfil';

  @override
  String get changePhoto => 'Cambiar foto';

  @override
  String get cropAvatarTitle => 'Ajusta la foto';

  @override
  String get cropFailedMessage => 'No se ha podido recortar la imagen.';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Cuenta algo sobre ti...';

  @override
  String get emailLabel => 'Email';

  @override
  String get saving => 'Guardando...';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get informationTitle => 'Información';

  @override
  String get securityTitle => 'Seguridad';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle => 'Actualiza la contraseña de tu cuenta';

  @override
  String get dangerZoneTitle => 'Zona de peligro';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountSubtitle =>
      'Elimina permanentemente tu cuenta y tus datos';

  @override
  String get deleteAccountDialogTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountDialogBody =>
      'Esta acción es permanente. Se eliminarán tu perfil, biblioteca, reviews, amistades y actividad.';

  @override
  String get deleteAccountFailedPrefix =>
      'No se ha podido eliminar la cuenta: ';

  @override
  String get changePasswordDialogTitle => 'Cambiar contraseña';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get repeatPasswordLabel => 'Repite la contraseña';

  @override
  String get passwordRequirementsIntro => 'La contraseña debe tener:';

  @override
  String get reqMinLength => 'Al menos 8 caracteres';

  @override
  String get reqUppercase => 'Una letra mayúscula';

  @override
  String get reqLowercase => 'Una letra minúscula';

  @override
  String get reqNumber => 'Un número';

  @override
  String get reqSymbol => 'Un símbolo';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden.';

  @override
  String get changePasswordSuccess => 'Contraseña cambiada correctamente.';

  @override
  String get changePasswordFailedPrefix =>
      'No se ha podido cambiar la contraseña: ';

  @override
  String get changeAction => 'Cambiar';

  @override
  String get shareAppBarTitle => 'Compartir perfil';

  @override
  String get shareQrCaption => 'Escanea para encontrarme en GameShelf';

  @override
  String get shareDownloadAction => 'Descargar imagen';

  @override
  String get shareDownloadedMessage => 'Imagen descargada.';

  @override
  String get shareGenerateFailedPrefix => 'No se ha podido generar la imagen: ';

  @override
  String get settingsTooltip => 'Configuración';

  @override
  String get settingsAppBarTitle => 'Configuración';

  @override
  String get settingsEditProfileSubtitle =>
      'Nickname, bio, foto, contraseña y cuenta';

  @override
  String get shelfStyleSectionTitle => 'Estética';

  @override
  String get shelfStyleSectionSubtitle =>
      'El color de la madera define el aspecto de toda la app y de tus estanterías.';

  @override
  String get shelfLightsLabel => 'Luces';

  @override
  String get shelfLightsNeon => 'Neón';

  @override
  String get shelfLightsBulbs => 'Bombillas';

  @override
  String get shelfWoodLabel => 'Color de la madera';

  @override
  String get shelfWoodWalnut => 'Nogal';

  @override
  String get shelfWoodOak => 'Roble';

  @override
  String get shelfWoodEbony => 'Ébano';

  @override
  String get shelfWoodCherry => 'Cerezo';

  @override
  String get shelfWoodBirch => 'Abedul';

  @override
  String get shelfDecorationLabel => 'Decoración';

  @override
  String get shelfDecorationHint => 'Puedes elegir más de una.';

  @override
  String get shelfDecorationNone => 'Ninguna';

  @override
  String get shelfDecorationPoppy => 'Amapola';

  @override
  String get shelfDecorationCactus => 'Cactus';

  @override
  String get shelfDecorationAzalea => 'Azalea';

  @override
  String get shelfCoverStyleLabel => 'Portadas de juego';

  @override
  String get shelfCoverStylePlain => 'Planas';

  @override
  String get shelfCoverStyleCartridge => 'Cartucho';

  @override
  String get shelfStyleChangeFailedPrefix =>
      'No se ha podido cambiar la estética: ';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get languageCatalan => 'Catalán';

  @override
  String get languageSpanish => 'Castellano';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageChangeFailedPrefix =>
      'No se ha podido cambiar el idioma: ';

  @override
  String get changePasswordPageTitle => 'Cambiar contraseña';

  @override
  String get fillAllFields => 'Rellena todos los campos.';

  @override
  String get passwordMinLength6 =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordUpdatedSuccess => 'Contraseña actualizada correctamente.';

  @override
  String get newPasswordFieldLabel => 'Nueva contraseña';

  @override
  String get repeatPasswordFieldLabel => 'Repetir contraseña';

  @override
  String get updating => 'Actualizando...';

  @override
  String get socialAppBarTitle => 'Social';

  @override
  String get socialSearchHint => 'Buscar usuarios...';

  @override
  String get searchUsersFailedPrefix =>
      'No se han podido buscar los usuarios: ';

  @override
  String get loadSocialFailedPrefix =>
      'No se han podido cargar los datos sociales: ';

  @override
  String get emptyFriendsTitle => 'Todavía no tienes amigos';

  @override
  String get emptyFriendsSubtitle =>
      'Busca a otros usuarios de GameShelf para añadirlos.';

  @override
  String get emptySearchResults => 'No se han encontrado usuarios';

  @override
  String get sectionRequests => 'Solicitudes';

  @override
  String get sectionFriends => 'Amigos';

  @override
  String get sectionActivitySummary => 'Resumen de actividad';

  @override
  String get seeMore => 'Ver más';

  @override
  String get reviewOfPrefix => 'Review de ';
}
