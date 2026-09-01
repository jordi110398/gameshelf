import 'package:flutter/material.dart';
import 'package:gameshelf/features/legal/privacy_policy_page.dart'
    show contactEmail;
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

class CookiesPolicyPage extends StatelessWidget {
  const CookiesPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Política de cookies',
      children: [
        const LegalParagraph('Última actualització: setembre de 2026.'),

        const LegalSectionTitle('GameShelf no fa servir cookies de tercers'),
        const LegalParagraph(
          'GameShelf no utilitza cookies de publicitat, seguiment ni '
          'anàlisi (analytics) de cap tipus. No et rastregem entre webs ni '
          'compartim el teu comportament amb tercers amb finalitats '
          'comercials.',
        ),

        const LegalSectionTitle('Emmagatzematge tècnic essencial'),
        const LegalParagraph(
          'Per mantenir la teva sessió iniciada, l\'aplicació guarda un '
          'testimoni de sessió (token d\'autenticació) a l\'emmagatzematge '
          'local del teu navegador, gestionat pel nostre proveïdor '
          'd\'autenticació (Supabase). Aquest emmagatzematge és estrictament '
          'necessari perquè l\'aplicació funcioni (no haver de tornar a '
          'iniciar sessió cada vegada) i no s\'utilitza amb cap altra '
          'finalitat.',
        ),
        const LegalParagraph(
          'Com que es tracta d\'emmagatzematge tècnicament necessari i no '
          'de cookies de seguiment o publicitàries, l\'aplicació no mostra '
          'un bàner de consentiment de cookies.',
        ),

        const LegalSectionTitle('Canvis futurs'),
        const LegalParagraph(
          'Si en el futur incorporéssim eines d\'anàlisi o publicitat que '
          'requereixin cookies no essencials, actualitzarem aquesta '
          'política i, si la normativa ho exigeix, et demanarem el teu '
          'consentiment abans d\'activar-les.',
        ),

        const LegalSectionTitle('Contacte'),
        LegalParagraph(
          'Si tens dubtes sobre aquesta política, escriu-nos a $contactEmail.',
        ),
      ],
    );
  }
}
