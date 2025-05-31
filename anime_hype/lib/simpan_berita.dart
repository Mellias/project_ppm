import 'package:flutter/material.dart';
import 'package:anime_hype/detail_berita.dart';
import 'package:anime_hype/model/anime_place.dart';

class SimpanBerita extends StatefulWidget {
  const SimpanBerita({super.key});

  @override
  State<SimpanBerita> createState() => _SimpanBeritaState();
}

class _SimpanBeritaState extends State<SimpanBerita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD7D7FF),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.black,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            onPressed: () {
              setState(() {
                bookmarkedPlaces.clear();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade400, height: 1.0),
        ),
      ),
      body: bookmarkedPlaces.isEmpty
        ? const Center(
          child: Text(
            'Belum ada berita favorit.',
            style: TextStyle(fontSize: 18),
          ),
        )
      : ListView.builder(
        itemCount: bookmarkedPlaces.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 10.0,
              ),
              child: Text(
                'Berita Favorit',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            );
          }

          final AnimePlace place = bookmarkedPlaces[index - 1];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBerita(animePlace: place),
                  ),
                ).then((_) {
                  setState(() {}); // Refresh state setelah kembali
                });
              },
              child: SizedBox(
                width: 385,
                height: 190,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            place.gambar,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Text(
                            place.judul,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: NavigationBar(
      //   height: 60,
      //   selectedIndex: 2,
      //   onDestinationSelected: (int index) {
      //     // Navigasi antar halaman
      //   },
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
      //     NavigationDestination(icon: Icon(Icons.search_outlined), label: ''),
      //     NavigationDestination(icon: Icon(Icons.bookmark_outline), label: ''),
      //     NavigationDestination(icon: Icon(Icons.person_outline), label: ''),
      //   ],
      // ),
    );
  }
}
  
        
        


          
          