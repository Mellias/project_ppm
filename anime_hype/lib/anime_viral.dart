import 'package:flutter/material.dart';
import 'package:anime_hype/model/anime_place.dart';
import 'package:anime_hype/detail_berita.dart'; // Pastikan import ini sesuai path kamu

class AnimeViral extends StatelessWidget {
  const AnimeViral({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        title: const Text('Anime Viral'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: animePlaceList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _BeritaCard(animePlace: animePlaceList[index]),
        ),
      ),
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final AnimePlace animePlace;

  const _BeritaCard({required this.animePlace});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailBerita(animePlace: animePlace),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                animePlace.gambar,
                width: 200,
                height: 170,
                fit: BoxFit.cover,
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
            )
          ],
        ),
      ),
    );
  }
}
