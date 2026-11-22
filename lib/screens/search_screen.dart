import 'package:flutter/material.dart';
import '../api_service.dart';
import '../movie.dart';
import 'movie_detail_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  late Future<List<Movie>> _movies;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _movies = ApiService().getMovies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reload() => setState(() => _movies = ApiService().getMovies());

  // Film adı, yönetmen, tür veya yıla göre filtreler
  List<Movie> _filter(List<Movie> movies) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return movies.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.director.toLowerCase().contains(q) ||
          m.genre.toLowerCase().contains(q) ||
          m.year.toString().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Arama')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Film, yönetmen, tür veya yıl ara',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
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

                if (_query.trim().isEmpty) {
                  return const Center(
                    child: Text('Aramak için yazmaya başlayın.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }

                final results = _filter(snapshot.data!);
                if (results.isEmpty) {
                  return Center(
                    child: Text('"${_query.trim()}" için sonuç bulunamadı.',
                        style: const TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: results.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 12, endIndent: 12),
                  itemBuilder: (context, i) => _SearchResultTile(movie: results[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Movie movie;
  const _SearchResultTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const fallback = Center(child: Icon(Icons.movie, color: Colors.grey));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 40,
          height: 60,
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
      title: Text.rich(
        TextSpan(
          text: movie.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: '  ${movie.year}',
              style: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.grey),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${movie.director}  •  ${movie.genre}',
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: colors.primary),
          const SizedBox(width: 2),
          Text('${movie.rating}'),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailPage(movieId: movie.id),
        ),
      ),
    );
  }
}
