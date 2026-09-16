import 'package:flutter/widgets.dart';
import 'package:gameshelf/l10n/app_localizations.dart';

/// Accés curt a les cadenes traduïdes: `context.l10n.camp` en lloc de
/// `AppLocalizations.of(context)!.camp`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
