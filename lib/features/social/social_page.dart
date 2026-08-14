import 'package:flutter/material.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/repositories/friendship_repository.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  late final ProfileRepository repository;
  late final TextEditingController searchController;

  List<Profile> profiles = [];

  bool isLoading = false;
  bool hasSearched = false;

  late final FriendshipRepository friendshipRepository;

  List<Profile> friends = [];
  List<Map<String, dynamic>> pendingRequests = [];

  bool isSocialLoading = true;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;

    repository = ProfileRepository(Supabase.instance.client);
    friendshipRepository = FriendshipRepository(client);

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
        SnackBar(content: Text('No s\'han pogut buscar els usuaris: $e')),
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

      if (!mounted) return;

      setState(() {
        friends = loadedFriends;
        pendingRequests = requests;
        isSocialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSocialLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No s\'han pogut carregar les dades socials: $e'),
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
      separatorBuilder: (_, __) {
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
          Row(
            children: [
              const Icon(Icons.person_add_outlined),
              const SizedBox(width: 8),
              Text(
                'Sol·licituds',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pendingRequests.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...pendingRequests.map((request) => _buildPendingRequest(request)),

          const SizedBox(height: 28),
        ],

        // ─────────────────────────────
        // AMICS
        // ─────────────────────────────
        Row(
          children: [
            const Icon(Icons.people_outline),
            const SizedBox(width: 8),
            Text(
              'Amics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '${friends.length}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (friends.isEmpty)
          _buildEmptyFriends()
        else
          ...friends.map(
            (friend) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ProfileTile(
                profile: friend,
                onTap: () {
                  openProfile(friend);
                },
              ),
            ),
          ),
      ],
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
