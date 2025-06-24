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

    setState(() => _isSaved = doc.exists);
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
        backgroundColor: const Color(0xFFBEB9FF),
        title: Text(
          news['title'] ?? 'News Detail',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? const Color(0xFF5351DB) : null,
            ),
            tooltip: _isSaved ? 'Hapus dari Simpanan' : 'Simpan Berita',
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news['image'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      news['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                news['title'] ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5351DB),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Author: ${news['author'] ?? 'MyAnimeList'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Date: ${news['date']?.substring(0, 10) ?? 'Unknown Date'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                news['intro'] ??
                    news['excerpt'] ??
                    'No description available.',
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              if (news['url'] != null)
                Center(
                  child: ElevatedButton(
                    onPressed: _launchNewsUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5351DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Baca di Sumber'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
