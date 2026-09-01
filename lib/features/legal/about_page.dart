import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameshelf/features/legal/privacy_policy_page.dart'
    show contactEmail;
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

const _appVersion = '1.0.0';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Sobre GameShelf',
      children: [
        const SizedBox(height: 8),

        const Center(
          child: Icon(Icons.sports_esports, size: 64, color: Colors.deepPurple),
        ),

        const SizedBox(height: 12),

        const Center(
          child: Text(
            'GameShelf',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        Center(
          child: Text(
            'Versió $_appVersion',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),

        const SizedBox(height: 28),

        const LegalParagraph(
          'GameShelf és una aplicació social per als jugadors que permet '
          'fer seguiment de la teva biblioteca de videojocs: '
          'registra a què estàs jugant, marca els teus preferits, '
          'escriu reviews i comparteix la teva activitat '
          'amb amics, i descobreix nous videojocs.',
        ),

        const LegalSectionTitle('Desenvolupador'),
        const LegalParagraph('Jordi Bertomeu Primo'),

        const LegalSectionTitle('Contacte'),
        LegalParagraph(contactEmail),

        const LegalSectionTitle('Dades del catàleg de jocs'),
        const LegalParagraph(
          'La informació dels jocs (títols, portades, descripcions) prové '
          'd\'IGDB.',
        ),

        const LegalSectionTitle('Documents legals'),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Política de privacitat'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/privacy'),
        ),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cookie_outlined),
          title: const Text('Política de cookies'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/cookies'),
        ),
      ],
    );
  }
}
