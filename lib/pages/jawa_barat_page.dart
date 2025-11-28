import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // BARU: Untuk cek status login

// Asumsi: Pastikan file-file halaman tujuan ini sudah ada
import 'intro_page.dart'; 
import '../widgets/comments_section.dart'; // BARU: Komponen komentar modular
import 'jakarta_page.dart';
import 'jawa_timur_page.dart'; 
import 'jawa_tengah_page.dart'; 
import 'bali_page.dart'; 

// Import halaman-halaman tujuan yang BARU DITAMBAHKAN:
import 'merchandise_page.dart'; 
import 'profil_page.dart'; 
import 'login_page.dart'; // BARU: Halaman Login


// --- FUNGSI MAIN UNTUK MENJALANKAN APLIKASI ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sejarah Jawa Barat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema gelap dipertahankan
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber, // UBAH: Warna utama Jawa Barat menjadi Amber
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black, // Background global
      ),
      home: const JawaBaratPage(),
    );
  }
}

// ============================================================================
//                   JAWA BARAT PAGE (StatefulWidget)
// ============================================================================
class JawaBaratPage extends StatefulWidget {
  // UBAH: Warna aksen statis menjadi Amber
  static const Color accentColor = Colors.amber; 
  
  const JawaBaratPage({super.key});

  @override
  State<JawaBaratPage> createState() => _JawaBaratPageState();
}

class _JawaBaratPageState extends State<JawaBaratPage> {
  // BARU: Status login
  bool _isLoggedIn = false; 
  
  // BARU: KUNCI KRITIS untuk CommentsSection
  final GlobalKey<CommentsSectionState> _commentsSectionKey = GlobalKey<CommentsSectionState>();
  
  // Map untuk menentukan rute halaman target
  final Map<String, Widget> pageRoutes = {
    'Jakarta': const JakartaPage(),
    'Jawa Timur': const JawaTimurPage(),
    'Jawa Tengah': const JawaTengahPage(), 
    'Jawa Barat': const JawaBaratPage(), // Current Page
    'Bali': const BaliPage(),
    'Merchandise': const MerchandisePage(),
    'Profil': const ProfilPage(),
  };

