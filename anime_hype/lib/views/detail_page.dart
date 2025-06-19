import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? item['name'] ?? 'Detail'),
        backgroundColor: const Color(0xFF5351DB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['images'] != null)
              Center(
                child: Image.network(
                  item['images']['jpg']['image_url'],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            if (item['trailer'] != null && item['trailer']['url'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trailer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      final url = item['trailer']['url'];
                      if (url != null) {
                        // Open the trailer URL (requires additional setup for URL launcher)
                      }
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(item['trailer']['images']['medium_image_url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (item['synopsis'] != null)
              Text(
                'Deskripsi:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (item['synopsis'] != null)
              const SizedBox(height: 8),
            if (item['synopsis'] != null)
              Text(
                item['synopsis'],
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            Text(
              'Detail:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDetailList(item),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailList(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entry.key}: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
