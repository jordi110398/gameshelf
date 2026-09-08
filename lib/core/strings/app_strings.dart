/// Cadenes de text compartides entre pantalles (navegació, accions comunes
/// de diàleg, etc.), centralitzades aquí de cara a una futura traducció.
///
/// Això NO és encara un sistema de traducció (no hi ha `intl`/ARB ni canvi
/// d'idioma en temps real): és el pas previ, de baix risc, que fa que la
/// futura migració a `flutter_localizations` sigui purament mecànica
/// (moure cada constant d'aquí a un fitxer .arb per idioma) en lloc d'haver
/// de rebuscar el text per tota la base de codi.
///
/// Les cadenes específiques d'una sola pantalla (missatges d'una sola
/// pantalla concreta, textos d'estat buit, etc.) encara viuen inline als
/// seus widgets; aquest fitxer cobreix només el que es repeteix entre
/// pantalles.
class AppStrings {
  const AppStrings._();

  // ─────────────────────────────────────────────
  // NAVEGACIÓ
  // ─────────────────────────────────────────────

  static const navHome = 'Inici';
  static const navLlamp = 'Descobreix';
  static const navSocial = 'Social';
  static const navProfile = 'Perfil';

  // ─────────────────────────────────────────────
  // ACCIONS COMUNES DE DIÀLEG
  // ─────────────────────────────────────────────

  static const actionCancel = 'Cancel·lar';
  static const actionDelete = 'Eliminar';
  static const actionSave = 'Guardar';
  static const actionAccept = 'Acceptar';
  static const actionReject = 'Rebutjar';
  static const actionLogout = 'Tancar sessió';
  static const actionEdit = 'Editar';
  static const actionSeeMore = 'Veure més';

  // ─────────────────────────────────────────────
  // AMISTATS
  // ─────────────────────────────────────────────

  static const friendshipAdd = 'Afegir amic';
  static const friendshipRequestSent = 'Sol·licitud enviada';
  static const friendshipFriends = 'Amics';
}
