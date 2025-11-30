// main.dart

import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/profil_page.dart'; 
import 'package:project_uas_budayaindonesia/pages/login_page.dart'; 
import 'package:project_uas_budayaindonesia/splash_screen.dart'; 
import 'package:project_uas_budayaindonesia/pages/intro_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeoSantara',
      
      initialRoute: '/',
      
      routes: {
        '/': (context) => const SplashScreen(), // Rute awal
        
        // Target navigasi saat Logout
        '/intro': (context) => const IntroPage(), 
        
        // LoginPage sekarang tidak membutuhkan parameter wajib
        '/login': (context) => const LoginPage(), 
        
        '/profil': (context) => const ProfilPage(), 
      },
    );
  }
}