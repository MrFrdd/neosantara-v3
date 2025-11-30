// lib/pages/login_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginPage extends StatefulWidget {
  // FIX: Dibuat opsional (?) agar dapat dipanggil sebagai rute
  final VoidCallback? onClose; 

  // FIX: Menghapus 'required' dari konstruktor
  const LoginPage({super.key, this.onClose});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool _obscurePassword = true; 
  bool _isLoading = false; 

  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _namaController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _phoneController = TextEditingController(); 
  final TextEditingController _addressController = TextEditingController();

  bool _emailError = false; 
  bool _namaError = false; 
  bool _passwordError = false; 

  @override
  void dispose() {
    _emailController.dispose(); 
    _namaController.dispose(); 
    _passwordController.dispose(); 
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // === Fungsi Validasi Email ===
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // === Fungsi Validasi Semua Field dan API Call ===
  Future<void> _handleSubmit() async {
    if (!mounted || _isLoading) return;

    // --- (1) Logika Validasi Input Lokal ---
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
          content: Text('Format email tidak valid!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() => _emailError = true);
      return;
    }
    // --- (1) End ---

    // --- (2) Setup API Call ---
    setState(() => _isLoading = true); 

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
            'no_telepon': _phoneController.text.trim(),
            'alamat': _addressController.text.trim(),
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
          
          final prefs = await SharedPreferences.getInstance(); 
          
          if (responseData['data'] != null) {
              final userData = responseData['data'];
              // Simpan data user
              prefs.setString('user_id', userData['id_user'].toString()); 
              prefs.setString('user_name', userData['nama_lengkap']); 
              prefs.setString('user_email', userData['email']); 
              prefs.setString('user_phone', userData['no_telepon'] ?? ''); 
              prefs.setString('user_address', userData['alamat'] ?? '');
              prefs.setBool('is_logged_in', true); // SET STATUS LOGIN
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Berhasil!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Panggil onClose (opsional, menggunakan null-safe call)
          widget.onClose?.call(); 
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Gagal!'),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal terhubung ke server. Status: ${response.statusCode}'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan jaringan/server: $e'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); 
      }
    }
  }

  // === Widget _buildTextField ===
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isError,
    required TextInputAction textInputAction,
    bool isPassword = false,
    bool isVisible = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
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
        keyboardType: keyboardType, 
        maxLines: maxLines, 
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
        style: const TextStyle(fontFamily: 'Nusantara'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final Map<ShortcutActivator, VoidCallback> shortcuts = {
      const SingleActivator(LogicalKeyboardKey.enter): _isLoading ? () {} : _handleSubmit, 
      // Null-check untuk onClose
      const SingleActivator(LogicalKeyboardKey.escape): widget.onClose ?? () {},
    };

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
        ),
        Center(
          child: CallbackShortcuts(
            bindings: shortcuts, 
            child: Focus(
              autofocus: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 40.0,
                ),
                child: Material(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  elevation: 10,
                  child: Container(
                    width: screenWidth * 0.85,
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

                        _buildTextField(
                          controller: _emailController, 
                          labelText: 'Email', 
                          isError: _emailError, 
                          textInputAction: TextInputAction.next, 
                        ),

                        _buildTextField(
                          controller: _namaController, 
                          labelText: 'Nama Lengkap', 
                          isError: _namaError, 
                          textInputAction: TextInputAction.next, 
                          isVisible: !isLogin, 
                        ),
                        
                        _buildTextField(
                          controller: _phoneController,
                          labelText: 'No Telepon',
                          isError: false, 
                          textInputAction: TextInputAction.next,
                          isVisible: !isLogin,
                          keyboardType: TextInputType.phone, 
                        ),
                        
                        _buildTextField(
                          controller: _addressController,
                          labelText: 'Alamat',
                          isError: false, 
                          textInputAction: TextInputAction.next,
                          isVisible: !isLogin,
                          maxLines: 3, 
                        ),

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
                          onPressed: _isLoading ? null : _handleSubmit, 
                          child: _isLoading 
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
                                  _emailController.clear();
                                  _namaController.clear();
                                  _passwordController.clear();
                                  _phoneController.clear();
                                  _addressController.clear();
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
        ),
      ],
    );
  }
}