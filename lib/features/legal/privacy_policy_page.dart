import 'package:flutter/material.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

const contactEmail =
    'privacitat@gameshelf.app'; // TODO: substituir per l'email definitiu un cop creat

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Política de privacitat',
      children: const [
        LegalParagraph('Última actualització: setembre de 2026.'),
        LegalParagraph(
          'Aquesta política explica quines dades personals recull GameShelf, '
          'amb quina finalitat i quins drets tens sobre elles, d\'acord amb '
          'el Reglament (UE) 2016/679 (RGPD) i la Llei Orgànica 3/2018 de '
          'Protecció de Dades i Garantia dels Drets Digitals (LOPDGDD).',
        ),

        LegalSectionTitle('1. Responsable del tractament'),
        LegalParagraph(
          'Jordi Bertomeu Primo, com a titular i desenvolupador de GameShelf, '
          'és el responsable del tractament de les dades que es descriuen en '
          'aquesta política.\n'
          'Contacte: $contactEmail',
        ),

        LegalSectionTitle('2. Quines dades recollim'),
        LegalBullet(
          'Dades de registre: email i contrasenya (la contrasenya es '
          'guarda xifrada, mai en text pla).',
        ),
        LegalBullet('Dades de perfil: nickname, biografia i foto de perfil.'),
        LegalBullet(
          'Dades d\'ús del servei: la teva biblioteca de jocs, els '
          'estats (jugant, completat, etc.), valoracions, hores jugades i '
          'reviews que escriguis.',
        ),
        LegalBullet(
          'Dades socials: sol·licituds i relacions d\'amistat amb altres '
          'usuaris, i l\'activitat que es genera a partir de la teva '
          'biblioteca (per mostrar-la als teus amics).',
        ),

        LegalSectionTitle('3. Amb quina finalitat les tractem'),
        LegalBullet(
          'Per crear i gestionar el teu compte i permetre l\'ús de les '
          'funcionalitats de l\'aplicació (biblioteca, cerca de jocs, '
          'funcions socials).',
        ),
        LegalBullet(
          'Per enviar-te correus estrictament necessaris per al servei: '
          'confirmació de compte i recuperació de contrasenya.',
        ),
        LegalParagraph(
          'La base legal per a aquests tractaments és l\'execució del '
          'contracte de servei que acceptes en crear un compte (art. 6.1.b '
          'RGPD).',
        ),

        LegalSectionTitle('4. Amb qui compartim les dades'),
        LegalBullet(
          'Supabase Inc., com a encarregat del tractament: allotja la base '
          'de dades, l\'autenticació i els fitxers (com les fotos de '
          'perfil) en servidors situats a la Unió Europea.',
        ),
        LegalBullet(
          'IGDB (propietat de Twitch/Amazon), com a proveïdor del catàleg '
          'de videojocs: només rep el text que introdueixes quan cerques un '
          'joc, mai dades personals del teu compte.',
        ),
        LegalParagraph(
          'No compartim, venem ni cedim les teves dades a tercers amb '
          'finalitats publicitàries.',
        ),

        LegalSectionTitle('5. Durant quant de temps les guardem'),
        LegalParagraph(
          'Mentre mantinguis el teu compte actiu. Pots eliminar '
          'permanentment el teu compte en qualsevol moment des de '
          '"Editar perfil → Eliminar compte"; en fer-ho, s\'esborren el '
          'teu perfil, biblioteca, amistats i activitat sense possibilitat '
          'de recuperació.',
        ),

        LegalSectionTitle('6. Els teus drets'),
        LegalParagraph(
          'Tens dret a accedir, rectificar, suprimir, limitar o oposar-te '
          'al tractament de les teves dades, i a la seva portabilitat. Pots '
          'exercir la majoria d\'aquests drets directament des de l\'app '
          '(editar el teu perfil o eliminar el compte) o escrivint-nos a '
          '$contactEmail.',
        ),
        LegalParagraph(
          'També tens dret a presentar una reclamació davant l\'Agència '
          'Espanyola de Protecció de Dades (www.aepd.es) si consideres que '
          'el tractament de les teves dades no s\'ajusta a la normativa.',
        ),

        LegalSectionTitle('7. Seguretat'),
        LegalParagraph(
          'Les connexions es fan xifrades (HTTPS) i la base de dades '
          'aplica regles d\'accés (Row Level Security) perquè cada usuari '
          'només pugui llegir i modificar les seves pròpies dades privades.',
        ),

        LegalSectionTitle('8. Menors d\'edat'),
        LegalParagraph(
          'GameShelf no està dirigida a menors de 14 anys. No recollim '
          'conscientment dades de menors per sota d\'aquesta edat.',
        ),

        LegalSectionTitle('9. Canvis a aquesta política'),
        LegalParagraph(
          'Podem actualitzar aquesta política per adaptar-la a canvis '
          'legals o del servei. T\'avisarem dins l\'aplicació si els canvis '
          'són rellevants.',
        ),
      ],
    );
  }
}
