import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';
import 'package:gameshelf/models/user_game.dart';
import 'package:gameshelf/models/game_status.dart';
import 'package:gameshelf/repositories/supabase_library_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditGamePage extends StatefulWidget {
  final Game game;
  final UserGame userGame;

  const EditGamePage({super.key, required this.game, required this.userGame});

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  late GameStatus status;
  late int rating;
  late final TextEditingController hoursController;
  late bool favorite;
  late final TextEditingController reviewController;
  final repository = SupabaseLibraryRepository(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    status = widget.userGame.status;
    rating = widget.userGame.rating ?? 0;
    hoursController = TextEditingController(
      text: widget.userGame.hoursPlayed.toString(),
    );
    favorite = widget.userGame.favorite;
    reviewController = TextEditingController(
      text: widget.userGame.review ?? "",
    );
  }

  @override
  void dispose() {
    hoursController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final updatedUserGame = UserGame(
      igdbId: widget.userGame.igdbId,
      status: status,
      rating: rating,
      hoursPlayed: int.tryParse(hoursController.text) ?? 0,
      favorite: favorite,
      review: reviewController.text.trim(),
      startedAt: widget.userGame.startedAt,
      completedAt: widget.userGame.completedAt,
    );

    await repository.updateUserGame(updatedUserGame);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar ${widget.game.title}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<GameStatus>(
              initialValue: status,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: GameStatus.values.map((value) {
                return DropdownMenuItem(value: value, child: Text(value.name));
              }).toList(),

              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  status = value;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              "La meva valoració",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Hores jugades",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "0",
                suffixText: "hores",
              ),
            ),
            const SizedBox(height: 24),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: favorite,
              title: const Text("Marcar com a favorit"),
              secondary: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : null,
              ),
              onChanged: (value) {
                setState(() {
                  favorite = value;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              "La meva review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: reviewController,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Escriu la teva opinió...",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: save,
                icon: const Icon(Icons.save),
                label: const Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
