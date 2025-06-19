import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimeService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  static Future<Map<String, dynamic>> fetchFromApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
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
}
