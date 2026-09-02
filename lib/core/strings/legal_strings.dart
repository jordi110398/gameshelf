/// Text de les pantalles legals (privacitat, cookies, sobre l'app),
/// centralitzat de cara a una futura traducció. Vegeu `app_strings.dart`
/// per a l'explicació general d'aquest patró.
class LegalStrings {
  const LegalStrings._();

  // TODO: substituir per l'email definitiu un cop creat.
  static const contactEmail = 'privacitat@gameshelf.app';

  static const lastUpdated = 'Última actualització: setembre de 2026.';

  // ─────────────────────────────────────────────
  // POLÍTICA DE PRIVACITAT
  // ─────────────────────────────────────────────

  static const privacyTitle = 'Política de privacitat';

  static const privacyIntro =
      'Aquesta política explica quines dades personals recull GameShelf, '
      'amb quina finalitat i quins drets tens sobre elles, d\'acord amb '
      'el Reglament (UE) 2016/679 (RGPD) i la Llei Orgànica 3/2018 de '
      'Protecció de Dades i Garantia dels Drets Digitals (LOPDGDD).';

  static const privacySection1Title = '1. Responsable del tractament';
  static const privacySection1Body =
      'Jordi Bertomeu Primo, com a titular i desenvolupador de GameShelf, '
      'és el responsable del tractament de les dades que es descriuen en '
      'aquesta política.\n'
      'Contacte: $contactEmail';

  static const privacySection2Title = '2. Quines dades recollim';
  static const privacySection2Bullet1 =
      'Dades de registre: email i contrasenya (la contrasenya es '
      'guarda xifrada, mai en text pla).';
  static const privacySection2Bullet2 =
      'Dades de perfil: nickname, biografia i foto de perfil.';
  static const privacySection2Bullet3 =
      'Dades d\'ús del servei: la teva biblioteca de jocs, els '
      'estats (jugant, completat, etc.), valoracions, hores jugades i '
      'reviews que escriguis.';
  static const privacySection2Bullet4 =
      'Dades socials: sol·licituds i relacions d\'amistat amb altres '
      'usuaris, i l\'activitat que es genera a partir de la teva '
      'biblioteca (per mostrar-la als teus amics).';

  static const privacySection3Title = '3. Amb quina finalitat les tractem';
  static const privacySection3Bullet1 =
      'Per crear i gestionar el teu compte i permetre l\'ús de les '
      'funcionalitats de l\'aplicació (biblioteca, cerca de jocs, '
      'funcions socials).';
  static const privacySection3Bullet2 =
      'Per enviar-te correus estrictament necessaris per al servei: '
      'confirmació de compte i recuperació de contrasenya.';
  static const privacySection3Body =
      'La base legal per a aquests tractaments és l\'execució del '
      'contracte de servei que acceptes en crear un compte (art. 6.1.b '
      'RGPD).';

  static const privacySection4Title = '4. Amb qui compartim les dades';
  static const privacySection4Bullet1 =
      'Supabase Inc., com a encarregat del tractament: allotja la base '
      'de dades, l\'autenticació i els fitxers (com les fotos de '
      'perfil) en servidors situats a la Unió Europea.';
  static const privacySection4Bullet2 =
      'IGDB (propietat de Twitch/Amazon), com a proveïdor del catàleg '
      'de videojocs: només rep el text que introdueixes quan cerques un '
      'joc, mai dades personals del teu compte.';
  static const privacySection4Body =
      'No compartim, venem ni cedim les teves dades a tercers amb '
      'finalitats publicitàries.';

  static const privacySection5Title =
      '5. Durant quant de temps les guardem';
  static const privacySection5Body =
      'Mentre mantinguis el teu compte actiu. Pots eliminar '
      'permanentment el teu compte en qualsevol moment des de '
      '"Editar perfil → Eliminar compte"; en fer-ho, s\'esborren el '
      'teu perfil, biblioteca, amistats i activitat sense possibilitat '
      'de recuperació.';

  static const privacySection6Title = '6. Els teus drets';
  static const privacySection6Body1 =
      'Tens dret a accedir, rectificar, suprimir, limitar o oposar-te '
      'al tractament de les teves dades, i a la seva portabilitat. Pots '
      'exercir la majoria d\'aquests drets directament des de l\'app '
      '(editar el teu perfil o eliminar el compte) o escrivint-nos a '
      '$contactEmail.';
  static const privacySection6Body2 =
      'També tens dret a presentar una reclamació davant l\'Agència '
      'Espanyola de Protecció de Dades (www.aepd.es) si consideres que '
      'el tractament de les teves dades no s\'ajusta a la normativa.';

