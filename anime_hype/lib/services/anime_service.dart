import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimeService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  static Future<Map<String, dynamic>> fetchFromApi(String url, {int retry = 1}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 429 && retry > 0) {
        // Jika rate limit, tunggu 1 detik lalu coba lagi
        await Future.delayed(const Duration(seconds: 1));
        return fetchFromApi(url, retry: retry - 1);
      } else {
        throw Exception('Failed to fetch data from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Fungsi fleksibel untuk ambil top anime (default page = 1)
  static Future<List<dynamic>> fetchTopAnime({int page = 1, int limit = 10}) async {
    final url = '$baseUrl/top/anime?page=$page&limit=$limit'; // Tambahkan limit
    final response = await fetchFromApi(url);
    return response['data'] ?? [];
  }

  static Future<List<dynamic>> fetchAnimeNews(int animeId) async {
    final url = '$baseUrl/anime/$animeId/news';
    // Tambahkan delay agar tidak rate limit
    await Future.delayed(const Duration(milliseconds: 1100));
    final response = await fetchFromApi(url);
    return response['data'] ?? [];
  }

  static Future<List<dynamic>> fetchAnimeTrending() async {
    final url = '$baseUrl/top/anime';
    return fetchFromApi(url).then((response) => response['data'] ?? []);
  }

  static Future<List<dynamic>> fetchAnimeSeasonal() async {
    final url = '$baseUrl/seasons/now';
    return fetchFromApi(url).then((response) => response['data'] ?? []);
  }

  static Future<List<dynamic>> fetchMangaOngoing() async {
    final url = '$baseUrl/top/manga?filter=publishing';
    return fetchFromApi(url).then((response) => response['data'] ?? []);
  }

  static Future<List<dynamic>> fetchPopularCharacters() async {
    final url = '$baseUrl/top/characters';
    return fetchFromApi(url).then((response) => response['data'] ?? []);
  }
}
