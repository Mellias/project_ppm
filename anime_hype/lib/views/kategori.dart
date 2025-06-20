import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:anime_hype/views/detail_page.dart';

class KategoriDetailPage extends StatefulWidget {
  final String judul;

  const KategoriDetailPage({super.key, required this.judul});

  @override
  State<KategoriDetailPage> createState() => _KategoriDetailPageState();
}

class _KategoriDetailPageState extends State<KategoriDetailPage> {
  late Future<List<dynamic>> _animeList;

  @override
  void initState() {
    super.initState();
    if (widget.judul == 'Anime Trending') {
      _animeList = fetchAnimeTrending();
    } else if (widget.judul == 'Anime Seasonal') {
      _animeList = fetchAnimeSeasonal();
    } else if (widget.judul == 'On Going Manga') {
      _animeList = fetchOnGoingManga(); // Ensure correct API is used
    } else if (widget.judul == 'Karakter Populer') {
      _animeList = fetchPopularCharacters();
    } else {
      final page = getPageForJudul(widget.judul);
      _animeList = AnimeService.fetchTopAnime(page: page, limit: 10);
    }
  }

  Future<List<dynamic>> fetchAnimeTrending() async {
    const apiUrl = 'https://api.jikan.moe/v4/top/anime?filter=airing';
    try {
      final response = await AnimeService.fetchFromApi(apiUrl);
      final data = response['data'] ?? [];
      return removeDuplicates(data);
    } catch (e) {
      throw Exception('Failed to fetch Anime Trending: $e');
    }
  }

  Future<List<dynamic>> fetchAnimeSeasonal() async {
    const apiUrl = 'https://api.jikan.moe/v4/seasons/now';
    try {
      final response = await AnimeService.fetchFromApi(apiUrl);
      final data = response['data'] ?? [];
      return removeDuplicates(data);
    } catch (e) {
      throw Exception('Failed to fetch Anime Seasonal: $e');
    }
  }

  Future<List<dynamic>> fetchOnGoingManga() async {
    const apiUrl = 'https://api.jikan.moe/v4/manga?order_by=published&sort=desc'; // Fixed URL
    try {
      final response = await AnimeService.fetchFromApi(apiUrl);
      final data = response['data'] ?? [];
      return removeDuplicates(data);
    } catch (e) {
      throw Exception('Failed to fetch On Going Manga: $e');
    }
  }

  Future<List<dynamic>> fetchPopularCharacters() async {
    const apiUrl = 'https://api.jikan.moe/v4/top/characters';
    try {
      final response = await AnimeService.fetchFromApi(apiUrl);
      final data = response['data'] ?? [];
      return data.map((character) {
        return {
          'name': character['name'] ?? 'Unknown Name', // Handle null name
          'images': character['images'] ?? {}, // Handle null images
          'favorites': character['favorites'] ?? 0, // Default to 0 if null
          'about': character['about'] ?? 'No description available.', // Default description
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular characters: $e');
    }
  }

  int getPageForJudul(String judul) {
    final pageMap = {
      'Anime Trending': 1,
      'Karakter Populer': 12,
      'Anime Seasonal': 4,
      'winter anime': 5,
      'spring anime': 6,
      'summer anime': 7,
      'fall anime': 8,
      'top 4/ranking': 9,
      'coming soon': 10,
      'mangaka highlight': 11,
      'rekomendasi mingguan': 13,
      'top 4 manga': 14,
    };
    return pageMap[judul.toLowerCase()] ?? 1;
  }

  List<dynamic> removeDuplicates(List<dynamic> animeList) {
    final seen = <String>{};
    return animeList.where((anime) {
      final title = anime['title'];
      if (seen.contains(title)) {
        return false;
      } else {
        seen.add(title);
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // warna ungu muda
      appBar: AppBar(
        title: Text(widget.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _animeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final itemList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(item: item), // Navigate to detail page
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['images']['jpg']['image_url'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'], // Display character name
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Favorites: ${item['favorites'] ?? 'Unknown'}', // Display favorites count
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
        },
      ),
    );
  }
}
