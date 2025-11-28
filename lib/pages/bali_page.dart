import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // BARU: Untuk cek status login

// --- Import Halaman Lain ---
// PASTIKAN SEMUA FILE HALAMAN BERIKUT ADA di folder yang sama (misal: 'pages/')
import 'intro_page.dart'; // Halaman Home/Landing
import '../widgets/comments_section.dart'; // BARU: Komponen komentar modular
import 'jakarta_page.dart';
import 'jawa_timur_page.dart';
import 'jawa_tengah_page.dart';
import 'jawa_barat_page.dart';
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
      title: 'Sejarah Bali',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema gelap dipertahankan
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber, // Warna utama menjadi Amber
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black, // Background global
      ),
      home: const BaliPage(),
    );
  }
}

// ============================================================================
//                          BALI PAGE (StatefulWidget)
// ============================================================================

class BaliPage extends StatefulWidget {
  // BARU: Konstanta warna aksen
  static const Color accentColor = Colors.amber;
  
  const BaliPage({super.key});

  @override
  State<BaliPage> createState() => _BaliPageState();
}

class _BaliPageState extends State<BaliPage> {
  // BARU: Status login
  bool _isLoggedIn = false;
  
  // BARU: KUNCI KRITIS untuk CommentsSection
  final GlobalKey<CommentsSectionState> _commentsSectionKey = GlobalKey<CommentsSectionState>();
  
