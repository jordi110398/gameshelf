import 'package:flutter/material.dart';
import 'package:gameshelf/core/strings/legal_strings.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

/// Reexportat per compatibilitat amb els imports existents
/// (`show contactEmail`) a cookies_policy_page.dart i about_page.dart.
const contactEmail = LegalStrings.contactEmail;

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: LegalStrings.privacyTitle,
      children: const [
        LegalParagraph(LegalStrings.lastUpdated),
        LegalParagraph(LegalStrings.privacyIntro),

        LegalSectionTitle(LegalStrings.privacySection1Title),
        LegalParagraph(LegalStrings.privacySection1Body),

        LegalSectionTitle(LegalStrings.privacySection2Title),
        LegalBullet(LegalStrings.privacySection2Bullet1),
        LegalBullet(LegalStrings.privacySection2Bullet2),
        LegalBullet(LegalStrings.privacySection2Bullet3),
        LegalBullet(LegalStrings.privacySection2Bullet4),

        LegalSectionTitle(LegalStrings.privacySection3Title),
        LegalBullet(LegalStrings.privacySection3Bullet1),
        LegalBullet(LegalStrings.privacySection3Bullet2),
        LegalParagraph(LegalStrings.privacySection3Body),

        LegalSectionTitle(LegalStrings.privacySection4Title),
        LegalBullet(LegalStrings.privacySection4Bullet1),
        LegalBullet(LegalStrings.privacySection4Bullet2),
        LegalParagraph(LegalStrings.privacySection4Body),

        LegalSectionTitle(LegalStrings.privacySection5Title),
        LegalParagraph(LegalStrings.privacySection5Body),

        LegalSectionTitle(LegalStrings.privacySection6Title),
        LegalParagraph(LegalStrings.privacySection6Body1),
        LegalParagraph(LegalStrings.privacySection6Body2),

        LegalSectionTitle(LegalStrings.privacySection7Title),
        LegalParagraph(LegalStrings.privacySection7Body),

        LegalSectionTitle(LegalStrings.privacySection8Title),
        LegalParagraph(LegalStrings.privacySection8Body),

        LegalSectionTitle(LegalStrings.privacySection9Title),
        LegalParagraph(LegalStrings.privacySection9Body),
      ],
    );
  }
}
