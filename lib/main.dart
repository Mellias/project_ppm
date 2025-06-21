import 'package:flutter/material.dart';
import 'package:anime_hype/views/news_detail.dart'; // Ensure this path matches the actual file location

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...existing code...
      onGenerateRoute: (settings) {
        if (settings.name == '/newsDetail') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => NewsDetailPage(news: arguments),
          );
        }
        // ...existing code...
      },
    );
  }
}
