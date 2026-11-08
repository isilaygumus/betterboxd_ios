class Movie {
  final int id;
  final String title;
  final String director;
  final int year;
  final double rating;
  final String? posterUrl;
  final String genre;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.rating,
    this.posterUrl,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        title: json['title'],
        director: json['director'],
        year: json['year'],
        rating: (json['rating'] as num).toDouble(),
        posterUrl: json['posterUrl'],
        genre: json['genre'],
      );
}