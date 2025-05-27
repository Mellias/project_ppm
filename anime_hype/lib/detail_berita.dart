import 'package:flutter/material.dart';

class DetailBerita extends StatelessWidget {
  const DetailBerita({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBEB9FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, // tambahkan jarak lebih lebar dari tepi
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Spy × Family Umumkan Musim Ketiga Tayang Oktober 2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5351DB),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'img/Detail Berita/spy x fam.png',
                      width: screenWidth * 0.85,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Image by www.kawai.com',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Setelah penantian panjang, musim ketiga dari anime Spy × Family resmi diumumkan akan tayang pada Oktober 2025. '
                  'Pengumuman ini disampaikan dalam acara Jump Festa 2025, di mana para pengisi suara utama hadir untuk membagikan kabar gembira ini kepada para penggemar.\n\n'
                  'Meskipun belum banyak detail yang diungkap, antusiasme penggemar meningkat dengan dirilisnya visual promosi terbaru yang menampilkan karakter-karakter utama.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // Handle navigation
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
}
         