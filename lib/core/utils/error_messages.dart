import 'package:flutter/widgets.dart';
import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tradueix un error tècnic (Supabase o intern) a un missatge entenedor
/// per mostrar-lo a l'usuari.
///
/// Centralitzat aquí perquè és l'únic lloc on cal tocar el text quan
/// s'afegeixi traducció a la resta de l'app més endavant.
String friendlyError(BuildContext context, Object error) {
  if (error is AuthException) {
    return _authMessage(context, error);
  }

  if (error is PostgrestException) {
    return _postgrestMessage(context, error);
  }

  if (error is StorageException) {
    return _storageMessage(context, error);
  }

  if (error is FunctionException) {
    return _functionMessage(context, error);
  }

  return _genericMessage(context, error);
}

String _authMessage(BuildContext context, AuthException error) {
  switch (error.code) {
    case 'invalid_credentials':
      return context.l10n.errorInvalidCredentials;
    case 'email_not_confirmed':
      return context.l10n.errorEmailNotConfirmed;
    case 'user_already_exists':
    case 'email_exists':
      return context.l10n.errorEmailExists;
    case 'weak_password':
      return context.l10n.errorWeakPassword;
    case 'same_password':
      return context.l10n.errorSamePassword;
    case 'over_email_send_rate_limit':
    case 'over_request_rate_limit':
      return context.l10n.errorRateLimited;
    case 'signup_disabled':
      return context.l10n.errorSignupDisabled;
    case 'session_expired':
    case 'session_not_found':
      return context.l10n.errorSessionExpired;
  }

  // Els missatges d'AuthException ja estan pensats per mostrar-se a
  // l'usuari (nomes venen en anglès); és un fallback raonable pels
  // codis que encara no tenim traduïts.
  return error.message;
}

String _postgrestMessage(BuildContext context, PostgrestException error) {
  switch (error.code) {
    case '23505':
      return context.l10n.errorDuplicateRecord;
    case '23502':
      return context.l10n.errorMissingRequiredData;
    case '23503':
      return context.l10n.errorReferencedNotFound;
    case '42501':
      return context.l10n.errorPermissionDenied;
  }

  return context.l10n.errorOperationFailed;
}

String _storageMessage(BuildContext context, StorageException error) {
  if (error.statusCode == '413') {
    return context.l10n.errorFileTooLarge;
  }

  return context.l10n.errorUploadFailed;
}

String _functionMessage(BuildContext context, FunctionException error) {
  return context.l10n.errorServerOperationFailed;
}

/// Missatges llançats directament des del repositori/servei (que no té
/// accés a `BuildContext`, per disseny) reconeguts pel seu contingut
/// exacte i traduïts aquí -- l'alternativa (fer dependre la capa de
/// repositori de la UI) seria pitjor.
const _knownRepositoryMessages = {
  'Usuari no autenticat': 'errorNotAuthenticated',
  'L\'usuari no ha iniciat sessió.': 'errorNotAuthenticated',
  'No et pots enviar una sol·licitud a tu mateix': 'errorCannotFriendSelf',
  'Ja existeix una relació amb aquest usuari': 'errorFriendshipAlreadyExists',
  'No s\'ha pogut eliminar el compte': 'errorDeleteAccountGeneric',
  'No s\'ha pogut desar el joc': 'errorSaveGameGeneric',
};

String _genericMessage(BuildContext context, Object error) {
  if (error is Exception) {
    final text = error.toString().replaceFirst('Exception: ', '');

    final knownKey = _knownRepositoryMessages[text];
    if (knownKey != null) {
      switch (knownKey) {
        case 'errorNotAuthenticated':
          return context.l10n.errorNotAuthenticated;
        case 'errorCannotFriendSelf':
          return context.l10n.errorCannotFriendSelf;
        case 'errorFriendshipAlreadyExists':
          return context.l10n.errorFriendshipAlreadyExists;
        case 'errorDeleteAccountGeneric':
          return context.l10n.errorDeleteAccountGeneric;
        case 'errorSaveGameGeneric':
          return context.l10n.errorSaveGameGeneric;
      }
    }

    if (text.isNotEmpty && text.length < 200) {
      return text;
    }
  }

  return context.l10n.errorUnexpected;
}
