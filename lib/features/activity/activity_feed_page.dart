import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:gameshelf/features/activity/widgets/activity_card.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

class ActivityFeedPage extends StatefulWidget {
  const ActivityFeedPage({super.key});

  @override
  State<ActivityFeedPage> createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage> {
  final _repository = ActivityRepository(Supabase.instance.client);
  final _scrollController = ScrollController();

  List<ActivityItem> _items = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _hasNewActivity = false;

  Timer? _pollTimer;

  static const int _pageSize = 15;

  @override
  void initState() {
    super.initState();

    _loadInitial();

    _scrollController.addListener(_onScroll);

    // Comprova cada 30s si hi ha activitat nova.
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkForNewActivity(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // ─────────────────────────────
  // CÀRREGA INICIAL
  // ─────────────────────────────

  Future<void> _loadInitial() async {
    try {
      final items = await _repository.getFeed(
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _items = items;
        _isLoading = false;
        _hasNewActivity = false;
        _hasMore = items.length == _pageSize;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut carregar l\'activitat: ${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────
  // SCROLL
  // ─────────────────────────────

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Quan falten 300px per arribar al final,
    // carreguem més activitats.
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  // ─────────────────────────────
  // CARREGAR MÉS
  // ─────────────────────────────

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _items.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final lastItem = _items.last;

      final newItems = await _repository.getFeed(
        before: lastItem.createdAt,
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _items.addAll(newItems);
        _isLoadingMore = false;
        _hasMore = newItems.length == _pageSize;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'han pogut carregar més activitats: ${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────
  // ACTIVITAT NOVA
  // ─────────────────────────────

  Future<void> _checkForNewActivity() async {
    if (_items.isEmpty) return;

    try {
      final hasNew = await _repository.hasNewActivitySince(
        _items.first.createdAt,
      );

      if (!mounted || !hasNew) return;

      setState(() {
        _hasNewActivity = true;
      });
    } catch (_) {
      // No mostrem error perquè és una comprovació automàtica.
    }
  }

  // ─────────────────────────────
  // REFRESH
  // ─────────────────────────────

  Future<void> _refresh() async {
    try {
      final items = await _repository.getFeed(
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _items = items;
        _hasNewActivity = false;
        _hasMore = items.length == _pageSize;
      });

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut actualitzar l\'activitat: ${friendlyError(e)}',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────
  // UI
  // ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activitat'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: _items.isEmpty
                      ? ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Center(
                                child: Text(
                                  'Encara no hi ha activitat.',
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            24,
                          ),
                          itemCount:
                              _items.length +
                              (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            // Loader del final
                            if (index >= _items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return ActivityCard(
                              item: _items[index],
                            );
                          },
                        ),
                ),

                // ─────────────────────────────
                // BOTÓ "ACTIVITAT NOVA"
                // ─────────────────────────────

                if (_hasNewActivity)
                  Positioned(
                    top: 12,
                    child: SafeArea(
                      child: FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(
                          Icons.arrow_upward,
                          size: 18,
                        ),
                        label: const Text(
                          'Hi ha activitat nova',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}