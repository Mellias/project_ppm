import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BerandaBerita extends StatefulWidget {
  const BerandaBerita({super.key});

  @override
  State<BerandaBerita> createState() => _BerandaBeritaState();
}

class _BerandaBeritaState extends State<BerandaBerita> {
  late Future<List<Map<String, dynamic>>> _animeNews;

  @override
  void initState() {
    super.initState();
    _animeNews = fetchPopularAnimeNews();
  }

  Future<List<Map<String, dynamic>>> fetchPopularAnimeNews() async {
    try {
      final animeList = await AnimeService.fetchTopAnime(limit: 7);
      List<Map<String, dynamic>> newsList = [];

      for (final anime in animeList) {
        final animeId = anime['mal_id'];
        final animeTitle = anime['title'] ?? '';
        final animeImage = anime['images']?['jpg']?['image_url'] ?? '';
        final animeNews = await AnimeService.fetchAnimeNews(animeId);

        if (animeNews.isNotEmpty) {
          final news = animeNews.first;
          newsList.add({
            'animeTitle': animeTitle,
            'animeImage': animeImage,
            'newsTitle': news['title'] ?? '',
            'excerpt': news['excerpt'] ?? '',
            'date': news['date'] ?? '',
            'url': news['url'] ?? '',
            'news': news,
            'animeId': animeId,
          });
        }
      }
      return newsList;
    } catch (e) {
      throw Exception('Error fetching anime news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth >= 800 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildCategoryCard(
                        context,
                        'Anime Trending',
                        'gambar/beranda/berita_terbaru.png',
                      ),
                      _buildCategoryCard(
                        context,
                        'Anime Seasonal',
                        'gambar/beranda/trending_topik.png',
                      ),
                      _buildCategoryCard(
                        context,
                        'Ongoing Manga',
                        'gambar/beranda/rekomendasi.png',
                      ),
                      _buildCategoryCard(
                        context,
                        'Karakter Populer',
                        'gambar/beranda/viral.png',
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildAnimeNewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double height = MediaQuery.of(context).size.width >= 800 ? 250 : 300;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
            child: Image.asset(
              'gambar/beranda/hr.png',
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    'AnimeHype',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/kategori_detail',
          arguments: title,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xAA6A1B9A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeNewsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _animeNews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat berita anime terbaru...\n(Mungkin agak lama karena pembatasan API)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          final errorMsg = snapshot.error.toString();
          if (errorMsg.contains('429')) {
            return const Center(
              child: Text(
                'Gagal memuat berita karena terlalu banyak permintaan ke server (rate limit).\nSilakan coba lagi beberapa saat lagi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available.'));
        }

        final newsList = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Berita Anime Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final news = newsList[index];
                final newsData = news['news'];
                // Validasi: newsData harus Map dan tidak kosong
                if (newsData is! Map<String, dynamic> || newsData.isEmpty) {
                  return const SizedBox.shrink();
                }
                final arguments = {
                  ...newsData,
                  'animeTitle': news['animeTitle'],
                  'animeImage': news['animeImage'],
                  'animeId': news['animeId'],
                };
                return GestureDetector(
                  onTap: () {
                    // Validasi sebelum push
                    if (arguments.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/news_detail',
                        arguments: arguments,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data berita tidak valid')),
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              news['animeImage'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news['animeTitle'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF5351DB),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  news['newsTitle'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  news['excerpt'],
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      news['date'].toString().split('T').first,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF5351DB),
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/news_detail',
                                          arguments: {
                                            ...news['news'],
                                            'animeTitle': news['animeTitle'],
                                            'animeImage': news['animeImage'],
                                            'animeId': news['animeId'],
                                          },
                                        );
                                      },
                                      child: const Text('Baca Selengkapnya'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
