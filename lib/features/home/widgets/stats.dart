import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text("3 jocs"),
        SizedBox(width: 24),
        Text("2 completats"),
        SizedBox(width: 24),
        Text("49h"),
      ],
    );
  }
}