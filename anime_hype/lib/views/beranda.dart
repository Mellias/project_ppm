import 'package:flutter/material.dart';
//import 'package:anime_hype/services/anime_service.dart';
import 'anime_trending.dart';
import 'saved_news.dart';
import 'anime_seasonal.dart';
import 'ongoing_manga.dart';
import 'popular_characters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
    // Ambil 7 anime terpopuler dari Jikan
    final animeResponse = await http.get(
      Uri.parse('https://api.jikan.moe/v4/top/anime?limit=7'),
    );
    if (animeResponse.statusCode != 200) {
      throw Exception('Gagal memuat daftar anime terpopuler');
    }
    final animeJson = json.decode(animeResponse.body);
    final List animeList = animeJson['data'] ?? [];
    if (animeList.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> result = [];
    for (final anime in animeList) {
      final int malId = anime['mal_id'];
      final String animeTitle = anime['title'] ?? '-';
      final String animeImage = anime['images']?['jpg']?['image_url'] ?? '';
      // Fetch berita untuk setiap anime
      try {
        final newsResponse = await http.get(
          Uri.parse('https://api.jikan.moe/v4/anime/$malId/news'),
        );
        if (newsResponse.statusCode == 200) {
          final newsJson = json.decode(newsResponse.body);
          final List newsData = newsJson['data'] ?? [];
          if (newsData.isNotEmpty) {
            // Ambil hanya berita pertama (terbaru)
            final berita = newsData[0];
            result.add({
              'animeTitle': animeTitle,
              'animeImage': animeImage,
              'animeId': malId,
              'news': {
                'title': berita['title'] ?? '-',
                'excerpt': berita['excerpt'] ?? '-',
                'date': berita['date'] ?? '-',
                'url': berita['url'] ?? '',
                'image': berita['images']?['jpg']?['image_url'] ?? animeImage,
                'intro': berita['excerpt'] ?? '-',
                'author': berita['author'] ?? '-',
              },
            });
          } else {
            // Fallback jika tidak ada berita
            result.add({
              'animeTitle': animeTitle,
              'animeImage': animeImage,
              'animeId': malId,
              'news': {
                'title': 'Belum ada berita terbaru',
                'excerpt': '-',
                'date': '-',
                'url': '',
                'image': animeImage,
                'intro': '-',
                'author': '-',
              },
            });
          }
        } else {
          // Fallback jika gagal fetch berita
          result.add({
            'animeTitle': animeTitle,
            'animeImage': animeImage,
            'animeId': malId,
            'news': {
              'title': 'Gagal memuat berita',
              'excerpt': '-',
              'date': '-',
              'url': '',
              'image': animeImage,
              'intro': '-',
              'author': '-',
            },
          });
        }
      } catch (e) {
        // Fallback jika error
        result.add({
          'animeTitle': animeTitle,
          'animeImage': animeImage,
          'animeId': malId,
          'news': {
            'title': 'Gagal memuat berita',
            'excerpt': '-',
            'date': '-',
            'url': '',
            'image': animeImage,
            'intro': '-',
            'author': '-',
          },
        });
      }
      // Delay untuk menghindari rate limit Jikan (2–3 req/detik)
      await Future.delayed(const Duration(milliseconds: 450));
    }
    return result;
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
            right: 16,
            child: const Text(
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
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == 'Anime Trending') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnimeTrendingPage()),
          );
        } else if (title == 'Saved News') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavedNewsPage()),
          );
        } else if (title == 'Anime Seasonal') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnimeSeasonalPage()),
          );
        } else if (title == 'Ongoing Manga') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OngoingMangaPage()),
          );
        } else if (title == 'Karakter Populer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PopularCharactersPage()),
          );
        }
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
                mainAxisSize: MainAxisSize.min,
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
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada berita ditemukan.'));
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
            // Ganti ListView.separated dengan Column agar tidak overflow
            Column(
              children: List.generate(newsList.length, (index) {
                final news = newsList[index];
                final newsData = news['news'];
                if (newsData is! Map<String, dynamic> && newsData is! List) {
                  return const SizedBox.shrink();
                }
                final List<Map<String, dynamic>> beritaList = newsData is List
                    ? List<Map<String, dynamic>>.from(newsData)
                    : [newsData];
                return Column(
                  children: [
                    ...beritaList.map((berita) {
                      final arguments = {
                        ...berita,
                        'animeTitle': news['animeTitle'],
                        'animeImage': news['animeImage'],
                        'animeId': news['animeId'],
                      };
                      // Gunakan gambar dan judul dari berita jika ada, fallback ke anime jika tidak ada
                      final String imageUrl =
                          berita['image'] ??
                          berita['images']?['jpg']?['image_url'] ??
                          news['animeImage'];
                      final String title =
                          berita['title'] ?? news['animeTitle'] ?? '-';
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/news_detail',
                            arguments: {
                              ...berita,
                              'animeTitle': news['animeTitle'],
                              'animeImage': news['animeImage'],
                              'animeId': news['animeId'],
                            },
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF5351DB),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            berita['title'] ?? '-',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            berita['excerpt'] ??
                                                berita['intro'] ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if ((berita['url'] ?? '')
                                              .toString()
                                              .isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final url = berita['url'];
                                                  if (url != null) {
                                                    final uri = Uri.parse(url);
                                                    if (await canLaunchUrl(
                                                      uri,
                                                    )) {
                                                      await launchUrl(uri);
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  berita['url'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF5351DB),
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (berita['date'] ?? news['date'])
                                          .toString()
                                          .split('T')
                                          .first,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    if (index != newsList.length - 1)
                      const SizedBox(height: 12),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
