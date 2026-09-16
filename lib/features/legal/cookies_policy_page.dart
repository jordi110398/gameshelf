import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

class CookiesPolicyPage extends StatelessWidget {
  const CookiesPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: context.l10n.cookiesTitle,
      children: [
        LegalParagraph(context.l10n.lastUpdated),

        LegalSectionTitle(context.l10n.cookiesNoThirdPartyTitle),
        LegalParagraph(context.l10n.cookiesNoThirdPartyBody),

        LegalSectionTitle(context.l10n.cookiesEssentialTitle),
        LegalParagraph(context.l10n.cookiesEssentialBody1),
        LegalParagraph(context.l10n.cookiesEssentialBody2),

        LegalSectionTitle(context.l10n.cookiesFutureChangesTitle),
        LegalParagraph(context.l10n.cookiesFutureChangesBody),

        LegalSectionTitle(context.l10n.cookiesContactTitle),
        LegalParagraph(context.l10n.cookiesContactBody),
      ],
    );
  }
}
