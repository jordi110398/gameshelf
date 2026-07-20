class Game {
  final String title;
  final String platform;
  final double rating;
  final int length;
  final bool finished;
  final String cover;

  const Game({
    required this.title,
    required this.platform,
    required this.rating,
    required this.length,
    required this.finished,
    required this.cover,
  });
}