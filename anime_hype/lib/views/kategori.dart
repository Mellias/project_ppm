import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:anime_hype/views/detail_page.dart';
import 'package:anime_hype/views/character_detail.dart';

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
    if (widget.judul == 'Karakter Populer') {
      _animeList = fetchPopularCharacters();
    } else if (widget.judul == 'Anime Seasonal') {
      _animeList = fetchAnimeSeasonal();
    } else {
      final page = getPageForJudul(widget.judul);
      _animeList = AnimeService.fetchTopAnime(page: page, limit: 10);
    }
  }

  Future<List<dynamic>> fetchAnimeTrending() async {
    return AnimeService.fetchAnimeTrending();
  }

  Future<List<dynamic>> fetchAnimeSeasonal() async {
    return AnimeService.fetchAnimeSeasonal();
  }

  Future<List<dynamic>> fetchMangaOngoing() async {
    return AnimeService.fetchMangaOngoing();
  }

  Future<List<dynamic>> fetchPopularCharacters() async {
    return AnimeService.fetchPopularCharacters();
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

  Widget buildCharacterCard(dynamic character) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(
          character['images']['jpg']['image_url'] ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(character['name'] ?? 'Unknown Name'),
        subtitle: Text(character['favorites'] != null
            ? '${character['favorites']} Favorites'
            : 'No favorites data'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CharacterDetailPage(character: character),
            ),
          );
        },
      ),
    );
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

          if (widget.judul == 'Karakter Populer') {
            final characterList = snapshot.data!;
            return ListView.builder(
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                return buildCharacterCard(characterList[index]);
              },
            );
          }

          final animeList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(item: anime),
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
                          anime['images']['jpg']['image_url'],
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
                              anime['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Release Date: ${anime['aired']['from'] ?? 'Unknown'}',
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
