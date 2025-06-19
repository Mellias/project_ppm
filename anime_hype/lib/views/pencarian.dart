import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PencarianPage extends StatefulWidget {
  const PencarianPage({super.key});

  @override
  State<PencarianPage> createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<dynamic>> _searchResults = {'anime': [], 'manga': [], 'characters': []};
  bool _isLoading = false;

  Future<void> _searchAll(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://api.jikan.moe/v4/anime?q=$query')),
        http.get(Uri.parse('https://api.jikan.moe/v4/manga?q=$query')),
        http.get(Uri.parse('https://api.jikan.moe/v4/characters?q=$query')),
      ]);

      setState(() {
        _searchResults = {
          'anime': responses[0].statusCode == 200 ? json.decode(responses[0].body)['data'] ?? [] : [],
          'manga': responses[1].statusCode == 200 ? json.decode(responses[1].body)['data'] ?? [] : [],
          'characters': responses[2].statusCode == 200 ? json.decode(responses[2].body)['data'] ?? [] : [],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchHeader(),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari Anime, Manga, atau Karakter',
                border: InputBorder.none,
              ),
              onSubmitted: _searchAll,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchAll(_searchController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_searchResults['anime']!.isEmpty &&
        _searchResults['manga']!.isEmpty &&
        _searchResults['characters']!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekomendasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildRekomendasiList(context),
          const SizedBox(height: 24),
          const Text(
            'Semua Topik',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildTopikGrid(context),
        ],
      );
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySection('Anime', _searchResults['anime'] ?? []),
        const SizedBox(height: 16),
        _buildCategorySection('Manga', _searchResults['manga'] ?? []),
        const SizedBox(height: 16),
        _buildCategorySection('Characters', _searchResults['characters'] ?? []),
      ],
    );
  }

  Widget _buildCategorySection(String title, List<dynamic> items) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: item['images'] != null
                  ? Image.network(
                      item['images']['jpg']['image_url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported),
              title: Text(item['title'] ?? item['name'] ?? 'Unknown'),
              subtitle: Text(item['type'] ?? 'Unknown'),
              onTap: () {
                if (item is Map<String, dynamic>) {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: item,
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRekomendasiList(BuildContext context) {
    final List<Map<String, String>> rekomendasi = [
      {
        'title': 'Winter Anime',
        'image': 'gambar/search/av1.png',
      },
      {
        'title': 'Spring Anime',
        'image': 'gambar/search/av2.png',
      },
      {
        'title': 'Summer Anime',
        'image': 'gambar/search/av3.png',
      },
      {
        'title': 'Fall Anime',
        'image': 'gambar/search/av4.png',
      },
    ];

    return Column(
      children: rekomendasi.map((item) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/kategori_detail',
              arguments: item['title'],
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    item['image']!,
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopikGrid(BuildContext context) {
    final List<String> topik = [
      'Top 4/Ranking',
      'Coming Soon',
      'Mangaka Highlight',
      'Karakter Populer',
      'Rekomendasi Mingguan',
      'Top 4 Manga',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topik.map((judul) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/kategori_detail',
              arguments: judul,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E4FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
