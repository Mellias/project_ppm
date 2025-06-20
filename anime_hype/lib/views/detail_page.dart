import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Unknown Name', style: const TextStyle(fontWeight: FontWeight.bold)), // Handle null name
        backgroundColor: const Color(0xFFBEB9FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['images']['jpg']['image_url'] ?? '', // Handle null image URL
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 48), // Fallback for invalid images
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${item['name'] ?? 'Unknown Name'}', // Handle null name
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Favorites: ${item['favorites'] ?? 0}', // Default to 0 if null
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (item['about'] != null && item['about'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['about'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
