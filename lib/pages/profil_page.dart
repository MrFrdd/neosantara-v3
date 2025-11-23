import 'dart:ui';
import 'package:flutter/material.dart';
// PENTING: Import SharedPreferences untuk mengelola status login
import 'package:shared_preferences/shared_preferences.dart'; 

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // Variabel State untuk menyimpan data pengguna yang dimuat
  String _namaLengkap = "Memuat...";
  String _email = "Memuat...";
  String _idUser = "";
  
  // Data dummy/statis yang belum terhubung ke API
  String _telepon = "+62 812-3456-7890 (Dummy)";
  String _alamat = "Jakarta, Indonesia (Dummy)";
  
  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi load saat halaman dimuat
  }

  // === Fungsi untuk memuat data dari SharedPreferences ===
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil data yang disimpan saat login (sesuaikan kunci jika berbeda)
    final savedName = prefs.getString('user_name') ?? "Pengguna Baru";
    final savedEmail = prefs.getString('user_email') ?? "guest@neosantara.com";
    final savedId = prefs.getString('user_id') ?? "";

    if (mounted) {
      setState(() {
        _namaLengkap = savedName;
        _email = savedEmail;
        _idUser = savedId;
      });
    }
  }

  // === Fungsi untuk Logout (FIXED: Mengembalikan true ke IntroPage) ===
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Hapus status login dan data pengguna
    await prefs.remove('is_logged_in'); 
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_id');
    
    if (mounted) {
        // Mengembalikan nilai 'true' saat logout, agar IntroPage tahu
        // bahwa pengguna ingin keluar.
        Navigator.of(context).pop(true); 
    }
  }

  // === Widget untuk menampilkan info user ===
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isMobile,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 18 : 250,
        right: isMobile ? 18 : 250,
        bottom: 15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, size: 32, color: Colors.amber.shade400),
                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===================== HEADER DARK + GRADIENT =====================
            Stack(
              children: [
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1C1C1C), Color(0xFF121212)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                ),

                // ===================== FOTO PROFIL =====================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/logo.png',
                        ), // ASUMSI: Gambar ini ada
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                ),

                // ===================== TOMBOL BACK (FIXED: Mengembalikan false) =====================
                SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    // Mengembalikan nilai 'false' saat kembali normal
                    onPressed: () => Navigator.pop(context, false), 
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ===================== NAMA USER =====================
            Text(
              _namaLengkap, // Menggunakan state
              style: const TextStyle(
                fontFamily: 'Nusantara',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: $_idUser', // Menggunakan state
              style: TextStyle(
                fontFamily: 'Nusantara',
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 30),

            // ===================== INFO CARDS =====================
            _buildInfoCard(
              icon: Icons.email,
              title: "Email",
              value: _email, // Menggunakan state
              isMobile: isMobile,
            ),
            _buildInfoCard(
              icon: Icons.phone,
              title: "Nomor Telepon",
              value: _telepon, // Data dummy
              isMobile: isMobile,
            ),
            _buildInfoCard(
              icon: Icons.location_on,
              title: "Alamat",
              value: _alamat, // Data dummy
              isMobile: isMobile,
            ),

            const SizedBox(height: 25),

            // ===================== EDIT PROFIL BUTTON =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.edit, color: Colors.black),
                label: const Text(
                  "Edit Profil",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Fitur Edit Profil belum diimplementasi."),
                          backgroundColor: Colors.orange,
                      ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ===================== LOGOUT BUTTON (FIXED: Memanggil _handleLogout) =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 53),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _handleLogout, // <<< Panggil fungsi Logout
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}