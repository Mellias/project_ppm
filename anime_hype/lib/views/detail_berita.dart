import 'package:flutter/material.dart';
import 'package:anime_hype/models/anime_place.dart';

class DetailBerita extends StatefulWidget {
  final AnimePlace animePlace;

  const DetailBerita({super.key, required this.animePlace});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool get isBookmarked => bookmarkedPlaces.contains(widget.animePlace);

  void toggleBookmark() {
    setState(() {
      if (isBookmarked) {
        bookmarkedPlaces.remove(widget.animePlace);
      } else {
        bookmarkedPlaces.add(widget.animePlace);
      }
    });
  }

  Widget buildImage(String imageUrl, double width) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 48),
      );
    }
  }

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
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? const Color(0xFF5351DB) : null,
            ),
            onPressed: toggleBookmark,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.animePlace.judul,
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
                    child: buildImage(widget.animePlace.gambar, screenWidth * 0.85),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    widget.animePlace.sumberGambar,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.animePlace.deskripsi.join('\n\n'),
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
    );
  }
}
