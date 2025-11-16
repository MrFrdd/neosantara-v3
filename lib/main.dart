import 'package:flutter/material.dart';
import 'pages/intro_page.dart';
import 'theme/app_theme.dart'; // Asumsi file ini ada

void main() {
  runApp(const NeoSantaraApp());
}

class NeoSantaraApp extends StatelessWidget {
  const NeoSantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoSantara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Menggunakan tema dari file terpisah
      home: const IntroPage(),
    );
  }
}