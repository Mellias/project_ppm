import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:anime_hype/views/detail_berita.dart';

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
    const apiUrl = 'https://api.jikan.moe/v4/seasons/2025/summer';
    try {
      final response = await AnimeService.fetchFromApi(apiUrl);
      final data = response['data'] ?? [];
      return removeDuplicates(data);
    } catch (e) {
      throw Exception('Failed to fetch Anime Seasonal: $e');
    }
  }

  int getPageForJudul(String judul) {
    final pageMap = {
      'Anime Trending': 1,
      'Anime Populer': 2,
      'Anime Seasonal': 4,
      'winter anime': 5,
      'spring anime': 6,
      'summer anime': 7,
      'fall anime': 8,
      'top 4/ranking': 9,
      'coming soon': 10,
      'mangaka highlight': 11,
      'karakter populer': 12,
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
      appBar: AppBar(
        title: Text(widget.judul),
        backgroundColor: const Color(0xFF5351DB),
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

          final animeList = snapshot.data!;
          return ListView.builder(
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];
              return ListTile(
                leading: Image.network(
                  anime['images']['jpg']['image_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(anime['title']),
                subtitle: Text(anime['type'] ?? 'Unknown'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailBerita(animePlace: anime),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
