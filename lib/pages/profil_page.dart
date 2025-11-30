// lib/pages/profil_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

// Import halaman
import 'order_history_page.dart';
import 'intro_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // Variabel State
  String _namaLengkap = "Memuat...";
  String _email = "Memuat...";
  String _idUser = "";

  String _telepon = "Memuat...";
  String _alamat = "Memuat...";
  String _profilImageUrl = "";

  // Base URL untuk Web/Desktop
  final String baseUrl = 'http://localhost/flutter_budaya_api/';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // === Fungsi untuk memuat data dari SharedPreferences ===
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('user_name') ?? "Pengguna Baru";
    final savedEmail = prefs.getString('user_email') ?? "guest@neosantara.com";
    final savedId = prefs.getString('user_id') ?? "";
    final savedTelepon = prefs.getString('user_telepon') ?? "-";
    final savedAlamat = prefs.getString('user_alamat') ?? "-";
    final savedImageUrl = prefs.getString('user_image_url') ?? "";

    if (mounted) {
      setState(() {
        _namaLengkap = savedName;
        _email = savedEmail;
        _idUser = savedId;
        _telepon = savedTelepon;
        _alamat = savedAlamat;
        _profilImageUrl = savedImageUrl;
      });
    }

    if (savedId.isNotEmpty) {
      _fetchProfileData(savedId);
    }
  }

  // === Fungsi untuk mengambil data profil lengkap dari server (Menggunakan get_user_data.php) ===
  Future<void> _fetchProfileData(String idUser) async {
    final url = Uri.parse('${baseUrl}get_user_data.php?id_user=$idUser');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null && mounted) {
          final user = data['data'];

          final String imagePath = user['profile_picture'] ?? "";
          String fullImageUrl =
              imagePath.isNotEmpty ? baseUrl + imagePath : "";

          if (fullImageUrl.isNotEmpty) {
            fullImageUrl =
                '$fullImageUrl?ts=${DateTime.now().millisecondsSinceEpoch}';
          }

          setState(() {
            _namaLengkap = user['nama_lengkap'] ?? _namaLengkap;
            _telepon = user['no_telepon'] ?? "-";
            _alamat = user['alamat'] ?? "-";
            _profilImageUrl = fullImageUrl;
          });

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_name', _namaLengkap);
          prefs.setString('user_telepon', _telepon);
          prefs.setString('user_alamat', _alamat);
          prefs.setString('user_image_url', _profilImageUrl);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Gagal memuat detail profil: ${data['message']}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Gagal terhubung ke server. Status: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kesalahan jaringan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // === Fungsi untuk menampilkan dialog edit profil ===
  void _showEditDialog() {
    TextEditingController namaController =
        TextEditingController(text: _namaLengkap);
    TextEditingController teleponController =
        TextEditingController(text: _telepon == '-' ? '' : _telepon);
    TextEditingController alamatController =
        TextEditingController(text: _alamat == '-' ? '' : _alamat);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                TextField(
                  controller: teleponController,
                  decoration:
                      const InputDecoration(labelText: 'Nomor Telepon'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: alamatController,
                  decoration:
                      const InputDecoration(labelText: 'Alamat Lengkap'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateProfile(
                  namaController.text,
                  teleponController.text,
                  alamatController.text,
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // FUNGSI Mengupdate profil ke server (Menggunakan update_profile.php)
  Future<void> _updateProfile(
      String newName, String newPhone, String newAddress) async {
    if (_idUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('ID pengguna tidak ditemukan.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    final url = Uri.parse('${baseUrl}update_profile.php');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Mengupdate profil...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 1)),
    );

    try {
      final response = await http.post(url, body: {
        'id_user': _idUser,
        'nama_lengkap': newName,
        'no_telepon': newPhone,
        'alamat': newAddress,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              _namaLengkap = newName;
              _telepon = newPhone;
              _alamat = newAddress;
            });

            final prefs = await SharedPreferences.getInstance();
            prefs.setString('user_name', newName);
            prefs.setString('user_telepon', newPhone);
            prefs.setString('user_alamat', newAddress);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(data['message']),
                  backgroundColor: Colors.green),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Gagal menyimpan: ${data['message']}'),
                  backgroundColor: Colors.red),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal terhubung ke server. Status: ${response.statusCode}'),
                backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Kesalahan jaringan saat update: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  // FUNGSI Memilih dan mengunggah gambar profil (Menggunakan update_profile_picture.php)
  Future<void> _pickAndUploadImage() async {
    if (_idUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('ID pengguna tidak ditemukan untuk upload.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mengunggah foto...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2)),
      );

      final url = Uri.parse('${baseUrl}update_profile_picture.php');

      try {
        final request = http.MultipartRequest('POST', url);
        request.fields['id_user'] = _idUser;

        final fileBytes = await pickedFile.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_picture',
            fileBytes,
            filename: pickedFile.name,
          ),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['success'] == true) {
            if (mounted) {
              final imagePath = data['profile_picture_url'];
              String newImageUrl = baseUrl + imagePath;

              // Anti-cache setelah upload: gunakan 'ts' untuk timestamp
              newImageUrl =
                  '$newImageUrl?ts=${DateTime.now().millisecondsSinceEpoch}';

              setState(() {
                _profilImageUrl = newImageUrl; // UPDATE STATE DENGAN URL BARU
              });

              final prefs = await SharedPreferences.getInstance();
              prefs.setString('user_image_url', newImageUrl);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(data['message']),
                    backgroundColor: Colors.green),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Gagal upload: ${data['message']}'),
                    backgroundColor: Colors.red),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Gagal terhubung ke server. Status: ${response.statusCode}'),
                  backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Kesalahan jaringan saat upload: $e'),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // === Fungsi untuk Logout ===
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda telah keluar.'),
            backgroundColor: Colors.green),
      );

      // Pindah ke IntroPage setelah logout
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const IntroPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  // Widget Pembantu untuk item Menu Samping
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 17),
      ),
      onTap: onTap,
    );
  }

  // =========================================================================
  // WIDGET BARU: SIDE MENU (Menggantikan Drawer)
  // =========================================================================
  Widget _buildSideMenu(BuildContext context) {
    // Memberikan lebar tetap untuk menu samping
    const double menuWidth = 280.0;

    return Container(
      width: menuWidth,
      color: const Color(0xFF1E1E1E), // Latar belakang gelap menu
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header Menu dengan info user DAN GAMBAR LOGO
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _namaLengkap,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))
                    ]
                  ),
                ),
                Text(
                  _email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                     shadows: [
                      Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))
                    ]
                  ),
                ),
              ],
            ),
          ),

          // Menu Home
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              // Navigasi ke IntroPage dan menghapus semua rute sebelumnya
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const IntroPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),

          // Menu Edit Profil
          _buildDrawerItem(
            icon: Icons.edit,
            title: 'Edit Profil',
            onTap: _showEditDialog,
          ),

          // Menu Riwayat Pesanan
          _buildDrawerItem(
            icon: Icons.history,
            title: 'Riwayat Pesanan',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
              );
            },
          ),
          
          const Divider(color: Colors.white12),

          // Menu Keluar (Logout)
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Keluar',
            color: Colors.red,
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan info kartu
  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String value}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.amber, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasProfileImage = _profilImageUrl.isNotEmpty;

    // Konten utama profil yang akan ditampilkan di sebelah kanan menu
    final Widget profileContent = SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ===================== AVATAR DAN NAMA =====================
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.amber,
                  backgroundImage:
                      hasProfileImage ? NetworkImage(_profilImageUrl) : null,
                  child: hasProfileImage
                      ? null
                      : const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.black,
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Text(
            _namaLengkap,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),

          Text(
            _email,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),

          const SizedBox(height: 30),

          // ===================== INFO CARDS =====================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                _buildInfoCard(
                    icon: Icons.alternate_email,
                    title: "Email",
                    value: _email),
                const SizedBox(height: 12),
                _buildInfoCard(
                    icon: Icons.phone, title: "Telepon", value: _telepon),
                const SizedBox(height: 12),
                _buildInfoCard(
                    icon: Icons.location_on,
                    title: "Alamat",
                    value: _alamat),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        // Tombol hamburger otomatis akan hilang karena properti 'drawer' tidak diatur
        automaticallyImplyLeading: false, 
        title: const Text(
          "Profil Saya",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // Menggunakan Row di body untuk tata letak side-by-side
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Menu Samping (Permanent)
          _buildSideMenu(context),
          
          // 2. Konten Profil Utama (Mengambil sisa ruang yang ada)
          Expanded(
            child: profileContent,
          ),
        ],
      ),
    );
  }
}