  // BARU: Fungsi untuk memeriksa status login
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
    Color accentColor = JawaBaratPage.accentColor, // Gunakan accentColor
  }) {
    final titleStyle = TextStyle(
      fontFamily: 'Nusantara',
      fontSize: isMobile ? 22 : 28,
      fontWeight: FontWeight.bold,
      color: accentColor, 
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
    const iconColor = JawaBaratPage.accentColor; // Menggunakan warna aksen amber
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

    // Daftar menu Sejarah Daerah (DIUBAH: Set Jawa Barat sebagai Current)
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': false},
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': false}, 
      {'name': 'Jawa Barat', 'isCurrent': true}, // Jawa Barat adalah halaman saat ini
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
                border: Border(bottom: BorderSide(color: JawaBaratPage.accentColor, width: 2)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jabar.jpg', // Asumsi path gambar Jawa Barat
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
                          'Sejarah Jawa Barat', 
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
                            color: JawaBaratPage.accentColor, // Menggunakan warna aksen amber
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
            iconColor: JawaBaratPage.accentColor, // Menggunakan warna aksen amber
            collapsedIconColor: Colors.white70,
            
            // Sub-menu (ListTile)
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;
              
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0), 
                leading: Icon(
                  isCurrent ? Icons.location_city : Icons.location_city_outlined, 
                  color: isCurrent ? JawaBaratPage.accentColor : listTileColor, // Menggunakan warna aksen amber
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: isCurrent ? JawaBaratPage.accentColor : listTileColor, // Menggunakan warna aksen amber
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
    // --- Konten Teks Jawa Barat (KONTEN DARI PENGGUNA - TIDAK DIUBAH) ---
    // --------------------------------------------------------------------------
    
    final String eraKunoKerajaan = "Jawa Barat adalah sebuah provinsi di Indonesia yang seluruh wilayahnya masuk ke dalam bagian dari **Tatar Sunda**. Ibu kotanya berada di Kota Bandung. Pada masa era kerajaan Hindu-Buddha, provinsi ini merupakan wilayah dengan ragam kerajaan, diantaranya, Kerajaan Jampang Manggung, Kerajaan Agrabintapura, Kerajaan Tanjung Singuru, Kerajaan Kendan, Kerajaan Galuh, Kerajaan Salakanagara, **Kerajaan Tarumanagara**, Kerajaan Sunda, Kerajaan Talaga Manggung, Kerajaan Galunggung, Kerajaan Sunda Galuh, Kerajaan Pajajaran, Kerajaan Tembong Agung, dan Kerajaan Sumedang Larang.\n\n"
        "Masyarakat Sunda modern pun mengenal wilayah ini sebagai bagian dari wilayah Tatar Sunda dengan tokoh sejarah utamanya **Sri Baduga Maharaja** atau dikenal sebagai **Raja Siliwangi** yang dianggap sebagai pemimpin pemersatu seluruh monarki yang ada di Parahyangan dan daerah Tatar Sunda lainnya dalam satu kerajaan bernama **Kerajaan Sunda** yang berpusat di **Pakuan Pajajaran** sebelum runtuh pada tahun 1579.";
    
    final String eraPrasejarah = "Daerah Jawa Barat diyakini sudah dihuni oleh manusia sejak ratusan ribu tahun yang lalu menurut temuan arkeologi di daerah Ciamis. Diperkirakan leluhur Suku Sunda modern berasal dari daratan Asia, dimana setelah mencapai pulau Jawa, mereka bermigrasi dari arah barat ke timur. Di era Pleistosen, wilayah Nusantara sebelah barat tergabung dengan benua Asia sebagai **Paparan Sunda** yang berseberangan dengan Paparan Sahul di timur yang tergabung dengan Australia.\n\n"
        "Temuan arkeologi di Anyer menunjukkan adanya budaya logam perunggu dan besi yang dimulai sebelum milenium pertama. Gerabah tanah liat prasejarah dari **Kebudayaan Buni** (Bekasi kuna) bisa ditemukan merentang dari Anyer sampai ke Cirebon. Masyarakat di daerah Jawa Barat diperkirakan sudah mengenal **Tradisi megalitik** atau pembuatan struktur menggunakan bebatuan besar seperti yang ditemukan di **Situs Gunung Padang** setidaknya sejak tahun **8000-6000 SM** (sebelum masehi). Sementara era perundagian atau pengolahan logam yang dimulai dengan **Zaman Perunggu** diperkirakan berawal di daerah Jawa Barat antara tahun **1000-500 SM**, melalui penemuan berupa kapak dan gelang perunggu di **Situs Cipari** di Kuningan. Masyarakat Jawa Barat diyakini sudah melakukan **kegiatan perdagangan internasional** di era prasejarah dengan metode barter, dengan adanya penemuan-penemuan berupa tembikar dan perhiasan yang berasal dari India dan Vietnam di beberapa situs arkeologi di daerah pesisir utara, khususnya di daerah Bekasi dan Karawang sekitar 400 SM-100 M.";
    
    final String eraKolonialParagraf1 = "Jawa Barat sebagai pengertian administratif mulai digunakan pada tahun **1925** ketika Pemerintah **Hindia Belanda** membentuk Provinsi Jawa Barat. Pembentukan provinsi itu dimaksudkan sebagai pelaksanaan *Bestuurshervormingwet* tahun 1922, yang membagi Hindia Belanda atas kesatuan-kesatuan daerah provinsi. Sebelum tahun 1925, digunakan istilah *Soendalanden* (**Tatar Soenda**) atau **Pasoendan**, sebagai istilah geografi untuk menyebut bagian Pulau Jawa di sebelah barat Sungai Cilosari dan Citanduy yang sebagian besar dihuni oleh penduduk yang menggunakan **bahasa Sunda** sebagai bahasa ibu.";
    
    final String eraKolonialParagraf2 = "Di bawah kebijakan Belanda wilayah batas Provinsi Jawa Barat mirip dengan peta yang dibayangkan oleh Mataram dan VOC pada 1706. Wilayah Provinsi Jawa Barat termasuk Banten, Batavia, Priangan, dan Cirebon (*statsblad* no. 235 dan 276, 1925; Ekadjati). Bagi sebagian orang Sunda istilah Jawa Barat berarti subordinat Jawa. Tentu mereka engan menggunakan terma ini dan lebih menyukai Sunda atau Pasoendan seperti petisi yang dilayangkan **Paguyuban Pasundan 1924-1925**. Sama halnya dengan Kongres Pemuda Sunda yang menyarankan Sunda sebagai nama provinsi ketimbang Jawa Barat. Semua ajuan ini tidak pernah terwujud. Istilah Sunda atau Tatar Sunda hanya menjadi terma budaya ketimbang politik.\n\n"
        "**1 Januari 1926** merupakan awal adanya sistem pemerintahan di Jawa Barat pada masa kolonial Belanda. Yang pertama kali memperjuangkan pembentukan sistem pemerintahan di Jawa Barat ke pemerintah Kolonial Belanda adalah para tokoh perjuangan yang ada seperti **Oto Iskandar di Nata**, **Husni Thamrin**, **Tjokroaminoto** dan tokoh lainnya. Usulan itu diterima pemerintah kolonial Belanda, ada sekitar 45 orang pribumi, 20 diantaranya tokoh Sunda yang terlibat dalam pemerintahan provinsi Jawa Barat kala itu.";
    
    final String eraKemerdekaanAwal = "Pada **17 Agustus 1945**, Jawa Barat bergabung menjadi bagian dari Republik Indonesia.\n\n"
        "Kemudian pada tanggal **27 Desember 1949**, Jawa Barat menjadi **Negara Pasundan** yang merupakan salah satu negara bagian dari Republik Indonesia Serikat (RIS) sebagai hasil kesepakatan tiga pihak dalam Konferensi Meja Bundar (KMB): Republik Indonesia, Bijeenkomst voor Federaal Overleg (BFO), dan Belanda. Kesepakatan ini disaksikan juga oleh United Nations Commission for Indonesia (UNCI) sebagai perwakilan PBB.\n\n"
        "Jawa Barat kemudian kembali bergabung dengan Republik Indonesia pada tahun **1950**.";
    
    final String administrasiModern = "Provinsi Jawa Barat merupakan provinsi yang pertama dibentuk di wilayah Indonesia pada era akhir kolonial (*staatblad* No. 378). Pasca kemerdekaan, Provinsi Jawa Barat dibentuk berdasarkan **UU No. 1 Tahun 1945** dan **UU No.11 Tahun 1950** yang membahas tentang Pembentukan Provinsi Jawa Barat. Jawa Barat merupakan provinsi dengan jumlah penduduk terbanyak di Indonesia.\n\n"
        "Bagian barat laut provinsi Jawa Barat berbatasan langsung dengan **Daerah Khusus Ibukota Jakarta**, ibukota negara Indonesia dimana pada masa monarki wilayah ini dikenal sebagai **Sunda Kalapa** yang merupakan pelabuhan utama dalam wilayah Kerajaan Sunda. Pada tahun **2000**, wilayah barat dari Provinsi Jawa Barat dimekarkan menjadi **Provinsi Banten**, yang saat awal pembentukan terdiri dari Kabupaten Pandeglang, Kabupaten Lebak, Kabupaten Tangerang, Kabupaten Serang, Kota Serang, dan Kota Tangerang. Saat ini terdapat wacana untuk mengubah nama Provinsi Jawa Barat menjadi **Provinsi Pasundan**, dengan memperhatikan aspek historis wilayah ini.";
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
            icon: const Icon(Icons.menu, color: JawaBaratPage.accentColor), // Menggunakan warna aksen amber
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Membuka Drawer
            },
            tooltip: 'Menu',
          ),
        ), 

        title: const Text('Sejarah Jawa Barat', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        
        // Actions (Tombol Merchandise dan Profil/Login - LOGIKA KRITIS BARU)
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

          // Tombol Profil / Login (LOGIKA DINAMIS)
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
          // === 1. Background Image (DIUBAH KE TARI-BALI.JPG) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // <--- BACKGROUND UTAMA BARU
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
                    // === HERO IMAGE (Jawa Barat) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jabar.jpg', // Asumsi path gambar hero Jawa Barat
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
                            'J A W A   B A R A T',
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
                    // === Deskripsi Gambar Hero (DIHILANGKAN) ===
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                    //   child: Text(
                    //     'Gunung Tangkuban Perahu, ikon alam Jawa Barat', 
                    //     style: TextStyle(
                    //       fontFamily: 'Nusantara',
                    //       fontSize: isMobile ? 12 : 14,
                    //       color: Colors.white70,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // === Konten Teks di bawah gambar ===
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // =======================================================
                          // Konten Sejarah (DIPANGGIL BERDASARKAN VARIABEL BARU)
                          // =======================================================
                          
                          _buildContentSection(title: "Era Prasejarah dan Kebudayaan Awal", content: eraPrasejarah, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Era Kerajaan Kuno (Tatar Sunda, Tarumanagara, Pajajaran)", content: eraKunoKerajaan, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          const Divider(color: Colors.white24, height: 40),
                          
                          // --- SISIPAN GAMBAR DI SINI ---
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Image.asset(
                                'assets/images/jabar2.png', // <--- GAMBAR SISIPAN BARU
                                fit: BoxFit.contain,
                                width: isMobile ? screenSize.width * 0.9 : 600, // Lebar responsif
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 200,
                                  color: Colors.grey.shade800,
                                  child: const Center(child: Text("Image jabar2.png Not Found", style: TextStyle(color: Colors.red))),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Spasi setelah gambar

                          _buildContentSection(title: "Masa Kolonial Belanda (1925)", content: eraKolonialParagraf1, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Masa Kolonial Belanda (1925)", content: eraKolonialParagraf2, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(title: "Era Kemerdekaan Awal dan Negara Pasundan", content: eraKemerdekaanAwal, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          const Divider(color: Colors.white24, height: 40),

                          _buildContentSection(title: "Administrasi Modern dan Pemekaran Banten", content: administrasiModern, isMobile: isMobile, accentColor: JawaBaratPage.accentColor),
                          
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
                                backgroundColor: JawaBaratPage.accentColor, // Menggunakan warna aksen amber
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
                            contentId: 'jawa_barat', // ID unik untuk konten ini
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