  // Map untuk menentukan rute halaman target
  final Map<String, Widget> pageRoutes = {
    // Navigasi Home:
    'Jakarta': const JakartaPage(),
    'Jawa Timur': const JawaTimurPage(),
    'Jawa Tengah': const JawaTengahPage(), 
    'Jawa Barat': const JawaBaratPage(), 
    'Bali': const BaliPage(), // Current Page
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

  // Widget untuk menampilkan bagian teks konten
  Widget _buildContentSection({
    required String title,
    required String content,
    required bool isMobile,
    Color accentColor = BaliPage.accentColor, // Gunakan accentColor
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
    const iconColor = BaliPage.accentColor; // Menggunakan warna aksen amber
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

    // Daftar menu Sejarah Daerah (Set Bali sebagai Current)
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': false},
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': false}, 
      {'name': 'Jawa Barat', 'isCurrent': false}, 
      {'name': 'Bali', 'isCurrent': true}, // Bali adalah halaman saat ini
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
                border: Border(bottom: BorderSide(color: BaliPage.accentColor, width: 2)), // Warna border amber
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/bali.jpg', // Asumsi path gambar Bali
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
                          'Sejarah Bali', 
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
                            color: BaliPage.accentColor, // Warna aksen amber
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
            iconColor: BaliPage.accentColor, // Warna aksen amber
            collapsedIconColor: Colors.white70,
            
            // Sub-menu (ListTile)
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;
              
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0), 
                leading: Icon(
                  isCurrent ? Icons.location_city : Icons.location_city_outlined, 
                  color: isCurrent ? BaliPage.accentColor : listTileColor, // Warna aksen amber
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: isCurrent ? BaliPage.accentColor : listTileColor, // Warna aksen amber
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
    // --- Konten Teks Bali (Dipertahankan) ---
    // --------------------------------------------------------------------------
    
    final String part1Awal = 
        "Pulau Bali, seperti kebanyakan pulau di kepulauan Indonesia, adalah hasil dari **subduksi tektonik** lempeng Indo-Australia di bawah lempeng Eurasia. Dasar laut tersier, yang terbuat dari endapan laut purba termasuk akumulasi terumbu karang, terangkat di atas permukaan laut oleh subduksi. Lapisan batu kapur tersier yang terangkat dari dasar samudra masih terlihat di daerah-daerah seperti **Bukit semenanjung** dengan tebing batu kapur besar di Uluwatu, atau di barat laut pulau di Prapat Agung.";

    final String part2Vulkanik =
        "Deformasi lokal lempeng Eurasia yang diciptakan oleh subduksi telah mendorong kerak kerak, yang menyebabkan munculnya **fenomena vulkanik**. Sederetan gunung berapi berjajar di bagian utara pulau itu, di poros Barat-Timur di mana bagian barat tertua, dan bagian timur terbaru. Gunung berapi tertinggi adalah gunung berapi strato-aktif **Gunung Agung**, pada 3.142 m (10.308 kaki).";
    
    final String part3DampakVulkanik =
        "Aktivitas vulkanik telah berlangsung intens selama berabad-abad, dan sebagian besar permukaan pulau (diluar Semenanjung Bukit dan Prapat Agung) telah ditutupi oleh magma vulkanik. Beberapa endapan lama tetap (lebih tua dari 1 juta tahun), sementara sebagian besar bagian tengah pulau ditutupi oleh endapan vulkanik muda (kurang dari 1 juta tahun), dengan beberapa ladang lava yang sangat baru di timur laut karena letusan dahsyat akibat bencana alam **Gunung Agung pada tahun 1963**.\n\n"
        "Aktivitas gunung berapi, karena endapan abu yang tebal dan kesuburan tanah yang dihasilkannya, juga merupakan faktor kuat dalam kemakmuran pertanian pulau tersebut.";

    final String part4PaparanSunda =
        "Di tepi subduksi, Bali juga berada di tepi beting **Paparan Sunda**, tepat di sebelah barat **garis Wallace**, dan pada satu waktu terhubung ke pulau tetangga Jawa, terutama selama penurunan permukaan laut di dalam Zaman es. Karena itu fauna dan floranya mendekati benua Asia.";
    
    // --- Bagian 2: Prasejarah ---
    final String part5Paleolitik = 
        "Bali menjadi bagian dari paparan Sunda, pulau ini telah terhubung ke pulau Jawa berkali-kali dalam sejarah. Bahkan hari ini, kedua pulau hanya dipisahkan oleh Selat Bali yang berjarak 2,4 km.\n\n"
        "Pendudukan oleh manusia Jawa kuno sendiri terakreditasi oleh temuan **manusia Jawa**, berumur antara 1,7 dan 0,7 juta tahun, salah satu spesimen **Homo erectus** yang pertama diketahui.\n\n"
        "Bali juga dihuni pada zaman **Paleolitik** (diperkirakan 1 SM hingga 200.000 SM), disaksikan oleh penemuan alat kuno seperti kapak tangan yang ditemukan di desa Sembiran dan Trunyan di Bali.\n\n"
        "Sebuah periode **Mesolitik** (200.000-30.000 SM) juga telah diidentifikasi, ditandai dengan pengumpulan dan perburuan makanan canggih, tetapi masih oleh Homo Erectus. Periode ini menghasilkan alat yang lebih canggih, seperti mata panah, dan juga alat yang terbuat dari tulang hewan atau ikan. Mereka tinggal di gua-gua sementara, seperti yang ditemukan di bukit Pecatu di Kabupaten Badung, seperti gua Selanding dan Karang Boma. Gelombang pertama **Homo Sapiens** tiba sekitar 45.000 SM ketika orang-orang Australoid bermigrasi ke selatan, menggantikan Homo Erectus.";

    // --- Bagian 3: Sejarah Modern Awal ---
    final String part6PenjajahanAwal =
        "Sejak **kerajaan Buleleng** jatuh ke tangan Belanda mulailah pemerintah Belanda ikut campur mengurus soal pemerintahan di Bali. Hal ini dilaksanakan dengan mengubah nama raja sebagai penguasa daerah dengan nama regent untuk daerah Buleleng dan Jembrana serta menempatkan P.L. Van Bloemen Waanders sebagai controleur yang pertama di Bali.\n\n"
        "Struktur pemerintahan di Bali masih berakar pada struktur pemerintahan tradisional, yaitu tetap mengaktifkan kepemimpinan tradisional dalam melaksanakan pemerintahan di daerah-daerah. Untuk di daerah Bali, kedudukan raja merupakan pemegang kekuasaan tertinggi, yang pada waktu pemerintahan kolonial didampingi oleh seorang **controleur**. Di dalam bidang pertanggungjawaban, raja langsung bertanggung jawab kepada Residen Bali dan Lombok yang berkedudukan di Singaraja, sedangkan untuk Bali Selatan, raja-rajanya betanggung jawab kepada Asisten Residen yang berkedudukan di Denpasar.\n\n";
    
    final String part6PenjajahanAkhir = 
        "Untuk memenuhi kebutuhan tenaga administrasi, pemerintah Belanda telah membuka sebuah sekolah rendah yang pertama di Bali, yakni di Singaraja (1875) yang dikenal dengan nama **Tweede Klasse School**. Pada 1913, dibuka sebuah sekolah dengan nama **Erste Inlandsche School** dan kemudian disusul dengan sebuah sekolah Belanda dengan nama **Hollands Inlandshe School (HIS)** yang muridnya kebanyakan berasal dari anak-anak bangsawan dan golongan kaya.";
    
    // --- Bagian 4: Pergerakan ---
    final String part7Organisasi = 
        "Akibat pengaruh pendidikan yang didapat, para pemuda pelajar dan beberapa orang yang telah mendapatkan pekerjaan di kota Singaraja berinisiatif untuk mendirikan sebuah perkumpulan dengan nama \"Suita Gama Tirta\" yang bertujuan untuk memajukan masyarakat Bali dalam dunia ilmu pengetahuan melalui ajaran agama. Sayang perkumpulan ini tidak burumur panjang. Kemudian beberapa guru yang masih haus dengan pendidikan agama mendirikan sebuah perkumpulan yang diberi nama \"Shanti\" pada tahun 1923. Perkumpulan ini memiliki sebuah majalah yang bernama \"Shanti Adnyana\" yang kemudian berubah menjadi \"Bali Adnyana\"\n\n"
        "Pada tahun 1925 di Singaraja juga didirikan sebuah perkumpulan yang diberi nama \"Suryakanta\" dan memiliki sebuah majalah yang diberi nama \"Suryakanta\". Seperti perkumpulan Shanti, Suryakanta menginginkan agar masyarakat Bali mengalami kemajuan dalam bidang pengetahuan dan menghapuskan adat istiadat yang sudah tidak sesuai dengan perkembangan zaman. Sementara itu, di Karangasem lahir suatu perhimpunan yang bernama \"Satya Samudaya Baudanda Bali Lombok\" yang anggotanya terdiri atas pegawai negeri dan masyarakat umum dengan tujuan menyimpan dan mengumpulkan uang untuk kepentingan studiefonds.";

    // --- Bagian 5: Kemerdekaan ---
    final String part8Kemerdekaan =
        "Menyusul Proklamasi Kemerdekaan Indonesia, pada tanggal 23 Agustus 1945, Mr. I Gusti Ketut Puja tiba di Bali dengan membawa mandat pengangkatannya sebagai Gubernur Sunda Kecil. Sejak kedatangan dia inilah Proklamasi Kemerdekaan Indonesia di Bali mulai disebarluaskan sampai ke desa-desa. Pada saat itulah mulai diadakan persiapan-persiapan untuk mewujudkan susunan pemerintahan di Bali sebagai daerah Sunda Kecil dengan ibu kotanya Singaraja.\n\n"
        "Sejak pendaratan NICA di Bali, Bali selalu menjadi arena pertempuran. Dalam pertempuran itu pasukan RI menggunakan sistem gerilya. Oleh karena itu, MBO sebagai induk pasukan selalu berpindah-pindah. Untuk memperkuat pertahanan di Bali, didatangkan bantuan ALRI dari Jawa yang kemudian menggabungkan diri ke dalam pasukan yang ada di Bali. Karena seringnya terjadi pertempuran, pihak Belanda pernah mengirim surat kepada Rai untuk mengadakan perundingan. Akan tetapi, pihak pejuang Bali tidak bersedia, bahkan terus memperkuat pertahanan dengan mengikutsertakan seluruh rakyat.\n\n"
        "Untuk memudahkan kontak dengan Jawa, Rai pernah mengambil siasat untuk memindahkan perhatian Belanda ke bagian timur Pulau Bali. Pada 28 Mei 1946 Rai mengerahkan pasukannya menuju ke timur dan ini terkenal dengan sebutan \"Long March\". Selama diadakan \"Long March\" itu pasukan gerilya sering dihadang oleh tentara Belanda sehingga sering terjadi pertempuran. Pertempuran yang membawa kemenangan di pihak pejuang ialah pertempuran Tanah Arun, yaitu pertempuran yang terjadi di sebuah desa kecil di lereng Gunung Agung, Kabupaten Karangasem. Dalam pertempuran Tanah Arun yang terjadi 9 Juli 1946 itu pihak Belanda banyak menjadi korban. Setelah pertempuran itu pasukan Ngurah Rai kembali menuju arah barat yang kemudian sampai di Desa Marga (Tabanan). Untuk lebih menghemat tenaga karena terbatasnya persenjataan, ada beberapa anggota pasukan terpaksa disuruh berjuang bersama-sama dengan masyarakat.";

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
            icon: const Icon(Icons.menu, color: BaliPage.accentColor), // Warna aksen amber
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Membuka Drawer
            },
            tooltip: 'Menu',
          ),
        ), 

