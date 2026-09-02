import 'package:flutter/material.dart';
import 'package:gameshelf/core/strings/legal_strings.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

class CookiesPolicyPage extends StatelessWidget {
  const CookiesPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: LegalStrings.cookiesTitle,
      children: const [
        LegalParagraph(LegalStrings.lastUpdated),

        LegalSectionTitle(LegalStrings.cookiesNoThirdPartyTitle),
        LegalParagraph(LegalStrings.cookiesNoThirdPartyBody),

        LegalSectionTitle(LegalStrings.cookiesEssentialTitle),
        LegalParagraph(LegalStrings.cookiesEssentialBody1),
        LegalParagraph(LegalStrings.cookiesEssentialBody2),

        LegalSectionTitle(LegalStrings.cookiesFutureChangesTitle),
        LegalParagraph(LegalStrings.cookiesFutureChangesBody),

        LegalSectionTitle(LegalStrings.cookiesContactTitle),
        LegalParagraph(LegalStrings.cookiesContactBody),
      ],
    );
  }
}
