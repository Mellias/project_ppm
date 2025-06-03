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
              const Text(
                'Mau Kepo-in Apa Nih?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFEDEBFB),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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

  // Bagian rekomendasi gambar horizontal
  Widget _buildRekomendasiList() {
    final List<String> images = [
      'gambar/search/av1.png',
      'gambar/search/av2.png',
      'gambar/search/av3.png',
      'gambar/search/av4.png',
    ];

    return Column(
      children: images
          .map((imgPath) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        imgPath,
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.black26,
                        alignment: Alignment.center,
                        child: const Text(
                          'Anime Viral',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // Grid tombol semua topik
  Widget _buildTopikGrid() {
    final List<String> topik = [
      'Anime Ter Update',
      'Anime TerHOT',
      'Anime Terbaik',
      'Anime Legend',
      'Anime Terboik',
      'Anime Terboik',
      'Karakter Ter-Tampon',
      'Karakter Ter-Kawai',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topik
          .map((judul) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E4FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  judul,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ))
          .toList(),
    );
  }
}
