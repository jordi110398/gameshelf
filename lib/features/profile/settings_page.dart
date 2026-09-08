import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/core/services/shelf_skin_service.dart';
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

const _decorationLabels = {
  ShelfDecoration.none: ProfileStrings.shelfDecorationNone,
  ShelfDecoration.poppy: ProfileStrings.shelfDecorationPoppy,
  ShelfDecoration.cactus: ProfileStrings.shelfDecorationCactus,
  ShelfDecoration.azalea: ProfileStrings.shelfDecorationAzalea,
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

  Future<void> _setDecoration(ShelfDecoration decoration) async {
    setState(() => isSavingShelfStyle = true);

    try {
      await ShelfSkinService.instance.setDecoration(decoration);
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
      appBar: AppBar(title: const Text(ProfileStrings.settingsAppBarTitle)),
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
            ProfileStrings.shelfStyleSectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            ProfileStrings.shelfStyleSectionSubtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 14),

          WoodDrawerContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                const SizedBox(height: 20),

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
                  ProfileStrings.shelfDecorationLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<ShelfDecoration>(
                  valueListenable: ShelfSkinService.instance.decoration,
                  builder: (context, currentDecoration, _) {
                    return Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: ShelfDecoration.values.map((decoration) {
                        final isSelected = currentDecoration == decoration;
                        final path = decoration.assetPath;

                        return GestureDetector(
                          onTap: isSavingShelfStyle
                              ? null
                              : () => _setDecoration(decoration),
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
                                _decorationLabels[decoration]!,
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
