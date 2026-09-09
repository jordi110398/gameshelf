import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/library_game.dart';
import 'package:gameshelf/models/shelf.dart';
import 'package:gameshelf/repositories/shelf_repository.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _maxGamesPerShelf = 8;

class EditShelfPage extends StatefulWidget {
  final Shelf shelf;

  const EditShelfPage({super.key, required this.shelf});

  @override
  State<EditShelfPage> createState() => _EditShelfPageState();
}

class _EditShelfPageState extends State<EditShelfPage> {
  late final ShelfRepository repository;
  late final SupabaseLibraryRepository libraryRepository;

  late Shelf shelf;
  Map<int, Game> gameById = {};
  bool isLoading = true;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    repository = ShelfRepository(client);
    libraryRepository = SupabaseLibraryRepository(client);

    shelf = widget.shelf;
    _loadGames();
  }

  Future<void> _loadGames() async {
    final games = await repository.getGamesByIds(shelf.gameIds);

    if (!mounted) return;

    setState(() {
      gameById = {for (final g in games) g.igdbId: g};
      isLoading = false;
    });
  }

  void _showError(String prefix, Object e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$prefix${friendlyError(context, e)}')),
    );
  }

  // ─────────────────────────────────────────────
  // RENOMBRAR
  // ─────────────────────────────────────────────

  Future<void> _rename() async {
    final controller = TextEditingController(text: shelf.title);

    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.editShelfTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: context.l10n.shelfTitleHint),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.actionSave),
            ),
          ],
        );
      },
    );

    if (title == null || title.trim().isEmpty || title.trim() == shelf.title) {
      return;
    }

    try {
      await repository.renameShelf(shelf.id, title.trim());

      if (!mounted) return;

      setState(() {
        shelf = Shelf(
          id: shelf.id,
          userId: shelf.userId,
          title: title.trim(),
          emoji: shelf.emoji,
          isPinned: shelf.isPinned,
          isPublished: shelf.isPublished,
          updatedAt: shelf.updatedAt,
          gameIds: shelf.gameIds,
        );
      });
    } catch (e) {
      if (!mounted) return;

      _showError(context.l10n.renameFailedPrefix, e);
    }
  }

  // ─────────────────────────────────────────────
  // FIXAR / PUBLICAR
  // ─────────────────────────────────────────────

  Future<void> _togglePinned(bool value) async {
    setState(() => isBusy = true);

    try {
      if (value) {
        await repository.setPinned(shelf.id);
      } else {
        await repository.unpin(shelf.id);
      }

      if (!mounted) return;

      setState(() {
        shelf = _copyShelfWith(isPinned: value);
        isBusy = false;
      });
    } catch (e) {
      if (mounted) setState(() => isBusy = false);

      if (!mounted) return;

      _showError(
        value ? context.l10n.pinFailedPrefix : context.l10n.unpinFailedPrefix,
        e,
      );
    }
  }

  Future<void> _togglePublished(bool value) async {
    setState(() => isBusy = true);

    try {
      await repository.setPublished(shelf.id, value);

      if (!mounted) return;

      setState(() {
        shelf = _copyShelfWith(isPublished: value);
        isBusy = false;
      });
    } catch (e) {
      if (mounted) setState(() => isBusy = false);

      if (!mounted) return;

      _showError(context.l10n.publishFailedPrefix, e);
    }
  }

  Shelf _copyShelfWith({bool? isPinned, bool? isPublished}) {
    return Shelf(
      id: shelf.id,
      userId: shelf.userId,
      title: shelf.title,
      emoji: shelf.emoji,
      isPinned: isPinned ?? shelf.isPinned,
      isPublished: isPublished ?? shelf.isPublished,
      updatedAt: shelf.updatedAt,
      gameIds: shelf.gameIds,
    );
  }

  // ─────────────────────────────────────────────
  // JOCS
  // ─────────────────────────────────────────────

  Future<void> _pickGame() async {
    if (shelf.gameIds.length >= _maxGamesPerShelf) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.shelfFullMessage)));
      return;
    }

    final library = await libraryRepository.getLibrary();
    final available = library
        .where((g) => !shelf.gameIds.contains(g.game.igdbId))
        .toList();

    if (!mounted) return;

    final picked = await showModalBottomSheet<LibraryGame>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      context.l10n.pickGameSheetTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: available.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                library.isEmpty
                                    ? context.l10n.emptyLibraryForShelf
                                    : context.l10n.allGamesAlreadyInShelf,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: available.length,
                            itemBuilder: (context, index) {
                              final libraryGame = available[index];
                              final game = libraryGame.game;

                              return ListTile(
                                leading: SizedBox(
                                  width: 40,
                                  height: 56,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child:
                                        game.coverUrl != null &&
                                            game.coverUrl!.isNotEmpty
                                        ? Image.network(
                                            game.coverUrl!,
                                            fit: BoxFit.cover,
                                            cacheWidth: 80,
                                          )
                                        : Container(
                                            color: Colors.grey.shade800,
                                          ),
                                  ),
                                ),
                                title: Text(game.title),
                                onTap: () =>
                                    Navigator.pop(context, libraryGame),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (picked == null) return;

    try {
      await repository.addGame(
        shelf.id,
        picked.game.igdbId,
        shelf.gameIds.length,
      );

      if (!mounted) return;

      setState(() {
        shelf = Shelf(
          id: shelf.id,
          userId: shelf.userId,
          title: shelf.title,
          emoji: shelf.emoji,
          isPinned: shelf.isPinned,
          isPublished: shelf.isPublished,
          updatedAt: shelf.updatedAt,
          gameIds: [...shelf.gameIds, picked.game.igdbId],
        );
        gameById[picked.game.igdbId] = picked.game;
      });
    } catch (e) {
      if (!mounted) return;

      _showError(context.l10n.addGameFailedPrefix, e);
    }
  }

  Future<void> _removeGame(int igdbId) async {
    try {
      await repository.removeGame(shelf.id, igdbId);

      if (!mounted) return;

      setState(() {
        shelf = Shelf(
          id: shelf.id,
          userId: shelf.userId,
          title: shelf.title,
          emoji: shelf.emoji,
          isPinned: shelf.isPinned,
          isPublished: shelf.isPublished,
          updatedAt: shelf.updatedAt,
          gameIds: shelf.gameIds.where((id) => id != igdbId).toList(),
        );
      });
    } catch (e) {
      if (!mounted) return;

      _showError(context.l10n.removeGameFailedPrefix, e);
    }
  }

  // ─────────────────────────────────────────────
  // ELIMINAR ESTANTERIA
  // ─────────────────────────────────────────────

  Future<void> _deleteShelf() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.deleteShelfTitle),
          content: Text(context.l10n.deleteShelfBody(shelf.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.actionDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await repository.deleteShelf(shelf.id);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showError(context.l10n.deleteShelfFailedPrefix, e);
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shelf.displayTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.actionEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: _rename,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.pinToProfileTitle),
                  subtitle: Text(context.l10n.pinToProfileSubtitle),
                  value: shelf.isPinned,
                  onChanged: isBusy ? null : _togglePinned,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.publishToLlampTitle),
                  subtitle: Text(context.l10n.publishToLlampSubtitle),
                  value: shelf.isPublished,
                  onChanged: isBusy ? null : _togglePublished,
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                  children: List.generate(_maxGamesPerShelf, (index) {
                    if (index < shelf.gameIds.length) {
                      final game = gameById[shelf.gameIds[index]];

                      return _ShelfSlot(
                        game: game,
                        onRemove: game == null
                            ? null
                            : () => _removeGame(game.igdbId),
                      );
                    }

                    return _EmptySlot(onTap: _pickGame);
                  }),
                ),

                const SizedBox(height: 32),

                OutlinedButton.icon(
                  onPressed: _deleteShelf,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(context.l10n.deleteShelfTitle),
                ),
              ],
            ),
    );
  }
}

class _ShelfSlot extends StatelessWidget {
  final Game? game;
  final VoidCallback? onRemove;

  const _ShelfSlot({required this.game, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                game != null &&
                    game!.coverUrl != null &&
                    game!.coverUrl!.isNotEmpty
                ? Image.network(
                    game!.coverUrl!,
                    fit: BoxFit.cover,
                    cacheWidth: 160,
                  )
                : Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.videogame_asset),
                  ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptySlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: DottedSlotBorder(
        child: Icon(Icons.add, color: Colors.grey.shade500),
      ),
    );
  }
}

/// Marc simple per a una casella buida de l'estanteria (sense la
/// dependència d'un paquet extern per fer-lo literalment "de puntets").
class DottedSlotBorder extends StatelessWidget {
  final Widget child;

  const DottedSlotBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Center(child: child),
    );
  }
}
