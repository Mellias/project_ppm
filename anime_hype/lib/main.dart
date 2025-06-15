import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:anime_hype/beranda.dart';
// import 'main_screen.dart';
import 'package:anime_hype/views/anime_viral.dart';
import 'package:anime_hype/views/berita_terbaru.dart';
import 'package:anime_hype/views/trending_topik.dart';
import 'package:anime_hype/views/rekomendasi.dart';
import 'package:anime_hype/views/register.dart';
import 'package:anime_hype/views/login.dart';

// Mengintegrasikan Firebase di Flutter
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Hype',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5351DB)),
        fontFamily: 'Righteous',
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Color(0xFF5351DB));
            }
            return const IconThemeData(color: Colors.grey);
          }),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 0),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/anime_viral': (context) => const AnimeViral(),
        '/berita_terbaru': (context) => const BeritaTerbaru(),
        '/trending_topik': (context) => const TrendingTopik(),
        '/rekomendasi': (context) => const Rekomendasi(),
      },
    );
  }
}