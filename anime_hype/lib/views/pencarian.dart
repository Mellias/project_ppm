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
              // const Text(
              //   'Mau Kepo-in Apa Nih?',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              // ),
              // const SizedBox(height: 12),
              Container(
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
              ),
              const SizedBox(height: 24),
              const Text(
                'Rekomendasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildRekomendasiList(),
              const SizedBox(height: 24),
              const Text(
                'Semua Topik',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildTopikGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRekomendasiList() {
    final List<String> images = [
      'gambar/search/av1.png',
      'gambar/search/av2.png',
      'gambar/search/av3.png',
      'gambar/search/av4.png',
    ];

    final List<String> titles = [
      'Winter Anime',
      'Spring Anime',
      'Summer Anime',
      'Fall Anime',
    ];

    return Column(
      children: List.generate(images.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  images[index],
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
                    titles[index],
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
        );
      }),
    );
  }

  Widget _buildTopikGrid() {
    final List<String> topik = [
      'Anime Ter Update',
      'Anime TerHOT',
      'Anime Terbaik',
      'Anime Legend',
      'Karakter Ter-Tampan',
      'Karakter Ter-Kawai',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topik
          .map((judul) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              ))
          .toList(),
    );
  }
}