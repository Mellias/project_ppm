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
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    if (_user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('saved_news')
        .doc(_user.uid)
        .collection('items')
        .doc(widget.news['url'] ?? widget.news['title'])
        .get();
    setState(() {
      _isSaved = doc.exists;
    });
  }

  Future<void> _toggleSave() async {
    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk menyimpan berita.')),
      );
      return;
    }
    final docRef = FirebaseFirestore.instance
        .collection('saved_news')
        .doc(_user.uid)
        .collection('items')
        .doc(widget.news['url'] ?? widget.news['title']);
    if (_isSaved) {
      await docRef.delete();
      setState(() => _isSaved = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita dihapus dari simpanan.')),
      );
    } else {
      await docRef.set(widget.news);
      setState(() => _isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita disimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news['title'] ?? 'News Detail'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.news['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.news['image'],
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
              widget.news['title'] ?? 'Unknown Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${widget.news['author'] ?? 'MyAnimeList'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${widget.news['date']?.substring(0, 10) ?? 'Unknown Date'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              widget.news['intro'] ?? widget.news['excerpt'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (widget.news['url'] != null)
              ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(widget.news['url']);
                  if (await canLaunchUrl(uri)) {
                    try {
                      await launchUrl(uri); // gunakan mode default
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal membuka link.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak dapat membuka link.'),
                      ),
                    );
                  }
                },
                child: const Text('Baca di Sumber'),
              ),
          ],
        ),
      ),
    );
  }
}
