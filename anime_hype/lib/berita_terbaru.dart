import 'package:flutter/material.dart';

class BeritaTerbaru extends StatelessWidget {
  const BeritaTerbaru({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _BeritaCard(
            imagePath: 'gambar/berita_terbaru/gear_5.png',
            judul: 'Gear 5 Luffy Mengguncang Dunia Anime, Crunchyroll Down 2 Jam!',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/berita_terbaru/one_piece.png',
            judul:
                ' One Piece: Petualangan di Pulau Egghead 6 April 2025',
          ),
          SizedBox(height: 16),
          _BeritaCard(
            imagePath: 'gambar/berita_terbaru/sung_jin_woo.png',
            judul:
                'Anime Solo Leveling Pecah Rekor Debut — Sung Jin-Woo Jadi Ikon Baru Dunia Anime!',
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
