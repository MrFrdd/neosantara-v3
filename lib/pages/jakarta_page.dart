library flutter_app;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'intro_page.dart';
// Asumsi path ini benar, jika tidak, mohon sesuaikan
import '../widgets/comments_section.dart'; 

// Import halaman-halaman tujuan yang baru:
import 'jawa_timur_page.dart';
import 'jawa_tengah_page.dart';
import 'jawa_barat_page.dart';
import 'bali_page.dart';
import 'merchandise_page.dart';
import 'profil_page.dart';
import 'login_page.dart'; 

// --- Halaman JakartaPage (StatefulWidget) ---

class JakartaPage extends StatefulWidget {
  const JakartaPage({super.key});

  @override
  State<JakartaPage> createState() => _JakartaPageState();
}

class _JakartaPageState extends State<JakartaPage> {
  // Status login
  bool _isLoggedIn = false; 
  
  // KUNCI KRITIS: Untuk mengakses State dari CommentsSection dan memanggil refresh.
  final GlobalKey<CommentsSectionState> _commentsSectionKey = GlobalKey<CommentsSectionState>();

  static const Map<String, Widget> pageRoutes = {
    'Jakarta': JakartaPage(),
    'Jawa Timur': JawaTimurPage(),
    'Jawa Tengah': JawaTengahPage(),
    'Jawa Barat': JawaBaratPage(),
    'Bali': BaliPage(),
    'Merchandise': MerchandisePage(),
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
    _checkLoginStatus(); 
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --- Widget Pembantu (Disederhanakan) ---

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 15),
        Text(content, textAlign: TextAlign.justify, style: contentStyle),
      ],
    );
  }

  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = Colors.amber;
    final double headerHeight = isMobile ? 180 : 220;

    void navigateTo(String destination) {
      Navigator.pop(context);

      if (destination == 'Home') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()),
        );
      }
      else if (pageRoutes.containsKey(destination)) {
        Widget nextPage = pageRoutes[destination]!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Halaman $destination belum diimplementasikan.',
              style: const TextStyle(fontFamily: 'Nusantara'),
            ),
          ),
        );
      }
    }

    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': true},
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': false},
      {'name': 'Jawa Barat', 'isCurrent': false},
      {'name': 'Bali', 'isCurrent': false},
    ];

    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.95),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: headerHeight,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jakarta1.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Text(
                            "Header Image Not Found",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
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
                          'Sejarah Jakarta',
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
          ListTile(
            leading: const Icon(Icons.home, color: iconColor),
            title: const Text(
              'Home',
              style: TextStyle(
                fontFamily: 'Nusantara',
                color: listTileColor,
                fontSize: 18,
              ),
            ),
            onTap: () => navigateTo('Home'),
          ),
          const Divider(color: Colors.white12),
          ExpansionTile(
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0),
                leading: Icon(
                  isCurrent
                      ? Icons.location_city
                      : Icons.location_city_outlined,
                  color: isCurrent ? Colors.amber : listTileColor,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: isCurrent ? Colors.amber : listTileColor,
                    fontWeight:
                        isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
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

    final String part1Awal =
        "Jakarta adalah ibu kota dan kota terbesar Indonesia. Terletak di estuari Sungai Ciliwung, di bagian barat laut Jawa, daerah ini telah lama menopang pemukiman manusia. Bukti bersejarah dari Jakarta berasal dari abad ke-4 M, saat ia merupakan sebuah permukiman dan pelabuhan Hindu. Kota ini telah diklaim secara berurutan oleh kerajaan bercorak India Tarumanegara, Kerajaan Sunda Hindu, Kesultanan Banten Muslim, dan oleh pemerintahan Belanda, Jepang, dan Indonesia. Hindia Belanda membangun daerah tersebut sebelum direbut oleh Kekaisaran Jepang semasa Perang Dunia II dan akhirnya menjadi merdeka sebagai bagian dari Indonesia.";

    final String part2Perkembangan =
        "Jakarta telah dikenal dengan beberapa nama. Ia disebut Sunda Kalapa selama periode Kerajaan Sunda dan Jayakarta, Djajakarta, atau Jacatra selama periode singkat Kesultanan Banten. Setelah itu, Jakarta berkembang dalam tiga tahap. \"Kota Tua Jakarta\", yang dekat dengan laut di utara, berkembang antara 1619 dan 1799 pada era VOC. \"Kota baru\" di selatan berkembang antara 1809 dan 1942 setelah pemerintah Belanda mengambil alih penguasaan Batavia dari VOC yang gagal yang sewanya telah berakhir pada 1799. Yang ketiga adalah perkembangan Jakarta modern sejak proklamasi kemerdekaan pada 1945. Di bawah pemerintahan Belanda, ia dikenal sebagai Batavia (1619–1949), dan Djakarta (dalam bahasa Belanda) atau Jakarta, selama pendudukan Jepang dan masa modern.";

    final String part5KerajaanSunda =
        "Setelah kekuasaan Tarumanagara melemah, wilayahnya kemudian menjadi bagian dari Kerajaan Sunda. Menurut sumber Tiongkok, Chu-fan-chi yang ditulis oleh Chou Ju-kua pada awal abad ke-13, kerajaan Sriwijaya yang berbasis di Sumatra menguasai Sumatra, Semenanjung Malaya, dan Jawa bagian barat (dikenal sebagai Sunda). Pelabuhan Sunda digambarkan sebagai pelabuhan yang strategis dan ramai, dengan lada dari Sunda terkenal karena kualitasnya yang sangat baik. Penduduk di wilayah tersebut bekerja di bidang pertanian, dan rumah mereka dibangun di atas tiang kayu.\n\n"
        "Salah satu pelabuhan di muara Sungai Ciliwung kemudian dinamai Sunda Kelapa atau Kalapa (Kelapa Sunda), sebagaimana tertulis dalam naskah Hindu Bujangga Manik, yaitu manuskrip lontar seorang resi, yang merupakan salah satu peninggalan berharga dari sastra Sunda Kuno. Pelabuhan tersebut melayani ibu kota Pakuan Pajajaran (sekarang Bogor), pusat pemerintahan Kerajaan Sunda. Pada abad ke-14, Sunda Kelapa berkembang menjadi pelabuhan perdagangan utama kerajaan.\n\n"
        "Catatan para penjelajah Eropa abad ke-16 menyebut sebuah kota bernama Kalapa, yang tampaknya berfungsi sebagai pelabuhan utama kerajaan Hindu Sunda. Pada tahun 1522, pihak Portugis membuat perjanjian politik dan ekonomi yang disebut Luso-Sundanese padrão dengan Kerajaan Sunda, sebagai otoritas pelabuhan tersebut. Sebagai imbalan atas bantuan militer menghadapi ancaman Kesultanan Demak yang sedang bangkit, Prabu Surawisesa, raja Sunda pada masa itu, memberikan mereka akses bebas dalam perdagangan lada. Orang-orang Portugis yang mengabdi pada raja pun menetap di Sunda Kelapa.";

    return Scaffold(
      drawer: _buildAppDrawer(context, isMobile),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.amber),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
        title: const Text(
          'Sejarah Jakarta',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
          
          // Tombol Profil / Login (LOGIKA KRITIS)
          IconButton(
            icon: Icon(
              _isLoggedIn ? Icons.person : Icons.login,
              color: Colors.white
            ),
            onPressed: () {
              final initialContext = context; 
              
              if (_isLoggedIn) {
                // Sudah login -> Navigasi ke halaman Profil
                Navigator.push(
                  initialContext,
                  MaterialPageRoute(builder: (context) => const ProfilPage()),
                ).then((value) { // <--- KRITIS: Dengar hasil dari ProfilPage
                    // 'value' akan bernilai 'true' jika logout
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
                        
                        // 2. Perbarui status login di JakartaPage
                        _checkLoginStatus(); 
                        
                        // 3. KRITIS: Refresh CommentsSection setelah login sukses
                        _commentsSectionKey.currentState?.loadComments(); 
                        
                        // 4. Tampilkan SnackBar (Dipastikan setelah pop)
                        Future.delayed(Duration.zero, () {
                            if (mounted) {
                                ScaffoldMessenger.of(initialContext).showSnackBar(
                                    const SnackBar(
                                        content: Text("Status login dan Komentar diperbarui!"),
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
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "Background Image Not Found",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jakarta1.jpg',
                          width: double.infinity,
                          height: isMobile ? 220 : 350,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: isMobile ? 220 : 350,
                            color: Colors.grey.shade800,
                            child: const Center(
                              child: Text(
                                "Hero Image Not Found",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
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
  padding: EdgeInsets.only(
    left: horizontalPadding,
    bottom: 20,
  ),
  child: const Text(
    'J A K A R T A',
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
                    // === KONTEN ===
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContentSection(
                            title: "Sejarah Singkat dan Pengklaiman Wilayah",
                            content: part1Awal,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          _buildContentSection(
                            title: "Perkembangan Nama dan Tiga Tahap Kota",
                            content: part2Perkembangan,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          _buildContentSection(
                            title: "Kerajaan Sunda (669–1527)",
                            content: part5KerajaanSunda,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
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

                          // ===================== BAGIAN KOMENTAR (DENGAN KEY) =====================
                          CommentsSection(
                            key: _commentsSectionKey, // Inject GlobalKey di sini
                            isMobile: isMobile,
                            horizontalPadding: 0, 
                            contentId: 'jakarta',
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