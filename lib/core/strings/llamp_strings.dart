/// Cadenes de la pestanya del llamp (recomanacions, estanteries pròpies i
/// llistes publicades pels amics), centralitzades seguint el mateix patró
/// que `ProfileStrings`/`HomeStrings`. Vegeu `app_strings.dart`.
class LlampStrings {
  const LlampStrings._();

  // ─────────────────────────────────────────────
  // PESTANYA PRINCIPAL
  // ─────────────────────────────────────────────

  static const appBarTitle = 'Descobreix';

  static const sectionRecommendations = 'Recomanacions per a tu';
  static const emptyRecommendationsNoFriends =
      'Afegeix amics per començar a rebre recomanacions personalitzades.';
  static const emptyRecommendationsNoData =
      'Juga i valora alguns jocs perquè puguem recomanar-te\'n més.';

  static const sectionFriendsShelves = 'Estanteries dels teus amics';
  static const emptyFriendsShelves =
      'Els teus amics encara no han publicat cap estanteria.';

  static const myShelvesAction = 'Les meves estanteries';

  static const loadFailedPrefix = 'No s\'ha pogut carregar el llamp: ';

  // ─────────────────────────────────────────────
  // LES MEVES ESTANTERIES
  // ─────────────────────────────────────────────

  static const myShelvesTitle = 'Les meves estanteries';
  static const emptyMyShelves =
      'Encara no has creat cap estanteria. Crea\'n una per organitzar els '
      'jocs que vulguis destacar.';

  static const newShelfAction = 'Nova estanteria';
  static const newShelfDialogTitle = 'Nova estanteria';
  static const shelfTitleHint = 'Nom de l\'estanteria';

  static const pinnedBadge = 'Fixada al perfil';
  static const publishedBadge = 'Publicada al llamp';

  static const deleteShelfTitle = 'Eliminar estanteria';
  static String deleteShelfBody(String title) =>
      'Segur que vols eliminar l\'estanteria "$title"? Aquesta acció no es '
      'pot desfer.';

  static const createShelfFailedPrefix = 'No s\'ha pogut crear l\'estanteria: ';
  static const deleteShelfFailedPrefix =
      'No s\'ha pogut eliminar l\'estanteria: ';

  // ─────────────────────────────────────────────
  // EDITAR ESTANTERIA
  // ─────────────────────────────────────────────

  static const editShelfTitle = 'Editar estanteria';
  static const pinToProfileTitle = 'Fixar al perfil';
  static const pinToProfileSubtitle =
      'Es mostrarà al teu perfil (només una alhora).';
  static const publishToLlampTitle = 'Publicar al llamp';
  static const publishToLlampSubtitle =
      'Els teus amics la veuran a la pestanya de Descobreix.';

  static const addGameAction = 'Afegir joc';
  static const pickGameSheetTitle = 'Tria un joc de la teva biblioteca';
  static const shelfFullMessage = 'Aquesta estanteria ja té 8 jocs.';
  static const emptyLibraryForShelf =
      'Encara no tens cap joc a la biblioteca.';
  static const allGamesAlreadyInShelf =
      'Ja has afegit tots els jocs de la teva biblioteca a aquesta '
      'estanteria.';

  static const renameFailedPrefix = 'No s\'ha pogut canviar el nom: ';
  static const pinFailedPrefix = 'No s\'ha pogut fixar l\'estanteria: ';
  static const unpinFailedPrefix = 'No s\'ha pogut desfixar l\'estanteria: ';
  static const publishFailedPrefix = 'No s\'ha pogut publicar l\'estanteria: ';
  static const addGameFailedPrefix = 'No s\'ha pogut afegir el joc: ';
  static const removeGameFailedPrefix = 'No s\'ha pogut treure el joc: ';

  // ─────────────────────────────────────────────
  // ESTANTERIA FIXADA AL PERFIL
  // ─────────────────────────────────────────────

  static const pinnedShelfTitleOwn = 'La teva estanteria';
  static String pinnedShelfTitleOf(String nickname) =>
      'Estanteria de @$nickname';
}
