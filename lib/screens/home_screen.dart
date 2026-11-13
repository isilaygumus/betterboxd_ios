import 'package:flutter/material.dart';
import '../api_service.dart';
import '../movie.dart';
//import 'movie_list_page.dart';
import 'movie_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = ApiService().getMovies();
  }

  void _reload() {
    setState(() {
      _moviesFuture = ApiService().getMovies();
    });
  }

  void _openDetail(BuildContext context, int movieId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => MovieDetailPage(movieId: movieId)),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BETTERBOXD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
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
                    Text('Filmler alınamadı:\n${snapshot.error}',
                        textAlign: TextAlign.center),
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
          final trending = ([...movies]
                ..sort((a, b) => b.rating.compareTo(a.rating)))
              .take(8)
              .toList();
          final recent = movies.reversed.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Haftanın Trend Filmleri (API'den)
                _buildSectionHeader(
                  context,
                  'Haftanın Trend Filmleri',
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: const Text('Tüm Filmler')),
                          body: const HomeScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMovieHorizontalList(context, trending),

                const SizedBox(height: 24),

                // 2. İncelemeler (yorum ve kullanıcı henüz yer tutucu)
                _buildSectionHeader(context, 'Topluluktan Son İncelemeler'),
                const SizedBox(height: 12),
                _buildRecentReviewsList(context, recent),
              ],
            ),
          );
        },
      ),
    );
  }

  // Afiş: internet yoksa ya da bağlantı bozuksa simge gösterir
  Widget _poster(String? url) {
    const fallback = Center(child: Icon(Icons.movie, color: Colors.grey));
    if (url == null) return fallback;
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  // Bölüm Başlığı
  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          TextButton(
            onPressed: onSeeAll ?? () {},
            child: Text(
              'Tümü',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Film Posterleri Yatay Listesi
  Widget _buildMovieHorizontalList(BuildContext context, List<Movie> movies) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _openDetail(context, movie.id)  ,
            child: Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: _poster(movie.posterUrl),
            ),
          ),
        );
      },
    ),
  );
}

  // İnceleme Kartları
  Widget _buildRecentReviewsList(BuildContext context, List<Movie> movies) {
    final colors = Theme.of(context).colorScheme;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
      
        return GestureDetector(
          onTap: () => _openDetail(context, movie.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film küçük afişi
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: SizedBox(
                  width: 60,
                  height: 90,
                  child: _poster(movie.posterUrl),
                ),
              ),
              const SizedBox(width: 12),
              // İnceleme detayları
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person,
                                size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'KullanıcıAdı',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          // Yıldız puanı (şimdilik filmin puanı)
                          Row(
                            children: List.generate(
                              5,
                              (starIndex) => Icon(
                                Icons.star,
                                size: 14,
                                color: starIndex < movie.rating.round()
                                    ? colors.primary
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yorum.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }
}