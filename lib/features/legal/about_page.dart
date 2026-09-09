import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gameshelf/core/services/pwa_install_service.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

const _appVersion = '1.0.0';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _installService = PwaInstallService();

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: context.l10n.aboutTitle,
      children: [
        const SizedBox(height: 8),

        const Center(
          child: Image(
            image: AssetImage('assets/logo.png'),
            width: 88,
            height: 88,
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Text(
            context.l10n.aboutAppName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        Center(
          child: Text(
            '${context.l10n.aboutVersionLabel} $_appVersion',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),

        const SizedBox(height: 28),

        LegalParagraph(context.l10n.aboutDescription),

        LegalSectionTitle(context.l10n.aboutDeveloperTitle),
        LegalParagraph(context.l10n.aboutDeveloperName),
        LegalParagraph(context.l10n.aboutDeveloperBio),

        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => launchUrl(
              Uri.parse(context.l10n.aboutDeveloperPortfolioUrl),
              webOnlyWindowName: '_blank',
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.open_in_new, size: 16),
                const SizedBox(width: 6),
                Text(
                  context.l10n.aboutDeveloperPortfolioLabel,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        LegalSectionTitle(context.l10n.aboutDevelopmentTitle),
        LegalParagraph(context.l10n.aboutDevelopmentBody),

        LegalSectionTitle(context.l10n.aboutContactTitle),
        LegalParagraph(context.l10n.contactEmail),

        LegalSectionTitle(context.l10n.aboutCatalogDataTitle),
        LegalParagraph(context.l10n.aboutCatalogDataBody),

        if (!_installService.isStandalone) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.install_mobile_outlined),
            title: Text(context.l10n.installAppTitle),
            subtitle: Text(context.l10n.installAppSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                _installService.promptOrShowInstallInstructions(context),
          ),
        ],

        LegalSectionTitle(context.l10n.aboutLegalDocumentsTitle),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(context.l10n.privacyTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/privacy'),
        ),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cookie_outlined),
          title: Text(context.l10n.cookiesTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/cookies'),
        ),
      ],
    );
  }
}
