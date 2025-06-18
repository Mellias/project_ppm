import 'package:flutter/material.dart';
import 'package:anime_hype/models/anime_place.dart';
import 'package:anime_hype/views/detail_berita.dart';

class SimpanBerita extends StatefulWidget {
  const SimpanBerita({super.key});

  @override
  State<SimpanBerita> createState() => _SimpanBeritaState();
}

class _SimpanBeritaState extends State<SimpanBerita> {
  Widget buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 120,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      return Image.asset(
        url,
        width: 120,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      );
    }
  }

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
      itemCount: bookmarkedPlaces.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final place = bookmarkedPlaces[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailBerita(animePlace: place),
              ),
            ).then((_) => setState(() {})); // refresh
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: buildImage(place.gambar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.sumberGambar,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus Berita?',
                          style: TextStyle(
                            color: Color(0xFF5A3DBD),
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'Apakah kamu yakin ingin menghapus berita ini dari bookmark?',
                            style: TextStyle(color: Color(0xFF5A3DBD)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal', style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  bookmarkedPlaces.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7D7FF),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD7D7FF),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade400, height: 1.0),
        ),
      ),
      body: buildBody(),
    );
  }
}
