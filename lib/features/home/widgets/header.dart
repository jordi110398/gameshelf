import 'package:flutter/material.dart';
import 'package:gameshelf/models/library_game.dart';
import 'stats.dart';
import 'package:gameshelf/core/services/profile_service.dart';
import 'package:gameshelf/models/profile.dart';

class Header extends StatefulWidget {
  final List<LibraryGame> games;

  const Header({super.key, required this.games});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  Profile? profile;
  final profileService = ProfileService();
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await profileService.getCurrentProfile();

    debugPrint(result?.nickname);

    if (!mounted) return;

    setState(() {
      profile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${profile?.nickname ?? "GameShelf"}'s GameShelf",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          Stats(games: widget.games),
        ],
      ),
    );
  }
}
