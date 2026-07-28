
class Game {
  final int id;

  // IGDB
  final String title;
  final String cover;
  final String platform;

  

  const Game({
    required this.id,
    required this.title,
    required this.cover,
    required this.platform,
    required this.rating,
    required this.hoursPlayed,
    required this.review,
    required this.status,
    required this.favorite,
  });
}