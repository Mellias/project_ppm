import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

// List bookmark lokal (bisa dipindahkan ke state global atau provider)
List<Map<String, dynamic>> bookmarkedAnimeList = [];

class DetailAnimePage extends StatefulWidget {
  final Map<String, dynamic> anime;

  const DetailAnimePage({super.key, required this.anime});

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  bool get isBookmarked =>
      bookmarkedAnimeList.any((item) => item['mal_id'] == widget.anime['mal_id']);

  Future<void> saveToFirestore(Map<String, dynamic> anime) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Cek apakah sudah ada data serupa
    final existing = await firestore
        .collection('saved_news')
        .where('uid', isEqualTo: user.uid)
        .where('mal_id', isEqualTo: anime['mal_id']) // gunakan ID unik dari API
        .get();

    if (existing.docs.isNotEmpty) return;

    await firestore.collection('saved_news').add({
      'uid': user.uid,
      'mal_id': anime['mal_id'],
      'title': anime['title'] ?? anime['name'] ?? 'Unknown Title',
      'image': anime['images']?['jpg']?['image_url'] ?? '',
      'synopsis': anime['synopsis'] ?? anime['about'] ?? 'No synopsis available',
      'release_date': anime['aired']?['from'] ?? 'Unknown',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void toggleBookmark() async {
    final anime = widget.anime;

    if (isBookmarked) {
      setState(() {
        bookmarkedAnimeList.removeWhere((item) => item['mal_id'] == anime['mal_id']);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark dihapus')),
      );
    } else {
      setState(() {
        bookmarkedAnimeList.add(anime);
      });

      await saveToFirestore(anime);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anime disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;

    return Scaffold(
      appBar: AppBar(
        title: Text(anime['title'] ?? anime['name'] ?? 'Detail Anime'),
        backgroundColor: const Color(0xFFBEB9FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final shareText =
                  '${anime['title'] ?? anime['name']}\n\n${anime['synopsis'] ?? 'No synopsis available.'}';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  anime['images']?['jpg']?['image_url'] ?? '',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Synopsis:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              anime['synopsis'] ?? anime['about'] ?? 'No synopsis available.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Release Date: ${anime['aired']?['from'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
