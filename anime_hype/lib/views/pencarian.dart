import 'package:flutter/material.dart';
// import 'package:anime_hype/services/anime_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PencarianPage extends StatefulWidget {
  const PencarianPage({super.key});

  @override
  State<PencarianPage> createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<dynamic>> _searchResults = {
    'anime': [],
    'manga': [],
    'character': [],
  };
  bool _isLoading = false;

  // Tambahkan fungsi pencarian detail
  Future<List<dynamic>> searchAnime(String query) async {
    final url = Uri.parse('https://api.jikan.moe/v4/anime?q=$query&limit=10');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data anime');
    }
  }

  Future<List<dynamic>> searchManga(String query) async {
    final url = Uri.parse('https://api.jikan.moe/v4/manga?q=$query&limit=10');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data manga');
    }
  }

  Future<List<dynamic>> searchCharacter(String query) async {
    final url = Uri.parse(
      'https://api.jikan.moe/v4/characters?q=$query&limit=10',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data karakter');
    }
  }

  void _searchAll(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final animeResults = await searchAnime(query);
      final mangaResults = await searchManga(query);
      final characterResults = await searchCharacter(query);

      setState(() {
        _searchResults = {
          'anime': animeResults,
          'manga': mangaResults,
          'character': characterResults,
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
        _searchResults['character']!.isEmpty) {
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
        _buildCategorySection('Karakter', _searchResults['character'] ?? []),
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
            if (item == null || item is! Map) {
              return const SizedBox();
            }
            // Judul universal (anime: title, manga: title, karakter: name)
            final String displayTitle =
                (item['title'] != null || item['name'] != null)
                ? (item['title'] ?? item['name'])
                : 'Unknown';
            // Subtitle universal (anime/manga: type, karakter: Character)
            final String displaySubtitle = (item['type'] != null)
                ? item['type']
                : (title.toLowerCase() == 'karakter' ? 'Character' : 'Unknown');
            return ListTile(
              leading:
                  (item['images'] != null &&
                      item['images'] is Map &&
                      (item['images']['jpg'] != null &&
                          item['images']['jpg'] is Map &&
                          item['images']['jpg']['image_url'] != null))
                  ? Image.network(
                      item['images']['jpg']['image_url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : (item['image_url'] != null
                        ? Image.network(
                            item['image_url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported)),
              title: Text(displayTitle),
              subtitle: Text(displaySubtitle),
              onTap: () {
                if (item['mal_id'] != null) {
                  final id = item['mal_id'];
                  // Penyesuaian type agar sesuai endpoint Jikan Moe
                  String type;
                  if (title.toLowerCase() == 'anime') {
                    type = 'anime';
                  } else if (title.toLowerCase() == 'manga') {
                    type = 'manga';
                  } else {
                    type = 'character';
                  }
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: {'id': id, 'type': type},
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
        'endpoint': 'https://api.jikan.moe/v4/seasons/2025/winter',
      },
      {
        'title': 'Spring Anime',
        'image': 'gambar/search/av2.png',
        'endpoint': 'https://api.jikan.moe/v4/seasons/2025/spring',
      },
      {
        'title': 'Summer Anime',
        'image': 'gambar/search/av3.png',
        'endpoint': 'https://api.jikan.moe/v4/seasons/2025/summer',
      },
      {
        'title': 'Fall Anime',
        'image': 'gambar/search/av4.png',
        'endpoint': 'https://api.jikan.moe/v4/seasons/2025/fall',
      },
    ];

    return Column(
      children: rekomendasi.map((item) {
        return GestureDetector(
          onTap: () async {
            final url = Uri.parse(item['endpoint']!);
            final response = await http.get(url);
            List<dynamic> animeList = [];
            if (response.statusCode == 200) {
              final jsonData = json.decode(response.body);
              animeList = jsonData['data'] ?? [];
            }
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(item['title']!),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: animeList.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      itemBuilder: (context, index) {
                        final anime = animeList[index];
                        return ListTile(
                          leading:
                              (anime['images'] != null &&
                                  anime['images']['jpg'] != null &&
                                  anime['images']['jpg']['image_url'] != null)
                              ? Image.network(
                                  anime['images']['jpg']['image_url'],
                                  width: 52,
                                  height: 72,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported, size: 48),
                          title: Text(
                            anime['title'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            anime['type'] != null && anime['type'] != ''
                                ? anime['type']
                                : (anime['season'] != null &&
                                          anime['year'] != null
                                      ? '${anime['season']} ${anime['year']}'
                                      : ''),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 0,
                          ),
                          onTap: () {
                            if (anime['mal_id'] != null) {
                              Navigator.pop(context); // tutup dialog
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: {
                                  'id': anime['mal_id'],
                                  'type': 'anime',
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              },
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
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black45,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
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
      'Manga Terbaru',
      'Karakter Populer',
      'Rekomendasi Mingguan',
      'Top 4 Manga',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topik.map((judul) {
        return GestureDetector(
          onTap: () async {
            if (judul == 'Manga Terbaru') {
              // Fetch manga terbaru dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/manga?order_by=start_date&sort=desc&status=publishing&limit=10',
              );
              final response = await http.get(url);
              List<dynamic> mangaList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                mangaList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list manga terbaru
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Manga Terbaru'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mangaList.length,
                        itemBuilder: (context, index) {
                          final manga = mangaList[index];
                          return ListTile(
                            leading:
                                (manga['images'] != null &&
                                    manga['images']['jpg'] != null &&
                                    manga['images']['jpg']['image_url'] != null)
                                ? Image.network(
                                    manga['images']['jpg']['image_url'],
                                    width: 40,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(manga['title'] ?? '-'),
                            subtitle: Text(
                              manga['authors'] != null &&
                                      manga['authors'].isNotEmpty
                                  ? manga['authors'][0]['name'] ?? ''
                                  : '',
                            ),
                            onTap: () {
                              if (manga['mal_id'] != null) {
                                Navigator.pop(context); // tutup dialog
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'id': manga['mal_id'],
                                    'type': 'manga',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (judul == 'Top 4 Manga') {
              // Fetch top 4 manga dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/top/manga?limit=4',
              );
              final response = await http.get(url);
              List<dynamic> mangaList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                mangaList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list top 4 manga
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Top 4 Manga'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mangaList.length,
                        itemBuilder: (context, index) {
                          final manga = mangaList[index];
                          return ListTile(
                            leading:
                                (manga['images'] != null &&
                                    manga['images']['jpg'] != null &&
                                    manga['images']['jpg']['image_url'] != null)
                                ? Image.network(
                                    manga['images']['jpg']['image_url'],
                                    width: 40,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(manga['title'] ?? '-'),
                            subtitle: Text(
                              manga['authors'] != null &&
                                      manga['authors'].isNotEmpty
                                  ? manga['authors'][0]['name'] ?? ''
                                  : '',
                            ),
                            onTap: () {
                              if (manga['mal_id'] != null) {
                                Navigator.pop(context); // tutup dialog
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'id': manga['mal_id'],
                                    'type': 'manga',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (judul == 'Top 4/Ranking') {
              // Fetch top 4 anime dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/top/anime?limit=4',
              );
              final response = await http.get(url);
              List<dynamic> animeList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                animeList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list top 4 anime
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Top 4 Anime'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: animeList.length,
                        itemBuilder: (context, index) {
                          final anime = animeList[index];
                          return ListTile(
                            leading:
                                (anime['images'] != null &&
                                    anime['images']['jpg'] != null &&
                                    anime['images']['jpg']['image_url'] != null)
                                ? Image.network(
                                    anime['images']['jpg']['image_url'],
                                    width: 40,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(anime['title'] ?? '-'),
                            subtitle: Text(anime['type'] ?? ''),
                            onTap: () {
                              if (anime['mal_id'] != null) {
                                Navigator.pop(context); // tutup dialog
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'id': anime['mal_id'],
                                    'type': 'anime',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (judul == 'Rekomendasi Mingguan') {
              // Fetch rekomendasi anime dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/recommendations/anime',
              );
              final response = await http.get(url);
              List<dynamic> rekomendasiList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                rekomendasiList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list rekomendasi anime
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Rekomendasi Mingguan'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: rekomendasiList.length,
                        itemBuilder: (context, index) {
                          final rekom = rekomendasiList[index];
                          final entry =
                              rekom['entry'] != null &&
                                  rekom['entry'] is List &&
                                  rekom['entry'].isNotEmpty
                              ? rekom['entry'][0]
                              : null;
                          return entry == null
                              ? const SizedBox()
                              : ListTile(
                                  leading:
                                      (entry['images'] != null &&
                                          entry['images']['jpg'] != null &&
                                          entry['images']['jpg']['image_url'] !=
                                              null)
                                      ? Image.network(
                                          entry['images']['jpg']['image_url'],
                                          width: 40,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(entry['title'] ?? '-'),
                                  subtitle: Text(rekom['content'] ?? ''),
                                  onTap: () {
                                    if (entry['mal_id'] != null) {
                                      Navigator.pop(context); // tutup dialog
                                      Navigator.pushNamed(
                                        context,
                                        '/detail',
                                        arguments: {
                                          'id': entry['mal_id'],
                                          'type': 'anime',
                                        },
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (judul == 'Coming Soon') {
              // Fetch upcoming anime dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/seasons/upcoming',
              );
              final response = await http.get(url);
              List<dynamic> upcomingList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                upcomingList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list anime yang akan datang
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Coming Soon'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: upcomingList.length,
                        itemBuilder: (context, index) {
                          final anime = upcomingList[index];
                          return ListTile(
                            leading:
                                (anime['images'] != null &&
                                    anime['images']['jpg'] != null &&
                                    anime['images']['jpg']['image_url'] != null)
                                ? Image.network(
                                    anime['images']['jpg']['image_url'],
                                    width: 40,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(anime['title'] ?? '-'),
                            subtitle: Text(
                              anime['season'] != null && anime['year'] != null
                                  ? '${anime['season']} ${anime['year']}'
                                  : '',
                            ),
                            onTap: () {
                              if (anime['mal_id'] != null) {
                                Navigator.pop(context); // tutup dialog
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'id': anime['mal_id'],
                                    'type': 'anime',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (judul == 'Top 4/Ranking') {
              // Fetch top 4 anime dari API Jikan
              final url = Uri.parse(
                'https://api.jikan.moe/v4/top/anime?limit=4',
              );
              final response = await http.get(url);
              List<dynamic> animeList = [];
              if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);
                animeList = jsonData['data'] ?? [];
              }
              // Tampilkan dialog berisi list top 4 anime
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Top 4 Anime'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: animeList.length,
                        itemBuilder: (context, index) {
                          final anime = animeList[index];
                          return ListTile(
                            leading:
                                (anime['images'] != null &&
                                    anime['images']['jpg'] != null &&
                                    anime['images']['jpg']['image_url'] != null)
                                ? Image.network(
                                    anime['images']['jpg']['image_url'],
                                    width: 40,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(anime['title'] ?? '-'),
                            subtitle: Text(anime['type'] ?? ''),
                            onTap: () {
                              if (anime['mal_id'] != null) {
                                Navigator.pop(context); // tutup dialog
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'id': anime['mal_id'],
                                    'type': 'anime',
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              Navigator.pushNamed(
                context,
                '/kategori_detail',
                arguments: judul,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E4FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              judul,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }
}
