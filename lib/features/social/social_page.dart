import 'package:flutter/material.dart';
import 'package:gameshelf/features/profile/user_profile_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(
      Supabase.instance.client,
    );

    searchController = TextEditingController();
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
        SnackBar(
          content: Text(
            'No s\'han pogut buscar els usuaris: $e',
          ),
        ),
      );
    }
  }

  Future<void> openProfile(Profile profile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserProfilePage(
          profile: profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: Column(
        children: [
          // ─────────────────────────────
          // CERCADOR
          // ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              12,
            ),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                searchProfiles();
              },
              decoration: InputDecoration(
                hintText: 'Buscar usuaris...',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                  ),
                  onPressed: searchProfiles,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
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
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!hasSearched) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        text: 'Busca altres usuaris de GameShelf',
      );
    }

    if (profiles.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_search,
        text: 'No s\'han trobat usuaris',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        24,
      ),
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

  Widget _buildEmptyState({
    required IconData icon,
    required String text,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 56,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest,
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
                    profile.avatarUrl != null &&
                            profile.avatarUrl!.isNotEmpty
                        ? NetworkImage(
                            profile.avatarUrl!,
                          )
                        : null,
                child: profile.avatarUrl == null ||
                        profile.avatarUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 28,
                      )
                    : null,
              ),

              const SizedBox(width: 14),

              // INFORMACIÓ
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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

              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}