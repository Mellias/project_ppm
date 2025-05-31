import 'package:flutter/material.dart';

class BerandaBerita extends StatelessWidget {
  const BerandaBerita({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      body: Column(
        children: [
          // Bagian header
          _buildHeader(),

          // Grid Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _buildCategoryCard('Berita Terbaru', 'img/Beranda/berita_terbaru.png'),
                _buildCategoryCard('Trending Topik', 'img/Beranda/trending_topik.png'),
                _buildCategoryCard('Rekomendasi ForYou', 'img/Beranda/rekomendasi.png'),
                _buildCategoryCard('Anime Viral', 'img/Beranda/viral.png'),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // aksi pindah halaman nanti di sini
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.search_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), label: ''),
          NavigationDestination(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  /// Bagian header atas (judul + search + gambar hero)
  Widget _buildHeader() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Background gambar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
            child: Image.asset(
              'img/Beranda/hero section.png',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),

          // Logo + Search + Gambar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'AnimeHype',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    'img/Beranda/Gambar Hero Section.png',
                    height: 180.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu kategori berita
  Widget _buildCategoryCard(String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xAA6A1B9A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
