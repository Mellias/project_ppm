import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int id;
  final String type; // 'anime', 'manga', 'character'

  const DetailPage({super.key, required this.id, required this.type});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;
  String? errorMsg;

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
      // Penyesuaian endpoint karakter Jikan Moe: harus plural 'characters'
      String endpointType = widget.type;
      if (widget.type == 'character') {
        endpointType = 'characters';
      }
      final url = Uri.parse(
        'https://api.jikan.moe/v4/$endpointType/${widget.id}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          detailData = jsonData['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Gagal memuat detail (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Terjadi error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.toUpperCase()),
        backgroundColor: const Color(0xFFBEB9FF),
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
                    width: 200,
                    height: 200,
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
        Text(synopsis ?? '-', style: const TextStyle(fontSize: 16)),
        // Tambahkan field lain sesuai kebutuhan
      ],
    );
  }
}

// Di main.dart, pastikan route '/detail' mengirim id dan type ke DetailPage universal
// Contoh:
// routes: {
//   '/detail': (context) {
//     final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     return DetailPage(id: args['id'], type: args['type']);
//   },
//   ...
// }
