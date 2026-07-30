import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/home/widgets/games_grid.dart';
import 'package:gameshelf/features/home/widgets/header.dart';
import 'package:gameshelf/features/search/search_page.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/models/library_game.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final repository = SupabaseLibraryRepository(Supabase.instance.client);

    return Scaffold(
      appBar: AppBar(
        title: const Text("GameShelf"),

        actions: [
          // Botó cerca
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final refresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );

              if (refresh == true && context.mounted) {
                setState(() {});
              }
            },
          ),

          // Botó logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Tancar sessió",
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),

      body: FutureBuilder<List<LibraryGame>>(
        future: repository.getLibrary(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hi ha jocs"));
          }

          return Column(
            children: [
              const Header(),

              Expanded(child: GameGrid(games: snapshot.data!)),
            ],
          );
        },
      ),
    );
  }
}

