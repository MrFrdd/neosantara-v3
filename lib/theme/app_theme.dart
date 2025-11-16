import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama yang digunakan dalam skema warna
  static const Color primarySeed = Color(0xFFFDD835); // Warna Amber yang cerah
  static const Color accentColor = Color(0xFFE53935); // Merah untuk penekanan/error

  static final ThemeData lightTheme = ThemeData(
    // 1. Definisikan Skema Warna dari seed color
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      primary: primarySeed,
      secondary: Colors.blueAccent, // Menggunakan biru untuk link/toggle
      error: accentColor,
    ),
    
    useMaterial3: true,
    
    // 2. Terapkan Font Family secara global
    // Font 'Nusantara' harus didefinisikan di pubspec.yaml
    fontFamily: 'Nusantara',

    // 3. Konfigurasi Visual/Widget
    // Sesuaikan TextField agar konsisten dengan desain login page
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // Menggunakan primary color dari skema warna
        borderSide: const BorderSide(color: primarySeed, width: 2), 
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // 4. Konfigurasi ElevatedButton (Tombol utama)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primarySeed, // Latar belakang utama
        foregroundColor: Colors.white, // Warna teks
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Nusantara', // Pastikan font kustom di sini juga
        ),
      ),
    ),
  );
}