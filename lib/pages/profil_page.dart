import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

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
  
  // Data Profil
  String _telepon = "Memuat..."; 
  String _alamat = "Memuat..."; 
  
  // Base URL API Anda
  final String baseUrl = 'http://localhost/flutter_budaya_api/'; 

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  // === Fungsi untuk memuat data dari SharedPreferences ===
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance(); 
    
    // Ambil data wajib
    final savedName = prefs.getString('user_name') ?? "Pengguna Baru"; 
    final savedEmail = prefs.getString('user_email') ?? "guest@neosantara.com"; 
    final savedId = prefs.getString('user_id') ?? ""; 
    
    // --- Ambil data No Telepon dan Alamat ---
    final savedPhone = prefs.getString('user_phone') ?? ""; 
    final savedAddress = prefs.getString('user_address') ?? "";
    // ---------------------------------------------

    if (mounted) {
      setState(() { 
        _namaLengkap = savedName; 
        _email = savedEmail; 
        _idUser = savedId; 
        // Tampilkan "Belum Diisi" jika data kosong
        _telepon = savedPhone.isEmpty ? "Belum Diisi" : savedPhone; 
        _alamat = savedAddress.isEmpty ? "Belum Diisi" : savedAddress;
      });
    }
  }

  // === Fungsi untuk Logout ===
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance(); 
    
    // Hapus status login dan semua data pengguna
    await prefs.remove('is_logged_in'); 
    await prefs.remove('user_name'); 
    await prefs.remove('user_email'); 
    await prefs.remove('user_id'); 
    await prefs.remove('user_phone'); 
    await prefs.remove('user_address'); 
    
    if (mounted) {
        // Pop the current page dan kembalikan 'true' untuk sinyal refresh
        Navigator.of(context).pop(true); 
    }
  }

  // === Fungsi untuk mengirim update ke server ===
  Future<bool> _updateProfile({
    required String newName,
    required String newPhone,
    required String newAddress,
  }) async {
    if (_idUser.isEmpty) {
      _showSnackbar('ID pengguna tidak ditemukan. Silakan login ulang.', Colors.red);
      return false; 
    }

    final endpoint = Uri.parse('${baseUrl}update_profile.php');
    
    try {
      final response = await http.post(
        endpoint,
        body: {
          'id_user': _idUser,
          'nama_lengkap': newName,
          'no_telepon': newPhone,
          'alamat': newAddress,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          final userData = responseData['data'];

          // 1. Update SharedPreferences dengan data terbaru dari server
          prefs.setString('user_name', userData['nama_lengkap']);
          prefs.setString('user_phone', userData['no_telepon'] ?? '');
          prefs.setString('user_address', userData['alamat'] ?? '');
          
          // 2. Muat ulang data (untuk update state dan UI)
          _loadUserData();

          _showSnackbar(responseData['message'], Colors.green);
          return true; 
        } else {
          _showSnackbar(responseData['message'], Colors.red);
          return false; 
        }
      } else {
        _showSnackbar('Gagal terhubung ke server. Status: ${response.statusCode}', Colors.red);
        return false; 
      }
    } catch (e) {
      _showSnackbar('Terjadi kesalahan jaringan: $e', Colors.red);
      return false; 
    }
  }

  // === Fungsi untuk menampilkan dialog edit profil ===
  void _showEditDialog() {
    final nameController = TextEditingController(text: _namaLengkap);
    // Jika data adalah "Belum Diisi" (string yang kita set), jadikan kosong saat di edit
    final phoneController = TextEditingController(text: _telepon == "Belum Diisi" ? "" : _telepon); 
    final addressController = TextEditingController(text: _alamat == "Belum Diisi" ? "" : _alamat); 
    
    final _formKey = GlobalKey<FormState>();
    bool _isUpdating = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: const Text("Edit Profil"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Alamat'),
                        maxLines: 3,
                      ),
                      // Email tidak bisa diedit di sini karena harus diverifikasi di backend
                      TextFormField(
                        initialValue: _email,
                        decoration: const InputDecoration(labelText: 'Email (Tidak dapat diubah)'),
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: _isUpdating ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setStateSB(() => _isUpdating = true); // Mulai loading
                      
                      final success = await _updateProfile(
                        newName: nameController.text,
                        newPhone: phoneController.text,
                        newAddress: addressController.text,
                      );

                      if (mounted) {
                          setStateSB(() => _isUpdating = false); // Hentikan loading
                          if (success) {
                            Navigator.of(context).pop(); // Tutup dialog jika berhasil
                          }
                      }
                    }
                  },
                  child: _isUpdating 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Utility function for showing SnackBar
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // === Widget _buildInfoCard ===
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
            // ... (Header dan Foto Profil) ...
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
                        ), 
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                ),
                SafeArea( 
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context, false), // Pop dengan 'false' jika tombol back biasa
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12), 

            // ===================== NAMA USER =====================
            Text(
              _namaLengkap, 
              style: const TextStyle(
                fontFamily: 'Nusantara',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4), 
            Text(
              'ID: $_idUser', 
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
              value: _email, 
              isMobile: isMobile,
            ),
            _buildInfoCard(
              icon: Icons.phone,
              title: "Nomor Telepon",
              value: _telepon, 
              isMobile: isMobile,
            ),
            _buildInfoCard(
              icon: Icons.location_on,
              title: "Alamat",
              value: _alamat, 
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
                onPressed: _showEditDialog, // Panggil fungsi edit dialog
              ),
            ),

            const SizedBox(height: 12), 

            // ===================== LOGOUT BUTTON =====================
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
                onPressed: _handleLogout, 
              ),
            ),

            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }
}