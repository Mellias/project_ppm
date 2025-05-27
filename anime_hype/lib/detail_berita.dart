import 'package:flutter/material.dart';
import 'package:anime_hype/model/anime_place.dart';

class DetailBerita extends StatelessWidget {
  final AnimePlace animePlace;

  const DetailBerita({super.key, required this.animePlace});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBEB9FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share), 
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border), 
            onPressed: () {}
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
                  animePlace.judul,
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
                      animePlace.gambar,
                      width: screenWidth * 0.85,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    animePlace.sumberGambar,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  animePlace.deskripsi.join('\n\n'),
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
          // Navigasi antar halaman
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

