import 'package:flutter/material.dart';
import 'package:gameshelf/features/home/home_page.dart';
import 'package:gameshelf/features/social/social_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _NavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const _navItems = [
  _NavItemData(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Inici',
  ),
  _NavItemData(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    label: 'Social',
  ),
  _NavItemData(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Perfil',
  ),
];

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [HomePage(), SocialPage(), _ProfileTab()],
          ),

          // BARRA DE NAVEGACIÓ FLOTANT
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 66,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(33),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: List.generate(_navItems.length, (index) {
                      final item = _navItems[index];
                      final isSelected = index == _currentIndex;

                      return Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(33),
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.18,
                                        )
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  isSelected
                                      ? item.selectedIcon
                                      : item.icon,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pestanya de perfil: recupera el perfil propi i el manté viu dins de
/// l'`IndexedStack`, ja que `UserProfilePage` exigeix un [Profile] ja
/// carregat.
class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  late final ProfileRepository repository;
  Profile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(Supabase.instance.client);
    _load();
  }

  Future<void> _load() async {
    final myProfile = await repository.getMyProfile();

    if (!mounted) return;

    setState(() {
      profile = myProfile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('No s\'ha pogut carregar el perfil')),
      );
    }

    return UserProfilePage(profile: profile!);
  }
}
