import 'package:flutter/material.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/llamp_strings.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/widgets/wood_drawer_container.dart';
import 'package:gameshelf/features/llamp/edit_shelf_page.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/shelf.dart';
import 'package:gameshelf/repositories/shelf_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyShelvesPage extends StatefulWidget {
  const MyShelvesPage({super.key});

  @override
  State<MyShelvesPage> createState() => _MyShelvesPageState();
}

class _MyShelvesPageState extends State<MyShelvesPage> {
  late final ShelfRepository repository;

  List<Shelf> shelves = [];
  Map<int, Game> gameById = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    repository = ShelfRepository(Supabase.instance.client);
    _load();
  }

  Future<void> _load() async {
    try {
      final loadedShelves = await repository.getMyShelves();

      final allGameIds = loadedShelves
          .expand((s) => s.gameIds)
          .toSet()
          .toList();

      final games = await repository.getGamesByIds(allGameIds);

      if (!mounted) return;

      setState(() {
        shelves = loadedShelves;
        gameById = {for (final g in games) g.igdbId: g};
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

  Future<void> _createShelf() async {
    final controller = TextEditingController();

    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(LlampStrings.newShelfDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: LlampStrings.shelfTitleHint,
            ),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text(AppStrings.actionSave),
            ),
          ],
        );
      },
    );

    if (title == null || title.trim().isEmpty) return;

    try {
      final shelf = await repository.createShelf(title.trim());

      if (!mounted) return;

      await pushFade(context, (_) => EditShelfPage(shelf: shelf));

      await _load();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${LlampStrings.createShelfFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  Future<void> _openShelf(Shelf shelf) async {
    await pushFade(context, (_) => EditShelfPage(shelf: shelf));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(LlampStrings.myShelvesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createShelf,
        icon: const Icon(Icons.add),
        label: const Text(LlampStrings.newShelfAction),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shelves.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              itemCount: shelves.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _ShelfTile(
                  shelf: shelves[index],
                  gameById: gameById,
                  onTap: () => _openShelf(shelves[index]),
                );
              },
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 48,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              LlampStrings.emptyMyShelves,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelfTile extends StatelessWidget {
  final Shelf shelf;
  final Map<int, Game> gameById;
  final VoidCallback onTap;

  const _ShelfTile({
    required this.shelf,
    required this.gameById,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final games = shelf.gameIds
        .map((id) => gameById[id])
        .whereType<Game>()
        .toList();

    return WoodDrawerContainer(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    shelf.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),

            if (shelf.isPinned || shelf.isPublished) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  if (shelf.isPinned) _buildBadge(LlampStrings.pinnedBadge),
                  if (shelf.isPublished)
                    _buildBadge(LlampStrings.publishedBadge),
                ],
              ),
            ],

            const SizedBox(height: 10),

            SizedBox(
              height: 70,
              child: games.isEmpty
                  ? Text(
                      '${shelf.gameIds.length}/8',
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: games.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final game = games[index];

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child:
                                game.coverUrl != null &&
                                    game.coverUrl!.isNotEmpty
                                ? Image.network(
                                    game.coverUrl!,
                                    fit: BoxFit.cover,
                                    cacheWidth: 100,
                                  )
                                : Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
