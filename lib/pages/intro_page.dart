import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/merchandise_page.dart';
import '../widgets/menu_button.dart';
import '../widgets/sejarah_dropdown.dart';
// PENTING: Import SharedPreferences untuk menyimpan status login
import 'package:shared_preferences/shared_preferences.dart'; 

// Import file pages yang sudah Anda buat
import '../pages/login_page.dart';
import '../pages/jakarta_page.dart';
import '../pages/jawa_timur_page.dart';
import '../pages/jawa_tengah_page.dart';
import '../pages/jawa_barat_page.dart';
import '../pages/bali_page.dart';
import '../pages/profil_page.dart';
import '../pages/card_page.dart';
import '../pages/merchandise_page.dart';
import '../pages/payment_card.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool showLogin = false;
  // State untuk melacak status login dan nama user
  bool _isLoggedIn = false; 
  String _userName = 'Profil';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Cek status saat halaman dimuat
  }

  // === FUNGSI UNTUK MEMUAT STATUS LOGIN ===
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Gunakan kunci ('is_logged_in' dan 'user_name') sesuai dengan yang disimpan di login_page.dart
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false; 
    final userName = prefs.getString('user_name') ?? 'Profil';

    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _userName = userName;
      });
    }
  }
  
  // === FUNGSI UNTUK LOGOUT (Dipanggil dari tombol KELUAR di AppBar/Drawer) ===
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in'); // Hapus status login
    await prefs.remove('user_name'); // Hapus nama user
    
    // Tambahkan penghapusan kunci lain yang terkait dengan sesi jika ada
    await prefs.remove('user_email');
    await prefs.remove('user_id');

    if (mounted) {
      setState(() {
        _isLoggedIn = false;
        _userName = 'Profil';
        showLogin = false; // Pastikan overlay login tertutup
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil keluar."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  final List<String> _regions = [
    "Jakarta",
    "Jawa Timur",
    "Jawa Tengah",
    "Jawa Barat",
    "Bali",
  ];

  // === FUNGSI NAVIGASI SEJARAH DAERAH ===
  void _navigateToRegion(String region) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    if (region == "Jakarta") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JakartaPage()));
    } else if (region == "Jawa Timur") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaTimurPage()));
    } else if (region == "Jawa Tengah") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaTengahPage()));
    } else if (region == "Jawa Barat") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaBaratPage()));
    } else if (region == "Bali") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const BaliPage()));
    }
  }

  // === FUNGSI NAVIGASI PROFIL (FIXED: Menangani hasil logout dari ProfilPage) ===
  void _navigateToProfile() async { 
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    // Menggunakan await untuk mendapatkan nilai balik dari ProfilPage
    final didLogout = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfilPage()));
    
    // Jika ProfilPage mengembalikan true, berarti pengguna menekan tombol "Keluar" di sana
    if (mounted && didLogout == true) {
      // Karena tombol "Keluar" di ProfilPage sudah menghapus data di SharedPreferences
      // kita hanya perlu memperbarui state di IntroPage
      await _checkLoginStatus(); 

      // Tampilkan notifikasi dan tutup overlay jika terbuka
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda telah berhasil keluar.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      setState(() {
        showLogin = false;
      });
    }
  }

  void _navigateToMerchandise() {
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MerchandisePage()),
    );
  }

  // === Kotak utama budaya Indonesia ===
  Widget _mainCultureBox(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : null,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Text(
            'Keanekaragaman Budaya Indonesia',
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.amber,
              fontSize: isMobile ? 20 : 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              height: 1.3,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Indonesia adalah negeri kepulauan yang kaya akan keanekaragaman budaya. '
            'Dari Sabang hingga Merauke, setiap daerah memiliki warisan unik berupa bahasa, kesenian, tradisi, pakaian adat, hingga nilai-nilai kearifan lokal yang menjadi jati diri bangsa.',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white,
              fontSize: isMobile ? 17 : 17,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Budaya Nusantara tidak hanya menjadi peninggalan masa lalu, tetapi juga sumber inspirasi yang terus hidup dan berkembang seiring waktu. '
            'Di tengah arus modernisasi, budaya Indonesia hadir sebagai pengingat akan pentingnya menjaga identitas dan melestarikan tradisi bagi generasi masa depan.',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white,
              fontSize: isMobile ? 17 : 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // === Kotak slogan ===
  Widget _sloganCards(bool isMobile) {
    final List<Map<String, dynamic>> slogans = [
      {
        'text': 'Ayo kenali dan lestarikan budaya Indonesia bersama kami!',
        'icon': Icons.favorite,
        'color': Colors.orangeAccent,
      },
      {
        'text': 'Belajar budaya, cintai Indonesia!',
        'icon': Icons.school,
        'color': Colors.amber,
      },
      {
        'text': 'Mulai perjalananmu menjelajahi budaya Nusantara!',
        'icon': Icons.explore,
        'color': Colors.deepOrangeAccent,
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: slogans.map((item) {
        return Container(
          width: isMobile ? double.infinity : null,
          margin: EdgeInsets.only(bottom: isMobile ? 6 : 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (item['color'] as Color).withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (item['color'] as Color).withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: isMobile ? 28 : 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['text'] as String,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: Colors.white,
                    fontSize: isMobile ? 15 : 20,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // === Footer Section (Tentang Pembuat) ===
  Widget _footerSection(bool isMobile) {
    final double horizontalPadding = 16;
    // final double topSpacing = isMobile ? 0 : 10; // Dihapus untuk menghemat ruang vertikal
    // Tentukan lebar maksimum untuk background card
    final double contentCardMaxWidth = 650; 

    // Bagian Informasi Pembuat (Teks)
    Widget creatorInfo = Column(
      // Perataan diubah ke rata kiri (start) untuk web
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start, 
      children: [
        // Spasi vertikal kembali ke 40px (mempertahankan posisi teks)
        if (!isMobile) const SizedBox(height: 47), 
        Text(
          'Tentang Pembuat',
          style: TextStyle(
            fontFamily: 'Nusantara',
            fontSize: isMobile ? 14 : 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Dibuat oleh: Muhammad Frida & Arfana Ridho',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white,
            fontSize: isMobile ? 13 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NIM: 241011401999 & 241011401690',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white70,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'KELAS: 03TPLP033',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white54,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'MATKUL: Algoritma & Pemrograman II',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white54,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
      ],
    );

    // Widget Gambar
    Widget creatorImage = Container(
      // Memberikan margin kanan hanya pada tampilan Web
      margin: EdgeInsets.only(right: isMobile ? 0 : 20, bottom: isMobile ? 10 : 0),
      child: Transform.translate(
        // Offset vertikal direset ke nol (posisi diatur oleh margin di Column)
        offset: const Offset(0,-30), 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/doyfrid.png', // <<< ASUMSI PATH GAMBAR DARI FILE UPLOADED
            // Ukuran gambar kembali ke 180x180 (mempertahankan ukuran)
            height: isMobile ? 100 : 180, 
            width: isMobile ? 100 : 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );


    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizontalPadding,
      ),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: topSpacing), // Dihapus untuk menghemat ruang vertikal

          Divider(
            color: isMobile ? Colors.white70 : Colors.white54,
            thickness: isMobile ? 1.0 : 0.5,
            height: isMobile ? 16 : 35,
          ),

          // --- Konten Utama Footer (Gambar + Info) ---
          
          Container(
            constraints: isMobile ? null : BoxConstraints(maxWidth: contentCardMaxWidth),
            // KUNCI PERUBAHAN: Padding vertikal diperkecil dari 4 menjadi 2
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
              // Menghilangkan border
              border: null, 
            ),
            
            child: !isMobile
              ? IntrinsicHeight( // WEB VIEW
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment.start agar gambar dan teks sejajar rata atas
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      creatorImage, // Gambar di Kiri
                      Expanded(child: creatorInfo), // Teks Info
                    ],
                  ),
                )
              : Column( // MOBILE VIEW (tetap rata tengah karena tampilan stack vertikal)
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    creatorImage, 
                    creatorInfo,  
                  ],
                ),
          ),
          // --- Akhir Konten Utama Footer ---


          const SizedBox(height: 12),
          const Divider(color: Colors.white24, thickness: 0.8),
          const SizedBox(height: 6),
          Text(
            '© 2025 NeoSantara • Melestarikan Warisan Budaya Bangsa',
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white54,
              fontSize: isMobile ? 11 : 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;

    final double? heroHeight = isMobile ? null : 650;
    final double minMobileHeight =
        screenSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);

    return Scaffold(
      backgroundColor: Colors.black,
      // PENTING: Untuk membuat AppBar transparan di Web
      extendBodyBehindAppBar: !isMobile,

      resizeToAvoidBottomInset: true,

      // === DRAWER (untuk mobile) ===
      drawer: isMobile
          ? Drawer(
              backgroundColor: Colors.black87,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    'assets/images/neosantara.jpg', // ASUMSI: Gambar ini ada
                                    height: 38,
                                    width: 38,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "NeoSantara",
                                  style: TextStyle(
                                    fontFamily: 'Nusantara',
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white24, thickness: 0.8),

                          // MENU HOME (MOBILE) - Sudah ada di Drawer
                          MenuButton(
                            text: "Home",
                            isDrawer: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          MenuButton(
                            text: "Merchandise",
                            isDrawer: true,
                            onPressed: _navigateToMerchandise,
                          ),

                          // Menu Sejarah Daerah (MOBILE) - Sudah ada di Drawer
                          SejarahDropdown(
                            regions: _regions,
                            onSelected: (region) {
                              _navigateToRegion(region);
                            },
                          ),

                          const Divider(color: Colors.white24, thickness: 0.8),

                          // >>> KONDISI LOGIN/KELUAR (MOBILE)
                          if (!_isLoggedIn)
                            // Jika BELUM login
                            MenuButton(
                              text: "LOGIN",
                              isDrawer: true,
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  showLogin = true;
                                });
                              },
                            )
                          else
                            // Jika SUDAH login: Tampilkan nama dan tombol KELUAR
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    'Halo, $_userName', // Tampilkan nama user
                                    style: const TextStyle(
                                      fontFamily: 'Nusantara',
                                      color: Colors.amber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                MenuButton(
                                  text: "KELUAR",
                                  isDrawer: true,
                                  onPressed: () {
                                    Navigator.pop(context); // Tutup drawer
                                    _logout(); // Logout (menghapus status)
                                  },
                                ),
                              ],
                            ),
                          // AKHIR KONDISI LOGIN/KELUAR (MOBILE) <<<
                          
                          // MENU PROFIL BARU (MOBILE)
                          MenuButton(
                            text: "Profil",
                            isDrawer: true,
                            onPressed: _navigateToProfile,
                          ),
                        ],
                      ),
                    ),

                    // FOOTER
                    _footerSection(isMobile),
                  ],
                ),
              ),
            )
          : null,

      // === APPBAR ===
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isMobile ? Colors.black : Colors.transparent,
        elevation: isMobile ? 4 : 0,

        iconTheme: const IconThemeData(color: Colors.white, size: 30),

        leading: isMobile
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: "Menu",
                  );
                },
              )
            : null,

        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- BAGIAN KIRI (Logo & Nama Aplikasi) ---
            if (!isMobile) const SizedBox(width: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/neosantara.jpg', // ASUMSI: Gambar ini ada
                height: 34,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "NeoSantara",
              style: TextStyle(
                fontFamily: 'Nusantara',
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.1,
              ),
            ),
            
            // --- SPACER 1: PUSHES MENU TO CENTER ---
            const Spacer(), 

            // >>> BAGIAN TENGAH (Menu Navigasi - Hanya Web) <<<
            if (!isMobile)
              Row(
                mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
                children: [
                  // 1. Home Button
                  MenuButton(
                    text: "Home",
                    onPressed: () {}, // Sudah di IntroPage, tidak perlu navigasi
                  ),
                  const SizedBox(width: 8),

                  // 2. Merchandise Button
                  MenuButton(
                    text: "Merchandise",
                    onPressed: _navigateToMerchandise,
                  ),
                  const SizedBox(width: 8),

                  // 3. Sejarah Dropdown
                  SejarahDropdown(
                    regions: _regions,
                    onSelected: _navigateToRegion,
                  ),
                ],
              ),
            
            // --- SPACER 2: PUSHES USER ACTIONS TO RIGHT ---
            const Spacer(), 
            
            // >>> BAGIAN KANAN (Aksi Pengguna - Hanya Web) <<<
            if (!isMobile)
              Row(
                mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
                children: [
                  // Nama User (Hanya tampil jika sudah login)
                  if (_isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Halo, $_userName', 
                        style: const TextStyle(
                          fontFamily: 'Nusantara',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                  // 1. ICON PROFIL
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _navigateToProfile,
                    tooltip: "Profil User",
                  ),

                  // 2. MENU LOGIN / KELUAR (Kondisional)
                  if (!_isLoggedIn)
                    // Jika BELUM login
                    MenuButton(
                      text: "LOGIN",
                      onPressed: () {
                        setState(() {
                          showLogin = true;
                        });
                      },
                    )
                  else
                    // Jika SUDAH login
                    MenuButton(
                      text: "KELUAR",
                      onPressed: _logout, // Panggil fungsi logout
                    ),
                  const SizedBox(width: 20), // Padding di paling kanan
                ],
              ),
            // AKHIR KONDISI MENU WEB <<<
          ],
        ),
      ),

      // === BODY ===
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: isMobile ? null : heroHeight,
                      constraints: isMobile
                          ? BoxConstraints(minHeight: minMobileHeight)
                          : null,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Latar Belakang & Overlay Hitam
                          Container(
                            height: isMobile ? null : constraints.maxHeight,
                            constraints: isMobile
                                ? BoxConstraints(minHeight: minMobileHeight)
                                : null,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/tari-bali.jpg',
                                ), // ASUMSI: Gambar ini ada
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: isMobile ? null : constraints.maxHeight,
                            constraints: isMobile
                                ? BoxConstraints(minHeight: minMobileHeight)
                                : null,
                            color: Colors.black.withOpacity(0.45),
                          ),

                          // KONTEN UTAMA DI PUSAT (Bottom Alignment)
                          Align(
                            alignment: isMobile
                                ? Alignment.bottomCenter
                                : Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 18 : 40,
                                vertical: isMobile ? 8 : 20,
                              ),
                              child: isMobile
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _mainCultureBox(isMobile),
                                        const SizedBox(height: 10),
                                        _sloganCards(isMobile),
                                        const SizedBox(height: 8),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _mainCultureBox(isMobile),
                                        ),
                                        const SizedBox(width: 25),
                                        Flexible(child: _sloganCards(isMobile)),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // FOOTER UNTUK WEB BROWSER
                if (!isMobile) _footerSection(isMobile),
              ],
            ),
          ),

          // === LOGIN OVERLAY ===
          if (showLogin)
            LoginPage(
              // PENTING: Panggil _checkLoginStatus() setelah modal ditutup
              onClose: () async { 
                setState(() {
                  showLogin = false;
                });
                // FIX: Menghapus 'await' pada baris 744 untuk mengatasi 'void expression' error
                _checkLoginStatus(); 
              },
            ),
        ],
      ),
    );
  }
}