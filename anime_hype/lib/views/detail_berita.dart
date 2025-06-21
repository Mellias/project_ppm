import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:anime_hype/models/anime_place.dart';

class DetailBerita extends StatefulWidget {
  final AnimePlace animePlace;

  const DetailBerita({super.key, required this.animePlace});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool get isBookmarked => bookmarkedPlaces.contains(widget.animePlace);

  // Fungsi untuk menyimpan berita ke Firestore
  Future<void> saveBeritaToFirestore(AnimePlace place) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docId = FirebaseFirestore.instance.collection('saved_news').doc().id;

    await FirebaseFirestore.instance.collection('saved_news').doc(docId).set({
      'uid': user.uid,
      'judul': place.judul,
      'deskripsi': place.deskripsi,
      'gambar': place.gambar,
      'sumberGambar': place.sumberGambar,
      'title': place.title,
      'description': place.description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Toggle simpan/hapus berita dari bookmark
  void toggleBookmark() async {
    if (isBookmarked) {
      setState(() {
        bookmarkedPlaces.remove(widget.animePlace);
      });
    } else {
      setState(() {
        bookmarkedPlaces.add(widget.animePlace);
      });

      await saveBeritaToFirestore(widget.animePlace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita disimpan')),
      );
    }
  }

  // Widget untuk menampilkan gambar (local/network)
  Widget buildImage(String imageUrl, double width) {
    final isNetwork = imageUrl.startsWith('http');

    return isNetwork
        ? Image.network(
            imageUrl,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 48),
          )
        : Image.asset(
            imageUrl,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported, size: 48),
          );
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.animePlace;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBEB9FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final shareText =
                  '${anime.judul}\n\n${anime.deskripsi.join('\n\n')}';
              Share.share(shareText);
            },
          ),
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
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                anime.judul,
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
                  child: buildImage(anime.gambar, screenWidth * 0.85),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  anime.sumberGambar,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                anime.deskripsi.join('\n\n'),
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
