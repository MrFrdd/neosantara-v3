import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/splash_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // tampilkan splash dulu
    );
  }
}
