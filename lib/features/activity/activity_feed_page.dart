import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/activity_item.dart';
import 'package:gameshelf/repositories/activity_repository.dart';
import 'package:gameshelf/features/activity/widgets/activity_card.dart';

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
  bool _hasNewActivity = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    // Comprova cada 30s si hi ha activitat nova (sense recarregar el feed).
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkForNewActivity());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final items = await _repository.getFeed();
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
      _hasNewActivity = false;
    });
  }

  Future<void> _checkForNewActivity() async {
    if (_items.isEmpty) return;
    final hasNew = await _repository.hasNewActivitySince(_items.first.createdAt);
    if (!mounted || !hasNew) return;
    setState(() => _hasNewActivity = true);
  }

  Future<void> _refresh() async {
    final items = await _repository.getFeed();
    if (!mounted) return;
    setState(() {
      _items = items;
      _hasNewActivity = false;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activitat')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: _items.isEmpty
                      ? ListView(
                          controller: _scrollController,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Center(child: Text('Encara no hi ha activitat.')),
                            ),
                          ],
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => ActivityCard(item: _items[index]),
                        ),
                ),

                // BOTÓ "ACTIVITAT NOVA"
                if (_hasNewActivity)
                  Positioned(
                    top: 12,
                    child: SafeArea(
                      child: FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.arrow_upward, size: 18),
                        label: const Text('Hi ha activitat nova'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}