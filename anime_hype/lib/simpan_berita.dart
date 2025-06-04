import 'package:flutter/material.dart';
import 'package:anime_hype/detail_berita.dart';
import 'package:anime_hype/model/anime_place.dart';
import 'package:anime_hype/widgets/bookmark_card.dart';

class SimpanBerita extends StatefulWidget {
  const SimpanBerita({super.key});

  @override
  State<SimpanBerita> createState() => _SimpanBeritaState();
}

class _SimpanBeritaState extends State<SimpanBerita> {
  // Tambahkan fungsi buildBody() DI SINI
  Widget buildBody() {
    if (bookmarkedPlaces.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada berita favorit.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookmarkedPlaces.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
            child: Text(
              'Berita Favorit',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
          );
        }

        final place = bookmarkedPlaces[index - 1];
        return BookmarkCard(
          place: place,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBerita(animePlace: place),
              ),
            ).then((_) => setState(() {}));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD7D7FF),
        elevation: 0,
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
      body: buildBody(), // Sekarang valid dan rapi
    );
  }
}
