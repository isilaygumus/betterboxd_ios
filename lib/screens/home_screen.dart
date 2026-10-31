import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Haftanın Trend Filmleri
            _buildSectionHeader(context, 'Haftanın Trend Filmleri'),
            const SizedBox(height: 12),
            _buildMovieHorizontalList(),

            const SizedBox(height: 24),

            // 2. Popüler İncelemeler / Akış
            _buildSectionHeader(context, 'Topluluktan Son İncelemeler'),
            const SizedBox(height: 12),
            _buildRecentReviewsList(),
          ],
        ),
      ),
    );
  }

  // Bölüm Başlığı Widget'ı
  Widget _buildSectionHeader(BuildContext context, String title) {
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
            onPressed: () {},
            child: const Text(
              'Tümü',
              style: TextStyle(
                color: Color(0xFF00E054), 
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Film Posterleri Yatay Listesi
  Widget _buildMovieHorizontalList() {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 6, // Şimdilik 6 geçici poster
        itemBuilder: (context, index) {
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3440),
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Stack(
                children: [
                  
                  Image.network([
                    'https://media.themoviedb.org/t/p/w600_and_h900_face/Ap8QwmKfSjYbWC4XIP8w9pdn72O.jpg',
                    'https://media.themoviedb.org/t/p/w440_and_h660_face/lmrulvLbmaejTix1YaMxo1oGhH1.jpg',
                    'https://media.themoviedb.org/t/p/w600_and_h900_face/jT5SR5qc9KvVg7HUEmjMWEUYMce.jpg',
                    'https://media.themoviedb.org/t/p/w260_and_h390_face/x7A59t6ySylr1L7aubOQEA480vM.jpg',
                    'https://media.themoviedb.org/t/p/w600_and_h900_face/oQffRNjK8e19rF7xVYEN8ew0j7b.jpg',
                    'https://media.themoviedb.org/t/p/w600_and_h900_face/glt0v4I89rMWstDNCaFXc5SNyO1.jpg',

                    ][index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.movie, color: Colors.grey),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // İnceleme Kartları Listesi
  Widget _buildRecentReviewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 3, // Geçici 3 inceleme
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2228),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film Küçük Posteri
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network([
                  'https://media.themoviedb.org/t/p/w260_and_h390_face/4kJmUCE7mkVJjXa7A0g2rY4IGTm.jpg',
                  'https://media.themoviedb.org/t/p/w260_and_h390_face/mxsGXqetGnirf99qapYd5MMY1VL.jpg',
                  'https://media.themoviedb.org/t/p/w600_and_h900_face/iEBJOgEOz0y8M7pUNGsOiRtZh5v.jpg',
                  ][index],
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // İnceleme Detayları
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Örnek Film Adı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 12, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'KullanıcıAdı',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        // Yıldız Puanlama
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              Icons.star,
                              size: 14,
                              color: starIndex < 4
                                  ? const Color(0xFF00E054)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
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
        );
      },
    );
  }
}