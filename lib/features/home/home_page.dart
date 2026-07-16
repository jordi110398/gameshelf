import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GameShelf")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "GameShelf",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Row(
              children: const [
                Text("10 jocs"),
                SizedBox(width: 24),
                Text("6 completats"),
                SizedBox(width: 24),
                Text("429h"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
