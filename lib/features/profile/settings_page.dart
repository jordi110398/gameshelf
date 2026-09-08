import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
import 'package:gameshelf/core/services/theme_service.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/profile_strings.dart';
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

const _woodLabels = {
  ShelfWoodColor.walnut: ProfileStrings.shelfWoodWalnut,
  ShelfWoodColor.oak: ProfileStrings.shelfWoodOak,
  ShelfWoodColor.ebony: ProfileStrings.shelfWoodEbony,
  ShelfWoodColor.cherry: ProfileStrings.shelfWoodCherry,
  ShelfWoodColor.birch: ProfileStrings.shelfWoodBirch,
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

  Future<void> _setTheme(AppThemeOption option) async {
    try {
      await ThemeService.instance.setTheme(option);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${ProfileStrings.themeChangeFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
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
            '${ProfileStrings.shelfStyleChangeFailedPrefix}${friendlyError(e)}',
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
            '${ProfileStrings.shelfStyleChangeFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSavingShelfStyle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileStrings.settingsAppBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          WoodDrawerContainer(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(ProfileStrings.editProfileTooltip),
              subtitle: const Text(ProfileStrings.settingsEditProfileSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openEditProfile,
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            ProfileStrings.themeSectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<AppThemeOption>(
            valueListenable: ThemeService.instance.current,
            builder: (context, selected, _) {
              return Row(
                children: [
                  Expanded(
                    child: _ThemeOptionCard(
                      label: ProfileStrings.themeLight,
                      colors: const [Color(0xFFF5F4F8), Color(0xFF8B5CF6)],
                      selected: selected == AppThemeOption.light,
                      onTap: () => _setTheme(AppThemeOption.light),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThemeOptionCard(
                      label: ProfileStrings.themeDark,
                      colors: const [Color(0xFF0D0D14), Color(0xFF8B5CF6)],
                      selected: selected == AppThemeOption.dark,
                      onTap: () => _setTheme(AppThemeOption.dark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThemeOptionCard(
                      label: ProfileStrings.themeGba,
                      colors: const [Color(0xFF6E2FE0), Color(0xFFFF3B6B)],
                      selected: selected == AppThemeOption.gba,
                      onTap: () => _setTheme(AppThemeOption.gba),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          const Text(
            ProfileStrings.shelfStyleSectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          WoodDrawerContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProfileStrings.shelfLightsLabel,
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
                      segments: const [
                        ButtonSegment(
                          value: ShelfLightStyle.neon,
                          label: Text(ProfileStrings.shelfLightsNeon),
                          icon: Icon(Icons.bolt),
                        ),
                        ButtonSegment(
                          value: ShelfLightStyle.bulbs,
                          label: Text(ProfileStrings.shelfLightsBulbs),
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
                  ProfileStrings.shelfWoodLabel,
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
                                _woodLabels[color]!,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          OutlinedButton.icon(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text(AppStrings.actionLogout),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.label,
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade700,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(colors: colors),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
