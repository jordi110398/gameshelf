import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/core/services/locale_service.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
import 'package:gameshelf/features/profile/edit_profile_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/models/shelf_style.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _woodSwatches = {
  ShelfWoodColor.walnut: Color(0xFF5A3A22),
  ShelfWoodColor.oak: Color(0xFF8A5A2B),
  ShelfWoodColor.ebony: Color(0xFF2B2620),
  ShelfWoodColor.cherry: Color(0xFF7A3327),
  ShelfWoodColor.birch: Color(0xFFC9B48C),
};

Map<ShelfWoodColor, String> _woodLabels(BuildContext context) => {
  ShelfWoodColor.walnut: context.l10n.shelfWoodWalnut,
  ShelfWoodColor.oak: context.l10n.shelfWoodOak,
  ShelfWoodColor.ebony: context.l10n.shelfWoodEbony,
  ShelfWoodColor.cherry: context.l10n.shelfWoodCherry,
  ShelfWoodColor.birch: context.l10n.shelfWoodBirch,
};

Map<ShelfDecoration, String> _decorationLabels(BuildContext context) => {
  ShelfDecoration.none: context.l10n.shelfDecorationNone,
  ShelfDecoration.poppy: context.l10n.shelfDecorationPoppy,
  ShelfDecoration.cactus: context.l10n.shelfDecorationCactus,
  ShelfDecoration.azalea: context.l10n.shelfDecorationAzalea,
};

class SettingsPage extends StatefulWidget {
  final Profile profile;

