import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gameshelf/core/services/pwa_install_service.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/legal_strings.dart';
import 'package:gameshelf/features/legal/widgets/legal_page_scaffold.dart';

const _appVersion = '1.0.0';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _installService = PwaInstallService();

  Future<void> _handleInstallTap(BuildContext context) async {
    if (_installService.isNativePromptAvailable) {
      final accepted = await _installService.promptInstall();

      if (!context.mounted || !accepted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(LegalStrings.installAppAcceptedMessage)),
      );

      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(LegalStrings.installAppDialogTitle),
          content: const Text(LegalStrings.installAppDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.actionAccept),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: LegalStrings.aboutTitle,
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

        const Center(
          child: Text(
            LegalStrings.aboutAppName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        Center(
          child: Text(
            '${LegalStrings.aboutVersionLabel} $_appVersion',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),

        const SizedBox(height: 28),

        const LegalParagraph(LegalStrings.aboutDescription),

        const LegalSectionTitle(LegalStrings.aboutDeveloperTitle),
        const LegalParagraph(LegalStrings.aboutDeveloperName),
        const LegalParagraph(LegalStrings.aboutDeveloperBio),

        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => launchUrl(
              Uri.parse(LegalStrings.aboutDeveloperPortfolioUrl),
              webOnlyWindowName: '_blank',
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.open_in_new, size: 16),
                const SizedBox(width: 6),
                Text(
                  LegalStrings.aboutDeveloperPortfolioLabel,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const LegalSectionTitle(LegalStrings.aboutDevelopmentTitle),
        const LegalParagraph(LegalStrings.aboutDevelopmentBody),

        const LegalSectionTitle(LegalStrings.aboutContactTitle),
        const LegalParagraph(LegalStrings.contactEmail),

        const LegalSectionTitle(LegalStrings.aboutCatalogDataTitle),
        const LegalParagraph(LegalStrings.aboutCatalogDataBody),

        if (!_installService.isStandalone) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.install_mobile_outlined),
            title: const Text(LegalStrings.installAppTitle),
            subtitle: const Text(LegalStrings.installAppSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _handleInstallTap(context),
          ),
        ],

        const LegalSectionTitle(LegalStrings.aboutLegalDocumentsTitle),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text(LegalStrings.privacyTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/privacy'),
        ),

        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cookie_outlined),
          title: const Text(LegalStrings.cookiesTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/legal/cookies'),
        ),
      ],
    );
  }
}
