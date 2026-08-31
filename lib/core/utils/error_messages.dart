import 'package:supabase_flutter/supabase_flutter.dart';

/// Tradueix un error tècnic (Supabase o intern) a un missatge entenedor
/// en català per mostrar-lo a l'usuari.
///
/// Centralitzat aquí perquè és l'únic lloc on cal tocar el text quan
/// s'afegeixi traducció a la resta de l'app més endavant.
String friendlyError(Object error) {
  if (error is AuthException) {
    return _authMessage(error);
  }

  if (error is PostgrestException) {
    return _postgrestMessage(error);
  }

  if (error is StorageException) {
    return _storageMessage(error);
  }

  if (error is FunctionException) {
    return _functionMessage(error);
  }

  return _genericMessage(error);
}

String _authMessage(AuthException error) {
  switch (error.code) {
    case 'invalid_credentials':
      return 'Email o contrasenya incorrectes.';
    case 'email_not_confirmed':
      return 'Has de confirmar el teu email abans d\'iniciar sessió.';
    case 'user_already_exists':
    case 'email_exists':
      return 'Ja existeix un compte amb aquest email.';
    case 'weak_password':
      return 'La contrasenya és massa feble.';
    case 'same_password':
      return 'La nova contrasenya ha de ser diferent de l\'actual.';
    case 'over_email_send_rate_limit':
    case 'over_request_rate_limit':
      return 'Has fet massa peticions seguides. Espera una mica i torna-ho a provar.';
    case 'signup_disabled':
      return 'El registre no està disponible ara mateix.';
    case 'session_expired':
    case 'session_not_found':
      return 'La teva sessió ha caducat. Torna a iniciar sessió.';
  }

  // Els missatges d'AuthException ja estan pensats per mostrar-se a
  // l'usuari (nomes venen en anglès); és un fallback raonable pels
  // codis que encara no tenim traduïts.
  return error.message;
}

String _postgrestMessage(PostgrestException error) {
  switch (error.code) {
    case '23505':
      return 'Ja existeix un registre amb aquestes dades.';
    case '23502':
      return 'Falten dades obligatòries.';
    case '23503':
      return 'L\'element referenciat no existeix.';
    case '42501':
      return 'No tens permís per fer aquesta acció.';
  }

  return 'No s\'ha pogut completar l\'operació. Torna-ho a provar.';
}

String _storageMessage(StorageException error) {
  if (error.statusCode == '413') {
    return 'El fitxer és massa gran.';
  }

  return 'No s\'ha pogut pujar el fitxer. Torna-ho a provar.';
}

String _functionMessage(FunctionException error) {
  return 'No s\'ha pogut completar l\'operació al servidor.';
}

String _genericMessage(Object error) {
  if (error is Exception) {
    final text = error.toString().replaceFirst('Exception: ', '');

    if (text.isNotEmpty && text.length < 200) {
      return text;
    }
  }

  return 'Hi ha hagut un error inesperat. Torna-ho a provar.';
}
