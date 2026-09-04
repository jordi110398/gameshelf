import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/llamp_strings.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/widgets/app_logo.dart';
import 'package:gameshelf/core/widgets/bookshelf_background.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';
import 'package:gameshelf/core/widgets/shelf_led_strip.dart';
import 'package:gameshelf/core/widgets/shelf_ledge.dart';
import 'package:gameshelf/core/widgets/shimmer_box.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/features/llamp/my_shelves_page.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/repositories/shelf_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LlampPage extends StatefulWidget {
  const LlampPage({super.key});

  @override
  State<LlampPage> createState() => LlampPageState();
}

class LlampPageState extends State<LlampPage> {
  late final ShelfRepository repository;

  List<Game> recommendations = [];
  List<ShelfFeedItem> friendsShelves = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    repository = ShelfRepository(Supabase.instance.client);

    refresh();
  }

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        repository.getRecommendations(),
        repository.getLlampFeed(),
      ]);

      if (!mounted) return;

      setState(() {
        recommendations = results[0] as List<Game>;
        friendsShelves = results[1] as List<ShelfFeedItem>;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${LlampStrings.loadFailedPrefix}${friendlyError(e)}'),
        ),
      );
    }
  }

  Future<void> _openGame(Game game) async {
    await pushFade(context, (_) => GameDetailPage(game: game));
  }

  Future<void> _openMyShelves() async {
    await pushFade(context, (_) => const MyShelvesPage());
    await refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppLogo.width(context),
        leading: const AppLogo(),
        title: const Text(LlampStrings.appBarTitle),
        actions: [
          IconButton(
            tooltip: LlampStrings.myShelvesAction,
            icon: const Icon(Icons.grid_view_outlined),
            onPressed: _openMyShelves,
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BookshelfBackground()),
          ResponsiveCenter(
            maxWidth: 640,
            child: isLoading ? const _LlampSkeleton() : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            LlampStrings.sectionRecommendations,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildRecommendations(),

          const SizedBox(height: 32),

          const Text(
            LlampStrings.sectionFriendsShelves,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildFriendsShelves(),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    if (recommendations.isEmpty) {
      return WoodDrawerContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              LlampStrings.emptyRecommendationsNoData,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _GameCoverTile(
            game: recommendations[index],
            width: 100,
            onTap: () => _openGame(recommendations[index]),
          );
        },
      ),
    );
  }

  Widget _buildFriendsShelves() {
    if (friendsShelves.isEmpty) {
      return WoodDrawerContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.bolt_outlined, size: 32, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text(
              LlampStrings.emptyFriendsShelves,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ],
        ),
      );
    }

    return Column(
      children: friendsShelves.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _FriendShelfCard(item: item, onOpenGame: _openGame),
        );
      }).toList(),
    );
  }
}

class _FriendShelfCard extends StatelessWidget {
  final ShelfFeedItem item;
  final ValueChanged<Game> onOpenGame;

  const _FriendShelfCard({required this.item, required this.onOpenGame});

  @override
  Widget build(BuildContext context) {
    final profile = item.profile;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          const Positioned.fill(child: BookshelfBackground()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage:
                          profile.avatarUrl != null &&
                              profile.avatarUrl!.isNotEmpty
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child:
                          profile.avatarUrl == null ||
                              profile.avatarUrl!.isEmpty
                          ? const Icon(Icons.person, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.shelf.title} · @${profile.nickname}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return ShelfLedStrip(width: constraints.maxWidth);
                  },
                ),

                const SizedBox(height: 4),

                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.games.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final game = item.games[index];

                      return _GameCoverTile(
                        game: game,
                        width: 80,
                        onTap: () => onOpenGame(game),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                const ShelfLedge(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCoverTile extends StatelessWidget {
  final Game game;
  final double width;
  final VoidCallback onTap;

  const _GameCoverTile({
    required this.game,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: game.coverUrl != null && game.coverUrl!.isNotEmpty
                ? Image.network(
                    game.coverUrl!,
                    fit: BoxFit.cover,
                    cacheWidth: 200,
                    errorBuilder: (_, _, _) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.videogame_asset),
    );
  }
}

class _LlampSkeleton extends StatelessWidget {
  const _LlampSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const ShimmerBox(
          height: 150,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        const SizedBox(height: 32),
        const ShimmerBox(
          height: 220,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ],
    );
  }
}
