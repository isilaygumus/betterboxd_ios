import 'package:flutter/material.dart';
import '../api_service.dart';
import '../movie.dart';
import '../widgets/genre_filter_bar.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _api = ApiService();
  late Future<List<Movie>> _movies;
  int? _genreId;
  String? _search; // ARAMA: üçüncü kişinin görevi 

  @override
  void initState() {
    super.initState();
    _movies = _fetch();
  }

  Future<List<Movie>> _fetch() =>
    _api.getMovies(genreId: _genreId, search: _search);

    void _reload() => setState(() => _movies = _fetch());

    void _selectGenre(int? id){
      setState(() {
        _genreId = id;
        _movies = _fetch();
      });
    }

    Future <void> _onRefresh() async {
      _reload();
      try {
        await _movies;
      } catch(_){
        // Hata FutureBuilder'da gösterilir
      }
    }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ARAMA KUTUSU: üçüncü kişi buraya ekleyecek
        GenreFilterBar(selectedGenreId: _genreId, onSelected: _selectGenre),
        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: _movies,
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

              final movies = snapshot.data!;
              if (movies.isEmpty) {
                return const Center(child: Text('Film bulunamadı.'));
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, i) => _MovieCard(movie: movies[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const fallback = Center(child: Icon(Icons.movie, color: Colors.grey));

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailPage(movieId: movie.id),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
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
          const SizedBox(height: 4),
          Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: colors.primary),
              const SizedBox(width: 2),
              Text('${movie.rating}  •  ${movie.year}',
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}