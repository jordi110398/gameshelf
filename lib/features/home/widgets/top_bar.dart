import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const Text(
          "GameShelf",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 24),

        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar videojocs...",
              prefixIcon: const Icon(Icons.search),

              filled: true,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 24),

        ElevatedButton.icon(
          onPressed: () {},

          icon: const Icon(Icons.add),

          label: const Text("Videojoc"),
        ),
      ],
    );
  }
}