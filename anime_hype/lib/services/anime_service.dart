import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimeService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  /// Fungsi fleksibel untuk ambil top anime (default page = 1)
  static Future<List<dynamic>> fetchTopAnime({int page = 1}) async {
    final url = Uri.parse('$baseUrl/top/anime?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']; // Ini list anime
    } else {
      throw Exception('Gagal ambil data anime (status: ${response.statusCode})');
    }
  }
}
