import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // <<< PENTING: Import SharedPreferences

class LoginPage extends StatefulWidget {
  final VoidCallback onClose;

  const LoginPage({super.key, required this.onClose});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false; // Variabel untuk indikator loading

  // Controller untuk field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Status error tiap field
  bool _emailError = false;
  bool _namaError = false;
  bool _passwordError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // === Fungsi Validasi Email ===
  bool _isValidEmail(String email) {
    return email.contains('@');
  }

  // === Fungsi Validasi Semua Field dan API Call ===
  Future<void> _handleSubmit() async {
    if (!mounted || _isLoading) return;

    // --- (1) Validasi Input Lokal ---
    setState(() {
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

    // --- (2) Setup API Call ---
    setState(() => _isLoading = true); // Mulai loading

    // GANTI 'http://10.0.2.2' dengan alamat IP lokal Anda jika menggunakan perangkat fisik
    const String baseUrl = 'http://localhost/flutter_budaya_api/'; 
    final String endpoint = isLogin
        ? '${baseUrl}login.php'
        : '${baseUrl}register.php';
    
    final Map<String, String> data = isLogin
        ? {
            'email': _emailController.text.trim(),
            'kata_sandi': _passwordController.text.trim(),
          }
        : {
            'email': _emailController.text.trim(),
            'nama_lengkap': _namaController.text.trim(),
            'kata_sandi': _passwordController.text.trim(),
          };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        body: data,
      );

      if (!mounted) return;

      // --- (3) Penanganan Respons API ---
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          
          // >>> START: LOGIKA PENYIMPANAN DATA PROFIL
          final prefs = await SharedPreferences.getInstance();
          
          if (responseData['data'] != null) {
              final userData = responseData['data'];
              // Simpan data user ke SharedPreferences
              prefs.setString('user_id', userData['id_user'].toString());
              prefs.setString('user_name', userData['nama_lengkap']);
              prefs.setString('user_email', userData['email']);
              prefs.setBool('is_logged_in', true); // Penanda status login
          }
          // <<< END: LOGIKA PENYIMPANAN DATA PROFIL
          
          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Berhasil!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Tutup modal setelah sukses
          widget.onClose();
          
        } else {
          // Kasus gagal dari server (misal: email sudah terdaftar/password salah)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Gagal!'),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Kasus kegagalan HTTP/Server error (e.g., 500)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal terhubung ke server. Status: ${response.statusCode}'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Kasus error jaringan atau server tidak dapat dijangkau
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan jaringan/server: $e'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      // --- (4) Selesai Loading ---
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
      const SingleActivator(LogicalKeyboardKey.enter): _isLoading ? () {} : _handleSubmit, 
      // Tombol Escape untuk menutup modal
      const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
    };

    return Stack(
      children: [
        // === Efek Blur Background & Penutup Modal di luar area ===
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
        ),

        // === Konten Login / Register dengan Keyboard Shortcuts ===
        Center(
          child: CallbackShortcuts(
            bindings: shortcuts,
            child: Focus(
              autofocus: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 40.0,
                ),
                child: Container(
                  width: screenWidth * 0.85,
                  constraints: const BoxConstraints(maxWidth: 380),
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
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
                        // DISABLED jika sedang loading
                        onPressed: _isLoading ? null : _handleSubmit, 
                        child: _isLoading // Tampilkan indikator loading atau teks
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
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
                                _emailError = _passwordError = _namaError =
                                    false;
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
                        icon: const Icon(
                          Icons.close,
                          color: Colors.redAccent,
                          size: 28,
                        ),
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