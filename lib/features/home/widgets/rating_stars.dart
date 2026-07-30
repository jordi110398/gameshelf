import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int? rating;
  final double size;

  const RatingStars({
    super.key,
    this.rating,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final value = rating ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        ),
      ),
    );
  }
}