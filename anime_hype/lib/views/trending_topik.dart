import 'package:flutter/material.dart';

class TrendingTopik extends StatelessWidget {
  const TrendingTopik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        title: const Text('Trending Topik'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _BeritaCard(
            imagePath: 'gambar/trending_topik/spynfamily.png',
            judul:
                'Spy x Family Movie Umumkan Jadwal Rilis, Anya Siap Lakukan Misi Global!',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/trending_topik/tokyo_revengers.png',
            judul:
                'Tokyo Revengers Season Baru: Mikey Resmi Jadi Villain, Fans Shock Berat!',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/trending_topik/franchise_jujutsu.png',
            judul: 'Franchise Jujutsu Kaisen akan merilis film terbaru',
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
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
