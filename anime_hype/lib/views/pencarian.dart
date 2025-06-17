import 'package:flutter/material.dart';

class PencarianPage extends StatelessWidget {
  const PencarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchHeader(),
              const SizedBox(height: 24),
              const Text(
                'Rekomendasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildRekomendasiList(context),
              const SizedBox(height: 24),
              const Text(
                'Semua Topik',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildTopikGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Mau Kepo-in Apa Nih?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRekomendasiList(BuildContext context) {
    final List<Map<String, String>> rekomendasi = [
      {
        'title': 'Winter Anime',
        'image': 'gambar/search/av1.png',
      },
      {
        'title': 'Spring Anime',
        'image': 'gambar/search/av2.png',
      },
      {
        'title': 'Summer Anime',
        'image': 'gambar/search/av3.png',
      },
      {
        'title': 'Fall Anime',
        'image': 'gambar/search/av4.png',
      },
    ];

    return Column(
      children: rekomendasi.map((item) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/kategori_detail',
              arguments: item['title'],
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    item['image']!,
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopikGrid(BuildContext context) {
    final List<String> topik = [
      'Top 4/Ranking',
      'Coming Soon',
      'Mangaka Highlight',
      'Karakter Populer',
      'Rekomendasi Mingguan',
      'Top 4 Manga',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topik.map((judul) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/kategori_detail',
              arguments: judul,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E4FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
