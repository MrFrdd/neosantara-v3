import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import ini WAJIB ada

class LoginPage extends StatefulWidget {
  final VoidCallback onClose;

  const LoginPage({super.key, required this.onClose});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Toggle antara login & daftar
  bool _obscurePassword = true; // Untuk sembunyikan password

  // Controller untuk field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Status error tiap field
  bool _emailError = false;
  bool _namaError = false;
  bool _passwordError = false;

  // Dispose controllers (Best Practice)
  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // === Fungsi Validasi Email ===
  bool _isValidEmail(String email) {
    // Memeriksa apakah email mengandung @
    return email.contains('@');
  }

  // === Fungsi Validasi Semua Field ===
  void _handleSubmit() {
    // Pastikan tidak ada aksi ganda saat API dipanggil
    if (!mounted) return; 

    setState(() {
      // Basic validation: check if fields are empty
      _emailError = _emailController.text.trim().isEmpty;
      _passwordError = _passwordController.text.trim().isEmpty;
      _namaError = !isLogin && _namaController.text.trim().isEmpty;
    });

    if (_emailError || _passwordError || _namaError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua kolom yang diperlukan!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak valid! Harus mengandung simbol "@"'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() => _emailError = true);
      return;
    }

    // Jika semua valid, ini adalah tempat untuk memanggil API.
    // Simulasi sukses:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil ${isLogin ? "Masuk" : "Mendaftar"}! (Simulasi)'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Tutup modal setelah simulasi
    widget.onClose();
  }

  // === Widget untuk Field Input ===
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isError,
    required TextInputAction textInputAction,
    bool isPassword = false,
    bool isVisible = true,
  }) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        onChanged: (value) => setState(() {
          if (labelText == 'Email') _emailError = false;
          if (labelText == 'Nama Lengkap') _namaError = false;
          if (labelText == 'Kata Sandi') _passwordError = false;
        }),
        obscureText: isPassword ? _obscurePassword : false,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontFamily: 'Nusantara'),
          errorText: isError ? 'Wajib diisi' : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isError ? Colors.redAccent : Colors.amber,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isError ? Colors.redAccent : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // === Definisikan shortcut keyboard ===
    final Map<ShortcutActivator, VoidCallback> shortcuts = {
      // Tombol Enter untuk submit
      const SingleActivator(LogicalKeyboardKey.enter): _handleSubmit,
      // Tombol Escape untuk menutup modal
      const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
    };

    return Stack(
      children: [
        // === Efek Blur Background & Penutup Modal di luar area ===
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose, // Tutup modal saat mengklik di luar
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
        ),

        // === Konten Login / Register dengan Keyboard Shortcuts ===
        Center(
          child: CallbackShortcuts(
            // Menggunakan 'bindings' untuk CallbackShortcuts
            bindings: shortcuts, 
            child: Focus( // Memastikan widget ini dapat menerima input fokus keyboard
              autofocus: true, // Fokus otomatis saat modal muncul
              child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 40.0), // Padding untuk SingleChildScrollView
                  child: Container(
                    width: screenWidth * 0.85,
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.all(20), 
                    decoration: BoxDecoration(
                      // Warna background modal
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // === JUDUL ===
                        Text(
                          isLogin ? 'Masuk ke NeoSantara' : 'Daftar Akun Baru',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nusantara',
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // === FIELD EMAIL ===
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          isError: _emailError,
                          textInputAction: TextInputAction.next,
                        ),

                        // === FIELD NAMA (JIKA DAFTAR) ===
                        _buildTextField(
                          controller: _namaController,
                          labelText: 'Nama Lengkap',
                          isError: _namaError,
                          textInputAction: TextInputAction.next,
                          isVisible: !isLogin,
                        ),

                        // === FIELD PASSWORD ===
                        _buildTextField(
                          controller: _passwordController,
                          labelText: 'Kata Sandi',
                          isError: _passwordError,
                          textInputAction: TextInputAction.done,
                          isPassword: true,
                        ),

                        const SizedBox(height: 8),
                        
                        // === TOMBOL LOGIN / DAFTAR ===
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _handleSubmit,
                          child: Text(
                            isLogin ? 'MASUK' : 'DAFTAR',
                            style: const TextStyle(
                              fontFamily: 'Nusantara',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // === TOGGLE LOGIN / DAFTAR ===
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              isLogin
                                  ? 'Belum punya akun? '
                                  : 'Sudah punya akun? ',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Nusantara',
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Reset state saat toggle
                                  _emailController.clear();
                                  _namaController.clear();
                                  _passwordController.clear();
                                  isLogin = !isLogin;
                                  _emailError = _passwordError = _namaError = false;
                                });
                              },
                              child: Text(
                                isLogin ? 'Daftar sekarang' : 'Masuk di sini',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontFamily: 'Nusantara',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // === TOMBOL CLOSE ===
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent, size: 28),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ),
        ),
      ],
    );
  }
}