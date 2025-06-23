import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isSaved = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    if (_user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('saved_news')
        .doc(_user!.uid)
        .collection('items')
        .doc(widget.news['url'] ?? widget.news['title']);

    final doc = await docRef.get();

    if (!mounted) return;

    setState(() {
      _isSaved = doc.exists;
    });
  }

  Future<void> _toggleSave() async {
    if (_user == null) {
      _showSnackbar('Silakan login untuk menyimpan berita.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('saved_news')
        .doc(_user!.uid)
        .collection('items')
        .doc(widget.news['url'] ?? widget.news['title']);

    if (_isSaved) {
      await docRef.delete();
      if (!mounted) return;
      setState(() => _isSaved = false);
      _showSnackbar('Berita dihapus dari simpanan.');
    } else {
      await docRef.set(widget.news);
      if (!mounted) return;
      setState(() => _isSaved = true);
      _showSnackbar('Berita disimpan!');
    }
  }

  Future<void> _launchNewsUrl() async {
    final uri = Uri.parse(widget.news['url']);
    bool launched = false;

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri);
        launched = true;
      } catch (_) {}
    }

    if (!mounted) return;

    if (!launched) {
      _showSnackbar('Tidak dapat membuka link.');
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;

    return Scaffold(
      appBar: AppBar(
        title: Text(news['title'] ?? 'News Detail'),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
            tooltip: _isSaved ? 'Hapus dari Simpanan' : 'Simpan Berita',
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (news['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              news['title'] ?? 'Unknown Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${news['author'] ?? 'MyAnimeList'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${news['date']?.substring(0, 10) ?? 'Unknown Date'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              news['intro'] ??
                  news['excerpt'] ??
                  'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (news['url'] != null)
              ElevatedButton(
                onPressed: _launchNewsUrl,
                child: const Text('Baca di Sumber'),
              ),
          ],
        ),
      ),
    );
  }
}