        title: const Text('Sejarah Bali', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        
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
          // === 1. Background Image (tari-bali.jpg) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // BACKGROUND UTAMA
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
                    // === HERO IMAGE (Bali) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/balidulu.jpg', // Asumsi path gambar hero Bali
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
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( 
                                'B A L I',
                                style: TextStyle(
                                  fontFamily: 'Nusantara',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              // Dihilangkan: SizedBox(height: 5) dan Text deskripsi: 'Pulau Dewata, pusat kebudayaan Hindu'
                            ],
                          ),
                        ),
                      ],
                    ),

                    // === Konten Teks di bawah gambar ===
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // =======================================================
                          // Konten Geologi & Prasejarah
                          // =======================================================
                          
                          _buildContentSection(
                            title: "Geologi, Fenomena Vulkanik, dan Paparan Sunda", 
                            content: "$part1Awal\n\n$part2Vulkanik\n\n$part3DampakVulkanik\n\n$part4PaparanSunda", 
                            isMobile: isMobile, 
                            accentColor: BaliPage.accentColor
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(
                            title: "Masa Prasejarah (Paleolitik hingga Homo Sapiens)", 
                            content: part5Paleolitik, 
                            isMobile: isMobile, 
                            accentColor: BaliPage.accentColor
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          // --- SISIPAN GAMBAR DI TENGAH KONTEN (pura.jpg) ---
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Image.asset(
                                'assets/images/bali2.jpg', // GAMBAR SISIPAN
                                fit: BoxFit.contain,
                                width: isMobile ? screenSize.width * 0.9 : 600, // Lebar responsif
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 200,
                                  color: Colors.grey.shade800,
                                  child: const Center(child: Text("Image pura.jpg Not Found", style: TextStyle(color: Colors.red))),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Spasi setelah gambar

                          // =======================================================
                          // Konten Era Kolonial dan Pergerakan
                          // =======================================================

                          _buildContentSection(
                            title: "Masa Penjajahan Belanda dan Struktur Pemerintahan", 
                            content: "$part6PenjajahanAwal\n$part6PenjajahanAkhir", 
                            isMobile: isMobile, 
                            accentColor: BaliPage.accentColor
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(
                            title: "Organisasi Pergerakan Nasional Awal", 
                            content: part7Organisasi, 
                            isMobile: isMobile, 
                            accentColor: BaliPage.accentColor
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          _buildContentSection(
                            title: "Proklamasi Kemerdekaan dan Perjuangan Ngurah Rai", 
                            content: part8Kemerdekaan, 
                            isMobile: isMobile, 
                            accentColor: BaliPage.accentColor
                          ),
                          
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
                                backgroundColor: BaliPage.accentColor, // Warna aksen amber
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
                            contentId: 'bali', // ID unik untuk konten ini
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