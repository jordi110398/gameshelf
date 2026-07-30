import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/repositories/igdb_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/features/game/pages/game_detail_page.dart';

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

  Future<void> search() async {
    setState(() => loading = true);

    games = await repository.searchGames(controller.text);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar jocs")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: SearchBar(
              controller: controller,
              hintText: "Buscar...",
              trailing: [
                IconButton(onPressed: search, icon: const Icon(Icons.search)),
              ],
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: games.length,

                    itemBuilder: (_, i) {
                      final game = games[i];

                      return ListTile(
                        leading: game.coverUrl != null
                            ? Image.network(game.coverUrl!, width: 50)
                            : null,

                        title: Text(game.title),

                        subtitle: Text(game.releaseDate?.year.toString() ?? ""),

                        trailing: const Icon(Icons.chevron_right),

                        onTap: () async {
                          final refresh = await Navigator.push(
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
        ],
      ),
    );
  }
}
