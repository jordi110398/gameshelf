import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/games_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: const [

              Header(),

              SizedBox(height: 24),

              Expanded(
                child: GamesGrid(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}