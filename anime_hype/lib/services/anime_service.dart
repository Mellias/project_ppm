import 'package:http/http.dart' as http;
import 'dart:convert';

class AnimeService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  // Fungsi untuk ambil anime populer
  static Future<List<dynamic>> fetchTopAnime() async {
    final url = Uri.parse('$baseUrl/top/anime');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']; // ini list anime
    } else {
      throw Exception('Gagal ambil data anime');
    }
  }
}