  const SettingsPage({super.key, required this.profile});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final ProfileRepository repository;
  late Profile profile;
  bool isSavingShelfStyle = false;

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(Supabase.instance.client);
    profile = widget.profile;
  }

  Future<void> _openEditProfile() async {
    final profileToEdit = await repository.getMyProfile() ?? profile;

    if (!mounted) return;

    final updatedProfile = await pushFade<Profile>(
      context,
      (_) => EditProfilePage(profile: profileToEdit),
    );

    if (updatedProfile != null && mounted) {
      setState(() => profile = updatedProfile);
    }
  }

  Future<void> _setLightStyle(ShelfLightStyle style) async {
    setState(() => isSavingShelfStyle = true);

    try {
      await ShelfSkinService.instance.setLightStyle(style);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.shelfStyleChangeFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingShelfStyle = false);
    }
  }

  Future<void> _setWoodColor(ShelfWoodColor color) async {
    setState(() => isSavingShelfStyle = true);

    try {
      await ShelfSkinService.instance.setWoodColor(color);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.shelfStyleChangeFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingShelfStyle = false);
    }
  }

  Set<ShelfDecoration> _toggled(
    Set<ShelfDecoration> current,
    ShelfDecoration decoration,
  ) {
    final next = {...current};

    if (!next.remove(decoration)) {
      next.add(decoration);
    }

    return next;
  }

  Future<void> _setDecorations(Set<ShelfDecoration> decorations) async {
    setState(() => isSavingShelfStyle = true);

    try {
      await ShelfSkinService.instance.setDecorations(decorations);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.shelfStyleChangeFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingShelfStyle = false);
    }
  }

  Future<void> _setCoverStyle(ShelfCoverStyle style) async {
    setState(() => isSavingShelfStyle = true);

    try {
      await ShelfSkinService.instance.setCoverStyle(style);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.shelfStyleChangeFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingShelfStyle = false);
    }
  }

  bool isSavingLocale = false;

  Future<void> _setLocale(Locale locale) async {
    setState(() => isSavingLocale = true);

    try {
      await LocaleService.instance.setLocale(locale);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.languageChangeFailedPrefix}${friendlyError(context, e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingLocale = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsAppBarTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          WoodDrawerContainer(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(context.l10n.editProfileTooltip),
              subtitle: Text(context.l10n.settingsEditProfileSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openEditProfile,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            context.l10n.shelfStyleSectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.shelfStyleSectionSubtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 14),

          WoodDrawerContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.shelfWoodLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<ShelfWoodColor>(
                  valueListenable: ShelfSkinService.instance.woodColor,
                  builder: (context, currentColor, _) {
                    return Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: ShelfWoodColor.values.map((color) {
                        final isSelected = currentColor == color;

                        return GestureDetector(
                          onTap: isSavingShelfStyle
                              ? null
                              : () => _setWoodColor(color),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _woodSwatches[color],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _woodLabels(context)[color]!,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  context.l10n.shelfLightsLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<ShelfLightStyle>(
                  valueListenable: ShelfSkinService.instance.lightStyle,
                  builder: (context, currentStyle, _) {
                    return SegmentedButton<ShelfLightStyle>(
                      segments: [
                        ButtonSegment(
                          value: ShelfLightStyle.neon,
                          label: Text(context.l10n.shelfLightsNeon),
                          icon: Icon(Icons.bolt),
                        ),
                        ButtonSegment(
                          value: ShelfLightStyle.bulbs,
                          label: Text(context.l10n.shelfLightsBulbs),
                          icon: Icon(Icons.lightbulb_outline),
                        ),
                      ],
                      selected: {currentStyle},
                      onSelectionChanged: isSavingShelfStyle
                          ? null
                          : (selection) => _setLightStyle(selection.first),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  context.l10n.shelfDecorationLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.shelfDecorationHint,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<Set<ShelfDecoration>>(
                  valueListenable: ShelfSkinService.instance.decorations,
                  builder: (context, currentDecorations, _) {
                    return Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: ShelfDecoration.values.map((decoration) {
                        final isNone = decoration == ShelfDecoration.none;
                        final isSelected = isNone
                            ? currentDecorations.isEmpty
                            : currentDecorations.contains(decoration);
                        final path = decoration.assetPath;

                        return GestureDetector(
                          onTap: isSavingShelfStyle
                              ? null
                              : () => _setDecorations(
                                  isNone
                                      ? const {}
                                      : _toggled(
                                          currentDecorations,
                                          decoration,
                                        ),
                                ),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: path == null
                                    ? Icon(
                                        Icons.not_interested,
                                        size: 20,
                                        color: Colors.grey.shade500,
                                      )
                                    : Image.asset(
                                        path,
                                        fit: BoxFit.contain,
                                        cacheHeight: 96,
                                      ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _decorationLabels(context)[decoration]!,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  context.l10n.shelfCoverStyleLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<ShelfCoverStyle>(
                  valueListenable: ShelfSkinService.instance.coverStyle,
                  builder: (context, currentStyle, _) {
                    return SegmentedButton<ShelfCoverStyle>(
                      segments: [
                        ButtonSegment(
                          value: ShelfCoverStyle.plain,
                          label: Text(context.l10n.shelfCoverStylePlain),
                          icon: Icon(Icons.crop_square),
                        ),
                        ButtonSegment(
                          value: ShelfCoverStyle.cartridge,
                          label: Text(context.l10n.shelfCoverStyleCartridge),
                          icon: Icon(Icons.videogame_asset),
                        ),
                      ],
                      selected: {currentStyle},
                      onSelectionChanged: isSavingShelfStyle
                          ? null
                          : (selection) => _setCoverStyle(selection.first),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            context.l10n.languageSectionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          WoodDrawerContainer(
            child: ValueListenableBuilder<Locale>(
              valueListenable: LocaleService.instance.locale,
              builder: (context, currentLocale, _) {
                return SegmentedButton<Locale>(
                  segments: [
                    ButtonSegment(
                      value: const Locale('ca'),
                      label: Text(context.l10n.languageCatalan),
                    ),
                    ButtonSegment(
                      value: const Locale('es'),
                      label: Text(context.l10n.languageSpanish),
                    ),
                    ButtonSegment(
                      value: const Locale('en'),
                      label: Text(context.l10n.languageEnglish),
                    ),
                  ],
                  selected: {currentLocale},
                  onSelectionChanged: isSavingLocale
                      ? null
                      : (selection) => _setLocale(selection.first),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          OutlinedButton.icon(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
            label: Text(context.l10n.actionLogout),
          ),
        ],
      ),
    );
  }
}
