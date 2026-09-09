import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: context.l10n.privacyTitle,
      children: [
        LegalParagraph(context.l10n.lastUpdated),
        LegalParagraph(context.l10n.privacyIntro),

        LegalSectionTitle(context.l10n.privacySection1Title),
        LegalParagraph(context.l10n.privacySection1Body),

        LegalSectionTitle(context.l10n.privacySection2Title),
        LegalBullet(context.l10n.privacySection2Bullet1),
        LegalBullet(context.l10n.privacySection2Bullet2),
        LegalBullet(context.l10n.privacySection2Bullet3),
        LegalBullet(context.l10n.privacySection2Bullet4),

        LegalSectionTitle(context.l10n.privacySection3Title),
        LegalBullet(context.l10n.privacySection3Bullet1),
        LegalBullet(context.l10n.privacySection3Bullet2),
        LegalParagraph(context.l10n.privacySection3Body),

        LegalSectionTitle(context.l10n.privacySection4Title),
        LegalBullet(context.l10n.privacySection4Bullet1),
        LegalBullet(context.l10n.privacySection4Bullet2),
        LegalParagraph(context.l10n.privacySection4Body),

        LegalSectionTitle(context.l10n.privacySection5Title),
        LegalParagraph(context.l10n.privacySection5Body),

        LegalSectionTitle(context.l10n.privacySection6Title),
        LegalParagraph(context.l10n.privacySection6Body1),
        LegalParagraph(context.l10n.privacySection6Body2),

        LegalSectionTitle(context.l10n.privacySection7Title),
        LegalParagraph(context.l10n.privacySection7Body),

        LegalSectionTitle(context.l10n.privacySection8Title),
        LegalParagraph(context.l10n.privacySection8Body),

        LegalSectionTitle(context.l10n.privacySection9Title),
        LegalParagraph(context.l10n.privacySection9Body),
      ],
    );
  }
}
