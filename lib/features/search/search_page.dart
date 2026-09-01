import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/repositories/igdb_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final repository = IgdbRepository(Supabase.instance.client);
  final controller = TextEditingController();

  List<Game> games = [];

  bool loading = false;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      setState(() {
        games = [];
        loading = false;
      });
      return;
    }

    setState(() {
      loading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await repository.searchGames(value.trim());

      if (!mounted) return;

      setState(() {
        games = results;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Buscar jocs...",
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),

              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8,
              ),
            ),
          ),
        ),
      ),

      body: ResponsiveCenter(
        maxWidth: 640,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : games.isEmpty
            ? const Center(child: Text("Busca un joc per començar"))
            : ListView.builder(
                itemCount: games.length,
                itemBuilder: (_, i) {
                  final game = games[i];

                  return ListTile(
                    leading: game.coverUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              game.coverUrl!,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(
                            width: 50,
                            height: 70,
                            child: ColoredBox(color: Colors.grey),
                          ),

                    title: Text(game.title),

                    subtitle: Text(game.releaseDate?.year.toString() ?? ""),

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () async {
                      final refresh = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameDetailPage(game: game),
                        ),
                      );

                      if (refresh == true && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
