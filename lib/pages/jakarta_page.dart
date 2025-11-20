import 'package:flutter/material.dart';
// Asumsi Anda memiliki IntroPage di path yang sama atau relatif
import 'intro_page.dart'; // <-- Pastikan path ini benar!

// Import halaman-halaman tujuan yang baru:
// PASTIKAN FILE-FILE INI ADA DI FOLDER YANG SAMA!
import 'jawa_timur_page.dart';
import 'jawa_tengah_page.dart';
import 'jawa_barat_page.dart';
import 'bali_page.dart';

// --- Model dan Data Tiruan ---

// Model untuk data komentar tiruan
class Comment {
  final String user;
  final String date;
  final String content;
  Comment(this.user, this.date, this.content);
}

// Data komentar tiruan (Sekarang kosong - akan diisi oleh _submitComment)
final List<Comment> mockComments = [];

// --- Halaman JakartaPage (StatefulWidget) ---

// Ubah menjadi StatefulWidget untuk mengelola TextEditingController
class JakartaPage extends StatefulWidget {
  const JakartaPage({super.key});

  @override
  State<JakartaPage> createState() => _JakartaPageState();
}

class _JakartaPageState extends State<JakartaPage> {
  // Controller untuk mengelola input komentar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Map untuk menentukan rute halaman target
  // Menggunakan konstruktor konstan agar bisa digunakan di sini
  static const Map<String, Widget> pageRoutes = {
    'Jakarta': JakartaPage(),
    'Jawa Timur': JawaTimurPage(),
    'Jawa Tengah': JawaTengahPage(),
    'Jawa Barat': JawaBaratPage(),
    'Bali': BaliPage(),
  };

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // --- Widget Pembantu ---

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
      color: Colors.amber, // Warna emas/kuning untuk judul
    );
    final contentStyle = TextStyle(
      fontFamily: 'Nusantara',
      fontSize: isMobile ? 16 : 18, // Menyesuaikan ukuran font konten
      color: Colors.white70, // Warna putih pudar untuk konten
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

  // Widget untuk menampilkan Kolom Komentar
  Widget _buildCommentSection({required bool isMobile}) {
    // Logika Mock KIRIM Komentar (Hanya untuk demonstrasi)
    void _submitComment() {
      final name = _nameController.text.trim();
      final content = _commentController.text.trim();

      if (name.isNotEmpty && content.isNotEmpty) {
        // Karena mockComments adalah list global (final), kita perlu setState
        // untuk memicu build ulang dan menampilkan komentar baru.
        setState(() {
          // Tambahkan komentar ke list global
          mockComments.add(Comment(name, "Baru saja", content));
        });
        _nameController.clear();
        _commentController.clear();
        // Tampilkan Snackbar konfirmasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Komentar berhasil ditambahkan (Mock).',
              style: TextStyle(fontFamily: 'Nusantara'),
            ),
          ),
        );
      } else {
        // Tampilkan Snackbar jika input kosong
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Nama dan komentar tidak boleh kosong.',
              style: TextStyle(fontFamily: 'Nusantara'),
            ),
          ),
        );
      }
    }

    // List Komentar yang akan di-build
    final commentList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mockComments.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    "Belum ada komentar. Jadilah yang pertama berkomentar!",
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      color: Colors.grey.shade400,
                      fontSize: isMobile ? 16 : 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]
          : mockComments.map((comment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          comment.user,
                          style: TextStyle(
                            fontFamily: 'Nusantara',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isMobile ? 16 : 18,
                          ),
                        ),
                        Text(
                          comment.date,
                          style: TextStyle(
                            fontFamily: 'Nusantara',
                            color: Colors.grey.shade400,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      comment.content,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Nusantara',
                        color: Colors.white70,
                        fontSize: isMobile ? 15 : 16,
                        height: 1.5,
                      ),
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 10,
                      thickness: 0.5,
                    ),
                  ],
                ),
              );
            }).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Komentar
        Text(
          "Kolom Komentar",
          style: TextStyle(
            fontFamily: 'Nusantara',
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 25),

        // Comment Input Form
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _nameController, // <--- Controller Nama
                decoration: InputDecoration(
                  hintText: "Nama Anda",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: 'Nusantara',
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nusantara',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _commentController, // <--- Controller Komentar
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tulis komentar Anda di sini...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: 'Nusantara',
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nusantara',
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComment, // <--- Gunakan fungsi submit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Warna tombol sesuai tema
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Kirim Komentar",
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Daftar Komentar Tiruan
        commentList,
      ],
    );
  }

  // Widget baru untuk membuat menu drawer (menu strip 3)
  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = Colors.amber;
    final double headerHeight = isMobile ? 180 : 220; // Tinggi header responsif

    // Fungsi navigasi yang sesungguhnya (untuk semua rute)
    void navigateTo(String destination) {
      Navigator.pop(context); // Tutup drawer

      if (destination == 'Home') {
        // Navigasi ke IntroPage dan HAPUS semua rute sebelumnya (pushReplacement)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const IntroPage(),
          ), // <--- Navigasi ke IntroPage
        );
      } else if (pageRoutes.containsKey(destination)) {
        // NAVIGASI NYATA untuk halaman daerah lain (menggunakan pushReplacement)
        Widget nextPage = pageRoutes[destination]!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        // Fallback jika ada menu yang belum terdefinisi
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

    // Daftar menu Sejarah Daerah
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': true}, // Jakarta adalah halaman saat ini
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': false},
      {'name': 'Jawa Barat', 'isCurrent': false},
      {'name': 'Bali', 'isCurrent': false},
    ];

    return Drawer(
      // Background Drawer sedikit transparan gelap
      backgroundColor: Colors.black.withOpacity(0.95),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // === HEADER DRAWER BARU (Dengan Gambar) ===
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
                  // Gambar Background Header
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jakarta1.jpg', // Gambar Jakarta
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
                  // Overlay Gradien untuk Kontras
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
                  // Teks Judul
                  const Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sejarah Jakarta', // Teks diubah
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

          // Menu Home (Fungsi navigasi nyata)
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
            onTap: () => navigateTo('Home'), // <--- Menuju IntroPage
          ),

          const Divider(color: Colors.white12),

          // === ExpansionTile Sejarah Daerah ===
          ExpansionTile(
            initiallyExpanded: true, // Biarkan terbuka secara default
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 0,
            ),
            leading: const Icon(Icons.map_outlined, color: iconColor),
            title: const Text(
              'Sejarah Daerah',
              style: TextStyle(
                fontFamily: 'Nusantara',
                color: Colors
                    .white, // Ganti warna judul agar berbeda dari sub-menu
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Warna ikon panah saat terbuka/tertutup
            iconColor: Colors.amber,
            collapsedIconColor: Colors.white70,

            // Sub-menu (ListTile)
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;

              return ListTile(
                // Tambahkan padding kiri agar terlihat sebagai sub-menu
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
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                onTap: () =>
                    navigateTo(name), // <--- Menggunakan fungsi navigasi baru
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

    // Menghitung padding atas (status bar + AppBar height)
    final double topSafeAreaPadding = MediaQuery.of(context).padding.top;
    const double kAppBarHeight = 56.0; // Tinggi standar AppBar
    final double topPadding = topSafeAreaPadding + kAppBarHeight;

    // =========================================================================
    // Konten Teks Jakarta
    // =========================================================================
    final String part1Awal =
        "Jakarta adalah ibu kota dan kota terbesar Indonesia. Terletak di estuari Sungai Ciliwung, di bagian barat laut Jawa, daerah ini telah lama menopang pemukiman manusia. Bukti bersejarah dari Jakarta berasal dari abad ke-4 M, saat ia merupakan sebuah permukiman dan pelabuhan Hindu. Kota ini telah diklaim secara berurutan oleh kerajaan bercorak India Tarumanegara, Kerajaan Sunda Hindu, Kesultanan Banten Muslim, dan oleh pemerintahan Belanda, Jepang, dan Indonesia. Hindia Belanda membangun daerah tersebut sebelum direbut oleh Kekaisaran Jepang semasa Perang Dunia II dan akhirnya menjadi merdeka sebagai bagian dari Indonesia.";

    final String part2Perkembangan =
        "Jakarta telah dikenal dengan beberapa nama. Ia disebut Sunda Kalapa selama periode Kerajaan Sunda dan Jayakarta, Djajakarta, atau Jacatra selama periode singkat Kesultanan Banten. Setelah itu, Jakarta berkembang dalam tiga tahap. \"Kota Tua Jakarta\", yang dekat dengan laut di utara, berkembang antara 1619 dan 1799 pada era VOC. \"Kota baru\" di selatan berkembang antara 1809 dan 1942 setelah pemerintah Belanda mengambil alih penguasaan Batavia dari VOC yang gagal yang sewanya telah berakhir pada 1799. Yang ketiga adalah perkembangan Jakarta modern sejak proklamasi kemerdekaan pada 1945. Di bawah pemerintahan Belanda, ia dikenal sebagai Batavia (1619–1949), dan Djakarta (dalam bahasa Belanda) atau Jakarta, selama pendudukan Jepang dan masa modern.";

    final String part3KerajaanAwal =
        "Daerah pesisir dan pelabuhan Jakarta di utara Jawa Barat telah menjadi lokasi permukiman manusia sejak kebudayaan Buni abad ke-4 SM. Catatan sejarah paling awal yang ditemukan di Jakarta adalah Prasasti Tugu, yang ditemukan di Kecamatan Tugu, Jakarta Utara. Ia merupakan salah satu prasasti tertua dalam Sejarah Indonesia. Daerah tersebut adalah bagian dari kerajaan bercorak India Tarumanegara.";

    final String part4Tarumanagara =
        "Pada tahun 397 M, Raja Purnawarman mendirikan Sunda Pura, yang terletak di pantai utara Jawa Barat, sebagai ibu kota baru kerajaan.[4] Ibu kota kerajaan Tarumanagara tersebut kemungkinan besar terletak di suatu tempat antara Kecamatan Tugu, Jakarta Utara dan Kabupaten Bekasi, Jawa Barat. Purnawarman meninggalkan tujuh batu peringatan di seluruh daerah tersebut, termasuk Provinsi Banten dan Jawa Barat saat ini, yang terdiri dari prasasti yang memuat namanya.";

    // BAGIAN BARU: Kerajaan Sunda (669–1527)
    final String part5KerajaanSunda =
        "Setelah kekuasaan Tarumanagara melemah, wilayahnya kemudian menjadi bagian dari Kerajaan Sunda. Menurut sumber Tiongkok, Chu-fan-chi yang ditulis oleh Chou Ju-kua pada awal abad ke-13, kerajaan Sriwijaya yang berbasis di Sumatra menguasai Sumatra, Semenanjung Malaya, dan Jawa bagian barat (dikenal sebagai Sunda). Pelabuhan Sunda digambarkan sebagai pelabuhan yang strategis dan ramai, dengan lada dari Sunda terkenal karena kualitasnya yang sangat baik. Penduduk di wilayah tersebut bekerja di bidang pertanian, dan rumah mereka dibangun di atas tiang kayu.\n\n"
        "Salah satu pelabuhan di muara Sungai Ciliwung kemudian dinamai Sunda Kelapa atau Kalapa (Kelapa Sunda), sebagaimana tertulis dalam naskah Hindu Bujangga Manik, yaitu manuskrip lontar seorang resi, yang merupakan salah satu peninggalan berharga dari sastra Sunda Kuno. Pelabuhan tersebut melayani ibu kota Pakuan Pajajaran (sekarang Bogor), pusat pemerintahan Kerajaan Sunda. Pada abad ke-14, Sunda Kelapa berkembang menjadi pelabuhan perdagangan utama kerajaan.\n\n"
        "Catatan para penjelajah Eropa abad ke-16 menyebut sebuah kota bernama Kalapa, yang tampaknya berfungsi sebagai pelabuhan utama kerajaan Hindu Sunda. Pada tahun 1522, pihak Portugis membuat perjanjian politik dan ekonomi yang disebut Luso-Sundanese padrão dengan Kerajaan Sunda, sebagai otoritas pelabuhan tersebut. Sebagai imbalan atas bantuan militer menghadapi ancaman Kesultanan Demak yang sedang bangkit, Prabu Surawisesa, raja Sunda pada masa itu, memberikan mereka akses bebas dalam perdagangan lada. Orang-orang Portugis yang mengabdi pada raja pun menetap di Sunda Kelapa.";
    // =========================================================================

    return Scaffold(
      // === DRAWER (MENU STRIP 3) ===
      drawer: _buildAppDrawer(context, isMobile),

      // Atur background Scaffold menjadi transparan dan biarkan body meluas di belakang AppBar
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // Menghilangkan tombol kembali bawaan
        automaticallyImplyLeading: false,

        // 1. Tombol Menu Kustom (Hamburger) di posisi Leading
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.amber,
            ), // Ikon 3 strip (warna emas)
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Membuka Drawer
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

        // 2. Icon User/Admin di Actions (Kanan)
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Logika untuk halaman Profil/Admin (Saat ini hanya notifikasi)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fungsi Profil/Admin akan ditambahkan.',
                    style: TextStyle(fontFamily: 'Nusantara'),
                  ),
                ),
              );
            },
            tooltip: 'Profil Pengguna/Admin',
          ),
          const SizedBox(width: 10),
        ],

        // AppBar semi-transparan agar gambar background tetap terlihat
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0, // Hilangkan bayangan/shadow
      ),

      body: Stack(
        children: [
          // === 1. Background Image (tari-bali.jpg) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Gambar Tari Bali sebagai background
              fit: BoxFit.cover,
              // Fallback jika gambar tidak ditemukan
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

          // === 2. Dark Overlay for Contrast ===
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.7,
              ), // Overlay gelap untuk meningkatkan kontras teks
            ),
          ),

          // === 3. Main Content (SingleChildScrollView) ===
          SingleChildScrollView(
            // Padding atas untuk menggeser konten di bawah AppBar transparan
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === HERO IMAGE (Monas/Jakarta) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jakarta1.jpg', // Gambar Jakarta Hero
                          width: double.infinity,
                          height: isMobile ? 220 : 350, // Tinggi responsif
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                            // Gradient untuk membuat teks di bawah gambar hero terlihat jelas
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

                    // === Konten Teks di bawah gambar ===
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Bagian 1: Pengantar Jakarta & Tiga Tahap Perkembangan ===
                          _buildContentSection(
                            title: "Sejarah Singkat dan Pengklaiman Wilayah",
                            content: part1Awal,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 2: Perkembangan Nama dan Tahap Kota ===
                          _buildContentSection(
                            title: "Perkembangan Nama dan Tiga Tahap Kota",
                            content: part2Perkembangan,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 3: Kerajaan-kerajaan Awal (Abad ke-4 M) ===
                          _buildContentSection(
                            title: "Kerajaan-kerajaan Awal (Abad ke-4 SM)",
                            content: part3KerajaanAwal,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 4: Tarumanagara (397 M) ===
                          _buildContentSection(
                            title: "Era Tarumanagara (397 M)",
                            content: part4Tarumanagara,
                            isMobile: isMobile,
                          ),

                          // === Bagian BARU: Kerajaan Sunda (669–1527) ===
                          const Divider(color: Colors.white24, height: 40),

                          _buildContentSection(
                            title: "Kerajaan Sunda (669–1527)",
                            content: part5KerajaanSunda,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Kolom Komentar (Baru) ===
                          _buildCommentSection(isMobile: isMobile),

                          // Tambahkan sedikit ruang di bagian bawah
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
