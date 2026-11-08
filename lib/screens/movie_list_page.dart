import 'package:flutter/material.dart';
import '../api_service.dart';
import '../movie.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = ApiService().getMovies();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FutureBuilder<List<Movie>>(
      future: _movies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Hata: ${snapshot.error}',
                  textAlign: TextAlign.center),
            ),
          );
        }
        final movies = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: movies.length,
          itemBuilder: (context, i) {
            final m = movies[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      color: colors.surface,
                      child: m.posterUrl == null
                          ? const Center(child: Icon(Icons.movie))
                          : Image.network(m.posterUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: colors.primary),
                    const SizedBox(width: 2),
                    Text('${m.rating}  •  ${m.year}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}