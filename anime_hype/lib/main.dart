import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Tambahkan ini
import 'dart:developer' as dev;

import 'package:anime_hype/views/login.dart';
import 'package:anime_hype/views/register.dart';
import 'package:anime_hype/views/pencarian.dart';
import 'package:anime_hype/views/kategori.dart';
import 'package:anime_hype/views/bantuan.dart';
import 'package:anime_hype/views/simpan_berita.dart';
import 'package:anime_hype/views/edit_profil.dart';
import 'package:anime_hype/views/navbar.dart'; // ✅ Pastikan ini mengandung class `MainScreen`
import 'package:anime_hype/views/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyADRLBWK1ZxieoPp04YjbIhLjie5DHXEF4",
        authDomain: "animehype-64d1e.firebaseapp.com",
        projectId: "animehype-64d1e",
        storageBucket: "animehype-64d1e.appspot.com",
        messagingSenderId: "670910281630",
        appId: "1:670910281630:web:c98c956ceb59a4df6a088f",
      ),
    );
    dev.log("Firebase initialized successfully");
  } catch (e) {
    dev.log("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
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
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF5351DB));
            }
            return const IconThemeData(color: Colors.grey);
          }),
          labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 0)),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const MainScreen(); // ✅ Pastikan ini benar-benar ada
          }

          return const LoginPage();
        },
      ),

      // Route statis
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/pencarian': (context) => const PencarianPage(),
        '/bantuan': (context) => const BantuanPage(),
        '/simpan_berita': (context) => const SimpanBerita(),
        '/edit_profil': (context) => const EditProfilPage(),
        '/detail': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is Map<String, dynamic>) {
            return DetailPage(item: arguments);
          } else {
            return const Scaffold(
              body: Center(child: Text('Invalid data passed to detail page')),
            );
          }
        },
      },

      // Route dinamis untuk kategori
      onGenerateRoute: (settings) {
        if (settings.name == '/kategori_detail') {
          final judul = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => KategoriDetailPage(judul: judul),
          );
        }

        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page not found'))),
        );
      },
    );
  }
}
