import 'package:flutter/material.dart';
import '../views/login.dart';
import '../views/register.dart';
import '../views/anime_viral.dart';
import '../views/berita_terbaru.dart';
import '../views/trending_topik.dart';
import '../views/rekomendasi.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/anime_viral':
        return MaterialPageRoute(builder: (_) => const AnimeViral());
      case '/berita_terbaru':
        return MaterialPageRoute(builder: (_) => const BeritaTerbaru());
      case '/trending_topik':
        return MaterialPageRoute(builder: (_) => const TrendingTopik());
      case '/rekomendasi':
        return MaterialPageRoute(builder: (_) => const Rekomendasi());
      // Kalau mau nambah halaman baru
      // case '/halaman_baru':
      //   return MaterialPageRoute(builder: (_) => const HalamanBaru());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
