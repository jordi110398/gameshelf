class Game {
  final int igdbId;

  final String title;
  final String? coverUrl;

  final String? summary;
  final String? storyline;

  final DateTime? releaseDate;

  final double? rating;
  final int? ratingCount;

  final String? slug;

  final List<String> genres;

  const Game({
    required this.igdbId,
    required this.title,
    this.coverUrl,
    this.summary,
    this.storyline,
    this.releaseDate,
    this.rating,
    this.ratingCount,
    this.slug,
    this.genres = const [],
  });

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      igdbId: map["igdb_id"] as int,
      title: map["title"] as String,
      coverUrl: map["cover_url"],
      summary: map["summary"],
      storyline: map["storyline"],
      releaseDate: map["release_date"] != null
          ? DateTime.parse(map["release_date"])
          : null,
      rating: map["rating"]?.toDouble(),
      ratingCount: map["rating_count"],
      slug: map["slug"],
      genres: map["genres"] != null
          ? List<String>.from(map["genres"])
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "igdb_id": igdbId,
      "title": title,
      "cover_url": coverUrl,
      "summary": summary,
      "storyline": storyline,
      "release_date": releaseDate?.toIso8601String(),
      "rating": rating,
      "rating_count": ratingCount,
      "slug": slug,
      "genres": genres,
    };
  }
}