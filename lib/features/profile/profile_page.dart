import 'package:flutter/material.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/features/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileRepository repository;

  Profile? profile;
  ProfileStats? stats;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(Supabase.instance.client);

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final results = await Future.wait([
        repository.getMyProfile(),
        repository.getMyStats(),
      ]);

      if (!mounted) return;

      setState(() {
        profile = results[0] as Profile?;
        stats = results[1] as ProfileStats;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No s\'ha pogut carregar el perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('El meu perfil')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? _buildNoProfile()
          : _buildProfile(),
    );
  }

  Widget _buildNoProfile() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Encara no tens un perfil creat.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProfile() {
    final currentProfile = profile!;
    final currentStats = stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─────────────────────────────
          // AVATAR
          // ─────────────────────────────
          CircleAvatar(
            radius: 55,

            backgroundImage:
                currentProfile.avatarUrl != null &&
                    currentProfile.avatarUrl!.isNotEmpty
                ? NetworkImage(currentProfile.avatarUrl!)
                : null,

            child:
                currentProfile.avatarUrl == null ||
                    currentProfile.avatarUrl!.isEmpty
                ? const Icon(Icons.person, size: 55)
                : null,
          ),

          const SizedBox(height: 20),

          // ─────────────────────────────
          // NICKNAME
          // ─────────────────────────────
          Text(
            '@${currentProfile.nickname}',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          // ─────────────────────────────
          // BIO
          // ─────────────────────────────
          if (currentProfile.bio != null &&
              currentProfile.bio!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),

            Text(
              currentProfile.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],

          const SizedBox(height: 32),

          // ─────────────────────────────
          // ESTADÍSTIQUES
          // ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,

              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              children: [
                Expanded(
                  child: _ProfileStat(
                    value: currentStats.games.toString(),
                    label: 'Jocs',
                  ),
                ),

                Expanded(
                  child: _ProfileStat(
                    value: currentStats.completed.toString(),
                    label: 'Completats',
                  ),
                ),

                Expanded(
                  child: _ProfileStat(
                    value: currentStats.reviews.toString(),
                    label: 'Reviews',
                  ),
                ),

                Expanded(
                  child: _ProfileStat(
                    value: '${currentStats.hours}h',
                    label: 'Hores',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ─────────────────────────────
          // EDITAR
          // ─────────────────────────────
          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(profile: currentProfile),
                  ),
                );

                if (updated == true) {
                  await loadProfile();
                }
              },

              icon: const Icon(Icons.edit),

              label: const Text('Editar perfil'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
