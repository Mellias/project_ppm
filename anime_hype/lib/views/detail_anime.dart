import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailAnimePage extends StatelessWidget {
  final Map<String, dynamic> anime;

  const DetailAnimePage({super.key, required this.anime});

  void saveAnime(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save anime.')),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final existingAnime = await firestore
        .collection('saved_news')
        .where('uid', isEqualTo: user.uid)
        .where('title', isEqualTo: anime['title'] ?? anime['name'])
        .get();

    if (existingAnime.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item is already saved.')),
      );
      return;
    }

    await firestore.collection('saved_news').add({
      'uid': user.uid,
      'title': anime['title'] ?? anime['name'] ?? 'Unknown Title',
      'image': anime['images']?['jpg']?['image_url'] ?? '',
      'synopsis': anime['synopsis'] ?? anime['about'] ?? 'No synopsis available',
      'release_date': anime['aired']?['from'] ?? 'Unknown',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Synopsis:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                onPressed: () => saveAnime(context),
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
