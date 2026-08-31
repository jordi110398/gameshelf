import 'package:flutter/material.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/repositories/friendship_repository.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:gameshelf/features/activity/widgets/activity_card.dart';
import 'package:gameshelf/features/activity/activity_feed_page.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late final ProfileRepository repository;
  late final TextEditingController searchController;
  late final ActivityRepository activityRepository;

  List<Profile> profiles = [];

  bool isLoading = false;
  bool hasSearched = false;

  late final FriendshipRepository friendshipRepository;

  List<Profile> friends = [];
  List<Map<String, dynamic>> pendingRequests = [];
  List<ActivityItem> activityFeed = [];

  bool isSocialLoading = true;
  bool isRequestsExpanded = true;
  bool isFriendsExpanded = true;
  bool isActivityExpanded = true;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;

    repository = ProfileRepository(Supabase.instance.client);
    friendshipRepository = FriendshipRepository(client);
    activityRepository = ActivityRepository(client);

    searchController = TextEditingController();

    loadSocialData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> searchProfiles() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        profiles = [];
        hasSearched = false;
      });

      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    try {
      final results = await repository.searchProfiles(query);

      if (!mounted) return;

      setState(() {
        profiles = results;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'han pogut buscar els usuaris: ${friendlyError(e)}')),
      );
    }
  }

  Future<void> openProfile(Profile profile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfilePage(profile: profile)),
    );
  }

  Future<void> loadSocialData() async {
    try {
      final friendIds = await friendshipRepository.getFriendIds();
      final loadedFriends = await repository.getProfilesByIds(friendIds);

      final requests = await friendshipRepository.getPendingRequests();
      final activity = await activityRepository.getFeed(limit: 15);

      if (!mounted) return;

      setState(() {
        friends = loadedFriends;
        pendingRequests = requests;
        activityFeed = activity;
        isSocialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSocialLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No s\'han pogut carregar les dades socials: ${friendlyError(e)}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Column(
        children: [
          // ─────────────────────────────
          // CERCADOR
          // ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                searchProfiles();
              },
              decoration: InputDecoration(
                hintText: 'Buscar usuaris...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: searchProfiles,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ─────────────────────────────
          // RESULTATS
          // ─────────────────────────────
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildEmptyFriends() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 42, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          Text(
            'Encara no tens amics',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Busca altres usuaris de GameShelf per afegir-los.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (isLoading || isSocialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ─────────────────────────────
    // NO ESTEM BUSCANT
    // ─────────────────────────────

    if (!hasSearched) {
      return _buildSocialHome();
    }

    // ─────────────────────────────
    // RESULTATS DE CERCA
    // ─────────────────────────────

    if (profiles.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_search,
        text: 'No s\'han trobat usuaris',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: profiles.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final profile = profiles[index];

        return _ProfileTile(
          profile: profile,
          onTap: () {
            openProfile(profile);
          },
        );
      },
    );
  }

  Widget _buildSocialHome() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        // ─────────────────────────────
        // SOL·LICITUDS
        // ─────────────────────────────
        if (pendingRequests.isNotEmpty) ...[
          _buildSectionTile(
            icon: Icons.person_add_outlined,
            title: 'Sol·licituds',
            count: pendingRequests.length,
            isExpanded: isRequestsExpanded,
            onExpansionChanged: (value) {
              setState(() => isRequestsExpanded = value);
            },
            children: pendingRequests
                .map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildPendingRequest(request),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
        ],

        // ─────────────────────────────
        // AMICS
        // ─────────────────────────────
        _buildSectionTile(
          icon: Icons.people_outline,
          title: 'Amics',
          count: friends.length,
          isExpanded: isFriendsExpanded,
          onExpansionChanged: (value) {
            setState(() => isFriendsExpanded = value);
          },
          children: friends.isEmpty
              ? [_buildEmptyFriends()]
              : friends
                    .map(
                      (friend) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ProfileTile(
                          profile: friend,
                          onTap: () => openProfile(friend),
                        ),
                      ),
                    )
                    .toList(),
        ),

        const SizedBox(height: 20),

        // ─────────────────────────────
        // ACTIVITAT
        // ─────────────────────────────
        if (activityFeed.isNotEmpty)
          _buildSectionTile(
            icon: Icons.dynamic_feed_outlined,
            title: 'Resum activitats',
            count: activityFeed.length,
            isExpanded: isActivityExpanded,
            onExpansionChanged: (value) {
              setState(() => isActivityExpanded = value);
            },
            children: [
              ...activityFeed.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ActivityCard(item: item),
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActivityFeedPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Veure més'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSectionTile({
    required IconData icon,
    required String title,
    required int count,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: Theme.of(context).colorScheme.primary,
          collapsedIconColor: Colors.grey.shade500,
          title: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildPendingRequest(Map<String, dynamic> request) {
    final requesterId = request['requester_id'] as String;

    return FutureBuilder<Profile?>(
      future: repository.getProfileById(requesterId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data!;

        return _PendingRequestTile(
          profile: profile,
          onAccept: () async {
            await friendshipRepository.acceptFriendRequest(
              request['id'].toString(),
            );

            await loadSocialData();
          },
          onReject: () async {
            await friendshipRepository.rejectFriendRequest(
              request['id'].toString(),
            );

            await loadSocialData();
          },
        );
      },
    );
  }

  Widget _buildEmptyState({required IconData icon, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onTap;

  const _ProfileTile({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // AVATAR
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                    ? const Icon(Icons.person, size: 28)
                    : null,
              ),

              const SizedBox(width: 14),

              // INFORMACIÓ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${profile.nickname}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (profile.bio != null &&
                        profile.bio!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        profile.bio!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingRequestTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingRequestTile({
    required this.profile,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                  ? NetworkImage(profile.avatarUrl!)
                  : null,
              child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                '@${profile.nickname}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            IconButton(
              tooltip: 'Rebutjar',
              onPressed: onReject,
              icon: const Icon(Icons.close),
            ),

            IconButton(
              tooltip: 'Acceptar',
              onPressed: onAccept,
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}
