import 'package:flutter/material.dart';
import '../api_service.dart';
import '../movie.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<Movie> _movie;

  @override
  void initState() {
    super.initState();
    _movie = ApiService().getMovie(widget.movieId);
  }

  void _reload() {
    setState(() => _movie = ApiService().getMovie(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film Detayı')),
      body: FutureBuilder<Movie>(
        future: _movie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Tekrar dene'),
                    ),
                  ],
                ),
              ),
            );
          }
          return _buildContent(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Movie movie) {
    final colors = Theme.of(context).colorScheme;
    const fallback = Center(child: Icon(Icons.movie, size: 48, color: Colors.grey));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Afiş
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: colors.surface,
                  child: movie.posterUrl == null
                      ? fallback
                      : Image.network(
                          movie.posterUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => fallback,
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Ad
        Text(
          movie.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Yıl ve tür
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text('${movie.year}')),
            Chip(label: Text(movie.genre)),
          ],
        ),
        const SizedBox(height: 8),

        // Puan
        Row(
          children: [
            ...List.generate(
              5,
              (i) => Icon(
                Icons.star,
                size: 22,
                color: i < movie.rating.round() ? colors.primary : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Text(movie.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 16),

        // Yönetmen
        const Text('YÖNETMEN',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(movie.director, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 24),

        // YORUMLAR: Kişi 2 yorum listesi ve yorum formunu buraya ekleyecek
        const Text('YORUMLAR',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0)),
        const SizedBox(height: 8),
        const Text('Yorumlar yakında.',
            style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}