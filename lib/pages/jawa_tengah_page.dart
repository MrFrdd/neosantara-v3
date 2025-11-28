import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk cek status login

// Asumsi Anda memiliki IntroPage dan halaman daerah lain di path yang sama atau relatif
import 'intro_page.dart'; 
import '../widgets/comments_section.dart'; // Komponen komentar modular
import 'jakarta_page.dart';
import 'jawa_timur_page.dart'; 
import 'jawa_barat_page.dart'; 
import 'bali_page.dart'; 

// Import halaman-halaman tujuan yang baru:
import 'merchandise_page.dart'; 
import 'profil_page.dart'; 
import 'login_page.dart'; 

// --- FUNGSI MAIN UNTUK MENJALANKAN APLIKASI ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sejarah Jawa Tengah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema gelap dipertahankan
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber, // Warna utama
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black, // Background global
      ),
      home: const JawaTengahPage(),
    );
  }
}

// ============================================================================
//                   JAWA TENGAH PAGE (StatefulWidget)
// ============================================================================
class JawaTengahPage extends StatefulWidget {
  const JawaTengahPage({super.key});

  @override
  State<JawaTengahPage> createState() => _JawaTengahPageState();
}

class _JawaTengahPageState extends State<JawaTengahPage> {
  // Status login
  bool _isLoggedIn = false; 
  
  // KUNCI KRITIS: Untuk mengakses State dari CommentsSection dan memanggil refresh.
  final GlobalKey<CommentsSectionState> _commentsSectionKey = GlobalKey<CommentsSectionState>();

  // Map untuk menentukan rute halaman target
  final Map<String, Widget> pageRoutes = {
    'Jakarta': const JakartaPage(),
    'Jawa Timur': const JawaTimurPage(),
    'Jawa Tengah': const JawaTengahPage(), // Pertahankan untuk routing internal jika diperlukan
    'Jawa Barat': const JawaBaratPage(),
    'Bali': const BaliPage(),
    'Merchandise': const MerchandisePage(),
    'Profil': const ProfilPage(),
  };

