import 'package:flutter/material.dart';
import 'package:anime_hype/services/anime_service.dart';
import 'package:anime_hype/models/anime_place.dart';
import 'package:anime_hype/views/detail_berita.dart';

class BeritaTerbaru extends StatefulWidget {
  const BeritaTerbaru({super.key});

  @override
  State<BeritaTerbaru> createState() => _BeritaTerbaruState();
}

class _BeritaTerbaruState extends State<BeritaTerbaru> {
  late Future<List<dynamic>> latestAnime;

  @override
  void initState() {
    super.initState();
    latestAnime = AnimeService.fetchTopAnime(page: 2); // ambil halaman 2
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        title: const Text('Berita Terbaru'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: latestAnime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final limitedAnimeList = snapshot.data!.take(5).toList();

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: limitedAnimeList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final anime = limitedAnimeList[index];

                final animePlace = AnimePlace(
                  judul: anime['title'] ?? 'No Title',
                  gambar: anime['images']['jpg']['image_url'] ?? '',
                  sumberGambar: 'Image from Jikan API',
                  deskripsi: [
                    anime['synopsis'] ?? 'No description available',
                  ],
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailBerita(animePlace: animePlace),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: _BeritaCard(
                    imageUrl: animePlace.gambar,
                    judul: animePlace.judul,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final String imageUrl;
  final String judul;

  const _BeritaCard({
    required this.imageUrl,
    required this.judul,
  });

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
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              judul,
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
