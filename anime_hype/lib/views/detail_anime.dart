import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailAnimePage extends StatefulWidget {
  final Map<String, dynamic> anime;

  const DetailAnimePage({super.key, required this.anime});

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  Future<void> saveAnime() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save anime.')),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final existingAnime = await firestore
        .collection('saved_news')
        .where('uid', isEqualTo: user.uid)
        .where('title', isEqualTo: widget.anime['title'] ?? widget.anime['name'])
        .get();

    if (!mounted) return;

    if (existingAnime.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item is already saved.')),
      );
      return;
    }

    await firestore.collection('saved_news').add({
      'uid': user.uid,
      'title': widget.anime['title'] ?? widget.anime['name'] ?? 'Unknown Title',
      'image': widget.anime['images']?['jpg']?['image_url'] ?? '',
      'synopsis': widget.anime['synopsis'] ?? widget.anime['about'] ?? 'No synopsis available',
      'release_date': widget.anime['aired']?['from'] ?? 'Unknown',
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;

    return Scaffold(
      appBar: AppBar(
        title: Text(anime['title'] ?? anime['name'] ?? 'Unknown Title'),
        backgroundColor: const Color(0xFF5351DB),
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
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Synopsis:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              anime['synopsis'] ?? anime['about'] ?? 'No synopsis available.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            if (anime.containsKey('aired'))
              Text(
                'Release Date: ${anime['aired']?['from'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: saveAnime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5351DB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
