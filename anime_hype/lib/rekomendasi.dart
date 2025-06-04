import 'package:flutter/material.dart';

class Rekomendasi extends StatelessWidget {
  const Rekomendasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        title: const Text('Rekomendasi'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _BeritaCard(
            imagePath: 'gambar/rekomendasi/bocchi.png',
            judul: 'Bocchi the Rock! Jadi Anime Paling Relatable 2025, Fans: “Itu Gue Banget!”',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/rekomendasi/oshinoko.png',
            judul:
                'Oshi no Ko Season 2 Hadirkan Drama Industri Idol yang Lebih Gelap dari Sebelumnya!',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/rekomendasi/mashle_magic.png',
            judul:
                'Mashle: Magic and Muscles Tuai Pujian — Otot Lebih Hebat dari Sihir?!',
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

