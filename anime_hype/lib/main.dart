import 'package:flutter/material.dart';
import 'package:anime_hype/detail_berita.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Hype',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5351DB), // warna utama (ungu)
        ),
        fontFamily: 'Righteous', // font custom kamu
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: Color(0xFF5351DB));
              }
              return const IconThemeData(color: Colors.grey);
            },
          ),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 0), // sembunyikan label icon
          ),
        ),
      ),
      home: const DetailBerita(),
    );
  }
}