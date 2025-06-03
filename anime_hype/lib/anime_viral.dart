import 'package:flutter/material.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _BeritaCard(
            imagePath: 'gambar/anime_viral/spy_fam.png',
            judul: 'Update Musim Ke Tiga SPY X Familly',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/anime_viral/zenitsu.png',
            judul:
                'Zenitsu Jadi MVP Demon Slayer Season 4',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/anime_viral/sukuna_gojo.png',
            judul:
                'Jujutsu Kaisen Cetak Episode Tergila Sepanjang Masa!',
          ),
        ],
      ),
    );
  }
}

class _BeritaCard extends StatelessWidget {
  final String imagePath;
  final String judul;

  const _BeritaCard({required this.imagePath, required this.judul});

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
            child: Image.asset(
              imagePath,
              width: 200,
              height: 170,
              fit: BoxFit.cover,
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
          )
        ],
      ),
    );
  }
}
