import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:anime_hype/models/anime_place.dart';
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
    final page = getPageForJudul(widget.judul);
    _animeList = AnimeService.fetchTopAnime(page: page);
  }

  int getPageForJudul(String judul) {
    final pageMap = {
      'rekomendasi': 1,
      'anime viral': 2,
      'berita terbaru': 3,
      'trending topik': 4,
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

  int getJumlahBerita(String judul) {
    final lower = judul.toLowerCase();
    if ([
      'rekomendasi',
      'anime viral',
      'berita terbaru',
      'trending topik'
    ].contains(lower)) {
      return 5;
    } else if ([
      'winter anime',
      'spring anime',
      'summer anime',
      'fall anime'
    ].contains(lower)) {
      return 3;
    } else if ([
      'top 4/ranking',
      'coming soon',
      'mangaka highlight',
      'karakter populer',
      'rekomendasi mingguan',
      'top 4 manga'
    ].contains(lower)) {
      return 4;
    }
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        title: Text(widget.judul),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _animeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jumlah = getJumlahBerita(widget.judul);
            final data = snapshot.data!.take(jumlah).toList();

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final anime = data[index];
                final animePlace = AnimePlace(
                  judul: anime['title'],
                  gambar: anime['images']['jpg']['image_url'],
                  sumberGambar: 'Image from Jikan API',
                  deskripsi: [anime['synopsis'] ?? ''],
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailBerita(animePlace: animePlace),
                      ),
                    );
                  },
                  child: _AnimeCard(animePlace: animePlace),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _AnimeCard extends StatelessWidget {
  final AnimePlace animePlace;

  const _AnimeCard({required this.animePlace});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              animePlace.gambar,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              animePlace.judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