  // Fungsi untuk memeriksa status login dari SharedPreferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isLoggedIn = prefs.getBool('is_logged_in') ?? false; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Cek status saat halaman dimuat
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Widget untuk menampilkan bagian teks konten
  Widget _buildContentSection({
    required String title,
    required String content,
    required bool isMobile,
  }) {
    final titleStyle = TextStyle(
      fontFamily: 'Nusantara',
      fontSize: isMobile ? 22 : 28,
      fontWeight: FontWeight.bold,
      color: Colors.amber, 
    );
    final contentStyle = TextStyle(
      fontFamily: 'Nusantara',
      fontSize: isMobile ? 16 : 18, 
      color: Colors.white70, 
      height: 1.6,
      letterSpacing: 0.5,
    );
    
    final double topSpacing = title.isEmpty ? 0 : 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: titleStyle),
        SizedBox(height: title.isNotEmpty ? topSpacing : 0),
        Text(content, textAlign: TextAlign.justify, style: contentStyle),
        const SizedBox(height: 30), 
      ],
    );
  }

  // Widget untuk membuat menu drawer
  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = Colors.amber;
    final double headerHeight = isMobile ? 180 : 220; 

    // Fungsi navigasi yang sesungguhnya 
    void navigateTo(String destination) {
      Navigator.pop(context); // Tutup drawer

      if (destination == 'Home') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()), 
        );
      } 
      // Navigasi ke halaman regional lain
      else if (pageRoutes.containsKey(destination)) {
        Widget nextPage = pageRoutes[destination]!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Halaman $destination belum diimplementasikan.', style: const TextStyle(fontFamily: 'Nusantara'))),
        );
      }
    }

    // Daftar menu Sejarah Daerah (DIPERBAIKI: Set Jawa Tengah sebagai Current)
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': false},
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': true}, // Jawa Tengah adalah halaman saat ini
      {'name': 'Jawa Barat', 'isCurrent': false}, 
      {'name': 'Bali', 'isCurrent': false},
    ];

    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.95), 
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // === HEADER DRAWER ===
          SizedBox(
            height: headerHeight,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.amber, width: 2)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jateng.jpg', // Ganti gambar header ke Jateng (Asumsi path)
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade800,
                        child: const Center(child: Text("Header Image Not Found", style: TextStyle(color: Colors.red))),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sejarah Jawa Tengah', 
                          style: TextStyle(
                            fontFamily: 'Nusantara',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Jelajahi Sejarah Indonesia',
                          style: TextStyle(
                            fontFamily: 'Nusantara',
                            color: Colors.amber,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Home 
          ListTile(
            leading: const Icon(Icons.home, color: iconColor),
            title: const Text('Home', style: TextStyle(fontFamily: 'Nusantara', color: listTileColor, fontSize: 18)),
            onTap: () => navigateTo('Home'), 
          ),
          
          const Divider(color: Colors.white12),

          // === ExpansionTile Sejarah Daerah ===
          ExpansionTile(
            initiallyExpanded: true, 
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            leading: const Icon(Icons.map_outlined, color: iconColor),
            title: const Text(
              'Sejarah Daerah',
              style: TextStyle(
                fontFamily: 'Nusantara',
                color: Colors.white, 
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconColor: Colors.amber, 
            collapsedIconColor: Colors.white70,
            
            // Sub-menu (ListTile)
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;
              
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0), 
                leading: Icon(
                  isCurrent ? Icons.location_city : Icons.location_city_outlined, 
                  color: isCurrent ? Colors.amber : listTileColor,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: isCurrent ? Colors.amber : listTileColor,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                // Gunakan pushReplacement untuk navigasi regional
                onTap: () => navigateTo(name), 
              );
            }).toList(),
          ),
          
          const Divider(color: Colors.white12),
        ],
      ),
    );
  }

  // --- Metode Build Utama ---
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;

    final double horizontalPadding = isMobile ? 20 : 60;
    const double maxWebWidth = 1200;

    final double topSafeAreaPadding = MediaQuery.of(context).padding.top;
    const double kAppBarHeight = 56.0;
    final double topPadding = topSafeAreaPadding + kAppBarHeight;

    // --------------------------------------------------------------------------
    // --- Konten Teks Jawa Tengah (DIPERBARUI) ---
    // --------------------------------------------------------------------------
    
    // --- Konten Geografi dan Administrasi ---
    final String geografiLokasi =
        "Jawa Tengah sebagai salah satu Propinsi di Jawa, letaknya diapit oleh dua Propinsi besar, yaitu Jawa Barat dan Jawa Timur. Letaknya 5º40′ dan 8º30′ Lintang Selatan dan antara 108º30′ dan 111º30′ Bujur Timur (termasuk Pulau Karimunjawa). Jarak terjauh dari Barat ke Timur adalah 263 Km dan dari Utara ke Selatan 226 Km (tidak termasuk pulau Karimunjawa).";

    final String administrasiLuas =
        "Secara administratif Propinsi Jawa Tengah terbagi menjadi 29 Kabupaten dan 6 Kota. Luas Wilayah Jawa Tengah sebesar 3,25 juta hektar atau sekitar 25,04 persen dari luas pulau Jawa (1,70 persen luas Indonesia). Luas yang ada terdiri dari 1,00 juta hektar (30,80 persen) lahan sawah dan 2,25 juta hektar (69,20 persen) bukan lahan sawah.";

    final String penggunaanLahan =
        "Menurut penggunaannya, luas lahan sawah terbesar berpengairan teknis (38,26 persen), selainnya berpengairan setengah teknis, tadah hujan dan lain-lain. Dengan teknik irigasi yang baik, potensi lahan sawah yang dapat ditanami padi lebih dari dua kali sebesar 69,56 persen.\n\n"
        "Berikutnya lahan kering yang dipakai untuk tegalan/kebun/ladang/huma sebesar 34,36 persen dari total bukan lahan sawah. Persentase tersebut merupakan yang terbesar, dibandingkan presentase penggunaan bukan lahan sawah yang lain.";

    final String iklimSuhu =
        "Menurut Stasiun Klimatologi Klas 1 Semarang, suhu udara rata-rata di Jawa Tengah berkisar antara 18ºC sampai 28ºC. Tempat-tempat yang letaknya dekat pantai mempunyai suhu udara rata-rata relatif tinggi. Sementara itu, suhu rata-rata tanah berumput (kedalaman 5 Cm), berkisar antara 17ºC sampai 35ºC. Rata-rata suhu air berkisar antara 21ºC sampai 28ºC. Sedangkan untuk kelembaban udara rata-rata bervariasi, dari 73 persen sampai 94 persen. Curah hujan terbanyak terdapat di Stasiun Meteorologi Pertanian khusus batas Salatiga sebanyak 3.990 mm, dengan hari hujan 195 hari.";
    
    // --- Konten Sejarah Jawa Tengah ---
    final String eraKuno = 
        "Sejak abad VII, banyak terdapat pemerintahan kerajaan yang berdiri di Jawa Tengah (Central Java), yaitu: Kerajaan Budha Kalingga, Jepara yang diperintah oleh Ratu Sima pada tahun 674.\n\n"
        "Menurut naskah/prasasti Canggah tahun 732, kerajaan Hindu lahir di Medang Kamulan, Jawa Tengah dengan nama Raja Sanjaya atau Rakai Mataram. Di bawah pemerintahan Rakai Pikatan dari Dinasti Sanjaya, ia membangun Candi Rorojonggrang atau Candi Prambanan. "
        "Kerajaan Mataram Budha yang juga lahir di Jawa Tengah selama era pemerintahan Dinasti Syailendra, mereka membangun candi-candi seperi Candi Borobudur, Candi Sewu, Candi Kalasan dll.";

    final String eraIslam =
        "Pada abad 16 setelah runtuhnya kerajaan Majapahit Hindu, kerajaan Islam muncul di Demak, sejak itulah Agama Islam disebarkan di Jawa Tengah. Setelah kerajaan Demak runtuh, Djoko Tingkir anak menantu Raja Demak (Sultan Trenggono) memindahkan kerajaan Demak ke Pajang (dekat Solo), dan bergelar Sultan Adiwijaya.\n\n"
        "Perang yang paling besar adalah antara Sultan Adiwijaya melawan Aryo Penangsang. Sultan Adiwijaya menugaskan Danang Sutowijaya untuk menumpas pemberontakan Aryo Penangsang. "
        "Setelah Pajang runtuh, Sutowijaya menjadi Raja Mataram Islam pertama di Jawa Tengah dan bergelar Panembahan Senopati.";

    final String eraKolonialPerjuangan =
        "Di pertengahan abad 16, bangsa Portugis dan Spanyol datang ke Indonesia dalam usaha mencari rempah-rempah. Pada saat yang sama, bangsa Inggris dan kemudian bangsa Belanda datang ke Indonesia juga. Dengan VOC-nya, bangsa Belanda menindas bangsa Indonesia termasuk rakyat Jawa Tengah baik di bidang politik maupun ekonomi.\n\n"
        "Di awal abad 18, Kerajaan Mataram diperintah oleh Sri Sunan Pakubuwono II. Perselisihan keluarga raja dan campur tangan Belanda diselesaikan dengan Perjanjian Gianti tahun 1755. "
        "Perjanjian ini membagi Kerajaan Mataram menjadi dua kerajaan yang lebih kecil: Surakarta Hadiningrat (Kraton Kasunanan) dan Ngayogyakarta Hadiningrat (Kraton Kasultanan).\n\n"
        "Sampai sekarang, daerah Jawa Tengah secara administratif merupakan sebuah propinsi yang ditetapkan dengan Undang-undang No. 10/1950 tanggal 4 Juli 1950.";
    // --------------------------------------------------------------------------


    return Scaffold(
      // === DRAWER Dihubungkan ===
      drawer: _buildAppDrawer(context, isMobile),
      
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // Tombol Menu Kustom (Hamburger) di posisi Leading
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.amber),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Membuka Drawer
            },
            tooltip: 'Menu',
          ),
        ), 

        title: const Text('Sejarah Jawa Tengah', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        
        // Actions (Tombol Merchandise dan Profil/Login - LOGIKA KRITIS INLINE)
        actions: [
          // Tombol Merchandise
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MerchandisePage()),
              );
            },
            tooltip: 'Merchandise',
          ),

          // Tombol Profil / Login (LOGIKA DINAMIS dari jakarta_page.dart)
          IconButton(
            icon: Icon(
              _isLoggedIn ? Icons.person : Icons.login, // Icon dinamis
              color: Colors.white
            ),
            onPressed: () {
              final initialContext = context; 
              
              if (_isLoggedIn) {
                // Sudah login -> Navigasi ke halaman Profil
                Navigator.push(
                  initialContext,
                  MaterialPageRoute(builder: (context) => const ProfilPage()),
                ).then((value) { 
                    // 'value' akan bernilai 'true' jika logout (dari ProfilPage)
                    if (value == true) { 
                        _checkLoginStatus(); // 1. Update status login (jadi false)
                        _commentsSectionKey.currentState?.loadComments(); // 2. Refresh komentar
                        
                        // 3. Tampilkan SnackBar
                        if (mounted) {
                            ScaffoldMessenger.of(initialContext).showSnackBar(
                                const SnackBar(
                                    content: Text("Anda telah berhasil keluar (Logout)."),
                                    backgroundColor: Colors.orange,
                                    duration: Duration(seconds: 2),
                                ),
                            );
                        }
                    }
                });
              } else {
                // Belum login -> Tampilkan halaman Login
                Navigator.push(
                  initialContext,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      onClose: () {
                        // 1. Tutup halaman LoginPage
                        Navigator.pop(initialContext); 
                        
                        // 2. Perbarui status login
                        _checkLoginStatus(); 
                        
                        // 3. Refresh CommentsSection setelah login sukses
                        _commentsSectionKey.currentState?.loadComments(); 
                        
                        // 4. Tampilkan SnackBar (Dipastikan setelah pop)
                        Future.delayed(Duration.zero, () {
                            if (mounted) {
                                ScaffoldMessenger.of(initialContext).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Berhasil! Status Komentar diperbarui."),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                    ),
                                );
                            }
                        });
                      },
                    ),
                  ),
                );
              }
            },
            tooltip: _isLoggedIn ? 'Profil Pengguna' : 'Masuk (Login)',
          ),
          const SizedBox(width: 10),
        ],
        
        // AppBar semi-transparan
        backgroundColor: Colors.black.withOpacity(0.6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body: Stack(
        children: [
          // === 1. Background Image ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Asumsi path gambar
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Center(child: Text("Background Image Not Found", style: TextStyle(color: Colors.red))),
              ),
            ),
          ),

          // === 2. Dark Overlay for Contrast ===
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Overlay gelap
            ),
          ),

          // === 3. Main Content (SingleChildScrollView) ===
          SingleChildScrollView(
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === HERO IMAGE (Jawa Tengah) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jateng.jpg', // Ganti gambar hero ke Jateng (Asumsi path)
                          width: double.infinity,
                          height: isMobile ? 220 : 350, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: isMobile ? 220 : 350,
                            color: Colors.grey.shade800,
                            child: const Center(child: Text("Hero Image Not Found", style: TextStyle(color: Colors.red))),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: isMobile ? 220 : 350,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: horizontalPadding, bottom: 20),
                          child: const Text(
                            'J A W A   T E N G A H',
                            style: TextStyle(
                              fontFamily: 'Nusantara',
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // === Deskripsi Gambar Hero ===
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                      child: Text(
                        'Kantor gubernur di Semarang pada masa kolonial', // Deskripsi gambar Jateng
                        style: TextStyle(
                          fontFamily: 'Nusantara',
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // === Konten Teks di bawah gambar ===
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // =======================================================
                          // Konten Sejarah dan Administrasi (DIPERBARUI)
                          // =======================================================
                          
                          _buildContentSection(title: "Geografi dan Batas Wilayah", content: geografiLokasi, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Administrasi dan Luas Wilayah", content: administrasiLuas, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Penggunaan Lahan", content: penggunaanLahan, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Era Kerajaan Kuno (Hindu/Buddha)", content: eraKuno, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Era Kesultanan Islam", content: eraIslam, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Era Kolonial dan Perjuangan Kemerdekaan", content: eraKolonialPerjuangan, isMobile: isMobile),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Iklim dan Suhu", content: iklimSuhu, isMobile: isMobile),
                          
                          // =======================================================
                          
                          const Divider(color: Colors.white24, height: 40),
                          
                          // --- Tombol Merchandise Panggilan Cepat ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MerchandisePage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                              label: const Text(
                                "Lihat Semua Merchandise Eksklusif!",
                                style: TextStyle(
                                  fontFamily: 'Nusantara',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // --- Akhir Tombol Merchandise Panggilan Cepat ---

                          // ===================== BAGIAN KOMENTAR (MODULAR BARU) =====================
                          CommentsSection(
                            key: _commentsSectionKey, // Inject GlobalKey
                            isMobile: isMobile,
                            horizontalPadding: 0, 
                            contentId: 'jawa_tengah', // ID unik untuk konten ini
                          ),

                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}