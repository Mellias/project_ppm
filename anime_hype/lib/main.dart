import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:anime_hype/views/login.dart';
import 'package:anime_hype/views/register.dart';
import 'package:anime_hype/views/pencarian.dart';
import 'package:anime_hype/views/kategori.dart';

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
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
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
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
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

      // ✅ Route statis
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/pencarian': (context) => const PencarianPage(),
      },

      // ✅ Route dinamis untuk kategori
      onGenerateRoute: (settings) {
        if (settings.name == '/kategori_detail') {
          final judul = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => KategoriDetailPage(judul: judul),
          );
        }

        // Halaman tidak ditemukan
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
      },
    );
  }
}
