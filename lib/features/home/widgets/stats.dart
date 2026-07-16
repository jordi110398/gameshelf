import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text("10 jocs"),
        SizedBox(width: 24),
        Text("6 completats"),
        SizedBox(width: 24),
        Text("429h"),
      ],
    );
  }
}