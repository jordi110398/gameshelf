import 'package:flutter/material.dart';
import 'package:gameshelf/models/game.dart';

class GameOverlay extends StatelessWidget {
  final Game game;
  final bool visible;

  const GameOverlay({
    super.key,
    required this.game,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black54,
                Colors.black87,
              ],
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                game.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [

                  const Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.amber,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "${game.rating}/10",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [

                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade400,
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    "Completed",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}