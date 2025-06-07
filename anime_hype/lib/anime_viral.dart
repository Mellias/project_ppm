import 'package:flutter/material.dart';
import 'package:anime_hype/model/anime_place.dart';
import 'package:anime_hype/widgets/berita_card.dart';
import 'package:anime_hype/detail_berita.dart'; 

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
        itemBuilder: (context, index) {
          final animePlace = animePlaceList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BeritaCard(
              judul: animePlace.judul,
              imagePath: animePlace.gambar,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailBerita(animePlace: animePlace),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
