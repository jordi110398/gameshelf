import 'package:flutter/material.dart';
import 'top_bar.dart';
import 'stats.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBar(),

          SizedBox(height: 24),

          Text(
            "Keru's GameShelf",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24),

          Stats(),
        ],
      ),
    );
  }
}