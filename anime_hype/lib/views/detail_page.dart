import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String type;

  const DetailPage({super.key, required this.id, required this.type});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;
  String? errorMsg;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      String endpointType = widget.type == 'character' ? 'characters' : widget.type;
      final url = Uri.parse('https://api.jikan.moe/v4/$endpointType/${widget.id}');
      final response = await http.get(url);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];

        setState(() {
          detailData = data;
          isLoading = false;
        });

        await checkIfBookmarked(data);
      } else {
        setState(() {
          errorMsg = 'Gagal memuat detail (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMsg = 'Terjadi error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> checkIfBookmarked(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FirebaseFirestore.instance
        .collection('saved_news')
        .where('uid', isEqualTo: user.uid)
        .where('mal_id', isEqualTo: widget.id)
        .get();

    if (!mounted) return;
    setState(() {
      isBookmarked = result.docs.isNotEmpty;
    });
  }

  Future<void> toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu.')),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('saved_news');

    if (isBookmarked) {
      final docs = await docRef
          .where('uid', isEqualTo: user.uid)
          .where('mal_id', isEqualTo: widget.id)
          .get();

      if (!mounted) return;

      for (var doc in docs.docs) {
        await doc.reference.delete();
      }

      if (!mounted) return;
      setState(() => isBookmarked = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark dihapus')),
      );
    } else {
      final data = detailData!;
      await docRef.add({
        'uid': user.uid,
        'mal_id': widget.id,
        'type': widget.type,
        'title': data['title'] ?? data['name'] ?? 'No Title',
        'image': data['images']?['jpg']?['image_url'] ?? '',
        'synopsis': data['synopsis'] ?? data['about'] ?? 'No description',
        'release_date': data['aired']?['from'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      setState(() => isBookmarked = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disimpan ke bookmark')),
      );
    }
  }

  void shareContent() {
    if (detailData == null) return;
    final data = detailData!;
    final title = data['title'] ?? data['name'] ?? 'No Title';
    final desc = data['synopsis'] ?? data['about'] ?? 'No description';
    Share.share('$title\n\n$desc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.toUpperCase()),
        backgroundColor: const Color(0xFFBEB9FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: detailData == null ? null : shareContent,
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? const Color(0xFF5351DB) : null,
            ),
            onPressed: detailData == null ? null : toggleBookmark,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text(errorMsg!))
              : detailData == null
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildDetailContent(),
                    ),
    );
  }

  Widget _buildDetailContent() {
    final data = detailData!;
    String? imageUrl;
    String? title;
    String? synopsis;

    if (widget.type == 'anime' || widget.type == 'manga') {
      imageUrl = data['images']?['jpg']?['image_url'];
      title = data['title'] ?? '-';
      synopsis = data['synopsis'] ?? '-';
    } else if (widget.type == 'character') {
      imageUrl = data['images']?['jpg']?['image_url'] ?? data['image_url'];
      title = data['name'] ?? '-';
      synopsis = data['about'] ?? '-';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 48),
                  )
                : const Icon(Icons.image_not_supported, size: 48),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title ?? '-',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          synopsis ?? '-',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
