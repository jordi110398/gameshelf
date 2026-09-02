import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/widgets/floating_pill.dart';
import 'package:gameshelf/core/widgets/pressable_scale.dart';
import 'package:gameshelf/core/widgets/shimmer_box.dart';
import 'package:gameshelf/features/home/home_page.dart';
import 'package:gameshelf/features/search/search_page.dart';
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
    label: AppStrings.navHome,
  ),
  _NavItemData(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    label: AppStrings.navSocial,
  ),
  _NavItemData(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: AppStrings.navProfile,
  ),
];

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  final _homeKey = GlobalKey<HomePageState>();
  final _socialKey = GlobalKey<SocialPageState>();
  final _profileKey = GlobalKey<ProfileTabState>();

  void _selectTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Com que l'`IndexedStack` manté totes les pestanyes vives, si alguna
    // cosa canvia des d'una altra pantalla (acceptar una sol·licitud des
    // del perfil, marcar un preferit, etc.) la pestanya no es refaria sola
    // en tornar-hi. Ho refresquem explícitament en seleccionar-la.
    if (index == 1) {
      _socialKey.currentState?.loadSocialData();
    } else if (index == 2) {
      _profileKey.currentState?.refresh();
    }
  }

  Future<void> _addGame() async {
    await pushFade(context, (_) => const SearchPage());

    _homeKey.currentState?.refresh();
    _profileKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(key: _homeKey),
              SocialPage(key: _socialKey),
              ProfileTab(key: _profileKey),
            ],
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
                child: _FloatingNavBar(
                  currentIndex: _currentIndex,
                  onSelect: _selectTab,
                  onAddGame: _addGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BARRA DE NAVEGACIÓ FLOTANT
// ─────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAddGame;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.onSelect,
    required this.onAddGame,
  });

  @override
  Widget build(BuildContext context) {
    // 5 caselles simètriques: [Inici] [Llamp (inactiu, de moment)] [+]
    // [Social] [Perfil]. Amb el mateix nombre de caselles a cada costat,
    // el botó '+' ja queda centrat sense necessitat de cap truc de `Stack`.
    //
    // La pestanya de recomanacions (llamp) encara no fa res: és un avançament
    // visual de la futura funcionalitat, entre Inici i el botó '+'.
    return FloatingPill(
      child: Row(
        children: [
          Expanded(child: _navTab(context, 0)),
          Expanded(child: _buildInertTab(context)),
          Expanded(child: _AddGameButton(onTap: onAddGame)),
          Expanded(child: _navTab(context, 1)),
          Expanded(child: _navTab(context, 2)),
        ],
      ),
    );
  }

  Widget _buildInertTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Icon(
        Icons.bolt,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _navTab(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = _navItems[index];
    final isSelected = index == currentIndex;

    return PressableScale(
      scale: 0.85,
      onTap: () => onSelect(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isSelected ? item.selectedIcon : item.icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGameButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddGameButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PressableScale(
        scale: 0.85,
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PESTANYA DE PERFIL
// ─────────────────────────────────────────────

/// Pestanya de perfil: recupera el perfil propi i el manté viu dins de
/// l'`IndexedStack`, ja que `UserProfilePage` exigeix un [Profile] ja
/// carregat. Exposa [refresh] perquè el shell la pugui refrescar en tornar
/// a la pestanya, o després d'afegir un joc des de la barra inferior.
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  late final ProfileRepository repository;
  Profile? profile;
  bool isLoading = true;

  // Canvia cada `refresh()` per forçar que `UserProfilePage` es torni a
  // muntar (i per tant recarregui les seves dades), ja que l'`IndexedStack`
  // no la destrueix mai sola.
  int _refreshToken = 0;

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

  Future<void> refresh() async {
    final myProfile = await repository.getMyProfile();

    if (!mounted) return;

    setState(() {
      profile = myProfile;
      _refreshToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: _ProfileSkeleton());
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('No s\'ha pogut carregar el perfil')),
      );
    }

    return UserProfilePage(key: ValueKey(_refreshToken), profile: profile!);
  }
}

/// Esquelet de càrrega del perfil, en lloc d'un `CircularProgressIndicator`
/// genèric: dona una idea de la forma real de la pantalla mentre carrega.
class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerBox(height: 152, borderRadius: BorderRadius.zero),
          const SizedBox(height: 44),
          Center(
            child: ShimmerBox(
              width: 140,
              height: 20,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ShimmerBox(
              height: 76,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(3, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == 2 ? 0 : 10),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: ShimmerBox(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