  static const privacySection7Title = '7. Seguretat';
  static const privacySection7Body =
      'Les connexions es fan xifrades (HTTPS) i la base de dades '
      'aplica regles d\'accés (Row Level Security) perquè cada usuari '
      'només pugui llegir i modificar les seves pròpies dades privades.';

  static const privacySection8Title = '8. Menors d\'edat';
  static const privacySection8Body =
      'GameShelf no està dirigida a menors de 14 anys. No recollim '
      'conscientment dades de menors per sota d\'aquesta edat.';

  static const privacySection9Title = '9. Canvis a aquesta política';
  static const privacySection9Body =
      'Podem actualitzar aquesta política per adaptar-la a canvis '
      'legals o del servei. T\'avisarem dins l\'aplicació si els canvis '
      'són rellevants.';

  // ─────────────────────────────────────────────
  // POLÍTICA DE COOKIES
  // ─────────────────────────────────────────────

  static const cookiesTitle = 'Política de cookies';

  static const cookiesNoThirdPartyTitle =
      'GameShelf no fa servir cookies de tercers';
  static const cookiesNoThirdPartyBody =
      'GameShelf no utilitza cookies de publicitat, seguiment ni '
      'anàlisi (analytics) de cap tipus. No et rastregem entre webs ni '
      'compartim el teu comportament amb tercers amb finalitats '
      'comercials.';

  static const cookiesEssentialTitle = 'Emmagatzematge tècnic essencial';
  static const cookiesEssentialBody1 =
      'Per mantenir la teva sessió iniciada, l\'aplicació guarda un '
      'testimoni de sessió (token d\'autenticació) a l\'emmagatzematge '
      'local del teu navegador, gestionat pel nostre proveïdor '
      'd\'autenticació (Supabase). Aquest emmagatzematge és estrictament '
      'necessari perquè l\'aplicació funcioni (no haver de tornar a '
      'iniciar sessió cada vegada) i no s\'utilitza amb cap altra '
      'finalitat.';
  static const cookiesEssentialBody2 =
      'Com que es tracta d\'emmagatzematge tècnicament necessari i no '
      'de cookies de seguiment o publicitàries, l\'aplicació no mostra '
      'un bàner de consentiment de cookies.';

  static const cookiesFutureChangesTitle = 'Canvis futurs';
  static const cookiesFutureChangesBody =
      'Si en el futur incorporéssim eines d\'anàlisi o publicitat que '
      'requereixin cookies no essencials, actualitzarem aquesta '
      'política i, si la normativa ho exigeix, et demanarem el teu '
      'consentiment abans d\'activar-les.';

  static const cookiesContactTitle = 'Contacte';
  static const cookiesContactBody =
      'Si tens dubtes sobre aquesta política, escriu-nos a $contactEmail.';

  // ─────────────────────────────────────────────
  // SOBRE GAMESHELF
  // ─────────────────────────────────────────────

  static const aboutTitle = 'Sobre GameShelf';
  static const aboutAppName = 'GameShelf';
  static const aboutVersionLabel = 'Versió';

  static const aboutDescription =
      'GameShelf és una aplicació social per als jugadors que permet '
      'fer seguiment de la teva biblioteca de videojocs: '
      'registra a què estàs jugant, marca els teus preferits, '
      'escriu reviews i comparteix la teva activitat '
      'amb amics, i descobreix nous videojocs.';

  static const aboutDeveloperTitle = 'Desenvolupador';
  static const aboutDeveloperName = 'Jordi Bertomeu Primo';
  static const aboutDeveloperBio =
      'Full stack i video game developer que ha fet aquesta aplicació web '
      'en el seu temps lliure per pura necessitat i amor als videojocs.';
  static const aboutDeveloperPortfolioLabel = 'Veure portfoli';
  static const aboutDeveloperPortfolioUrl =
      'https://jordi110398.github.io/portfolio/';

  static const aboutDevelopmentTitle = 'Sobre el desenvolupament';
  static const aboutDevelopmentBody =
      'Bona part del codi de GameShelf s\'ha escrit amb l\'ajuda '
      'd\'eines d\'intel·ligència artificial. La idea, el disseny i '
      'totes les decisions del projecte són originals: la IA hi ha '
      'ajudat a escriure\'l, però la intenció darrere de GameShelf és '
      'honesta i pensada de debò per als jugadors.';

  static const aboutContactTitle = 'Contacte';

  static const aboutCatalogDataTitle = 'Dades del catàleg de jocs';
  static const aboutCatalogDataBody =
      'La informació dels jocs (títols, portades, descripcions) prové '
      'd\'IGDB.';

  static const aboutLegalDocumentsTitle = 'Documents legals';
}
