import 'package:gameshelf/models/game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IgdbRepository {
  final SupabaseClient client;

  IgdbRepository(this.client);

  Future<List<Game>> searchGames(String query) async {
    final response = await client.functions.invoke(
      "igdb-search",
      body: {"query": query},
    );

    final data = response.data as List;

    return data.map((e) => Game.fromMap(e as Map<String, dynamic>)).toList();
  }
}
