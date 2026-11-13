class Genre {
  final int id;
  final String name;
  final int movieCount;

  Genre({required this.id, required this.name, required this.movieCount});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json['id'],
        name: json['name'],
        movieCount: json['movieCount'] ?? 0,
      );
}