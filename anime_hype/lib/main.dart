import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: Color(0xFF5351DB));
              }
              return const IconThemeData(color: Colors.grey);
            },
          ),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 0),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute, // ✅ ganti ke ini
    );
  }
}
