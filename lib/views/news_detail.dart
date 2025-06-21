import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Validasi data
    if (news is! Map<String, dynamic> || news.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Data berita tidak valid')),
      );
    }

    final animeTitle = news['animeTitle'] ?? '';
    final animeImage = news['animeImage'] ?? '';
    final newsTitle = news['title'] ?? news['newsTitle'] ?? '';
    final excerpt = news['excerpt'] ?? '';
    final date = news['date'] ?? '';
    final url = news['url'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(animeTitle.isNotEmpty ? animeTitle : 'Detail Berita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (animeImage.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    animeImage,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 180,
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 60),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              animeTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5351DB),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              newsTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  date.toString().split('T').first,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              excerpt,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            if (url.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Baca di Sumber'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5351DB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tidak dapat membuka link')),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
