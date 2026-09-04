import 'package:flutter/material.dart';

/// Mostra 5 estrelles per representar una puntuació. Si es passa
/// [onRatingChanged], cada estrella es pot tocar per puntuar (1-5);
/// sense callback es queda com a mer indicador visual, tal com sempre.
class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final star = Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );

        if (onRatingChanged == null) return star;

        return GestureDetector(
          onTap: () => onRatingChanged!(index + 1),
          child: star,
        );
      }),
    );
  }
}