library flutter_app;

import 'package:flutter/material.dart';
// Asumsi Anda memiliki IntroPage di path yang sama atau relatif
import 'intro_page.dart'; // <-- Pastikan path ini benar!

// Import halaman-halaman tujuan yang baru:
// PASTIKAN FILE-FILE INI ADA DI FOLDER YANG SAMA!
import 'jawa_timur_page.dart';
import 'jawa_tengah_page.dart';
import 'jawa_barat_page.dart';
import 'bali_page.dart';
import 'merchandise_page.dart'; // <--- Halaman Merchandise
import 'profil_page.dart'; // <--- BARU: Halaman Profil

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

class JakartaPage extends StatefulWidget {
  const JakartaPage({super.key});

  @override
  State<JakartaPage> createState() => _JakartaPageState();
}

class _JakartaPageState extends State<JakartaPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Map untuk menentukan rute halaman target
  static const Map<String, Widget> pageRoutes = {
    'Jakarta': JakartaPage(),
    'Jawa Timur': JawaTimurPage(),
    'Jawa Tengah': JawaTengahPage(),
    'Jawa Barat': JawaBaratPage(),
    'Bali': BaliPage(),
    'Merchandise': MerchandisePage(), // Tetap definisikan, digunakan untuk navigasi
    // 'Profil' tidak ditambahkan ke rute utama karena tidak ada di Drawer
  };

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // --- Widget Pembantu ---

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

  Widget _buildCommentSection({required bool isMobile}) {
    void submitComment() {
      final name = _nameController.text.trim();
      final content = _commentController.text.trim();

      if (name.isNotEmpty && content.isNotEmpty) {
        setState(() {
          mockComments.add(Comment(name, "Baru saja", content));
        });
        _nameController.clear();
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Komentar berhasil ditambahkan (Mock).',
              style: TextStyle(fontFamily: 'Nusantara'),
            ),
          ),
        );
      } else {
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

    // List Komentar
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
                controller: _nameController,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nusantara',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _commentController,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                  onPressed: submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
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
        commentList,
      ],
    );
  }

  // Widget Drawer & Menu
  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = Colors.amber;
    final double headerHeight = isMobile ? 180 : 220;

    // Fungsi navigasi drawer
    void navigateTo(String destination) {
      Navigator.pop(context); // Tutup drawer

      if (destination == 'Home') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()),
        );
      }
      // Navigasi ke halaman tujuan. Menggunakan pushReplacement untuk menu daerah
      // agar tidak menumpuk terlalu banyak halaman di stack.
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

    // Menu sejarah daerah
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

          // Menu Merchandise sudah dihapus dari Drawer, sesuai permintaan sebelumnya.
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
          // Tombol Merchandise (Tetap)
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            onPressed: () {
              // Menggunakan 'push' agar tombol back kembali ke halaman ini (JakartaPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MerchandisePage()),
              );
            },
            tooltip: 'Merchandise',
          ),
          
          // Tombol Profil (BARU - berfungsi)
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Menggunakan 'push' untuk menavigasi ke halaman Profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
            tooltip: 'Profil Pengguna',
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
                    // === HERO IMAGE ===
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

                          // --- Tombol Merchandise Panggilan Cepat ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Menggunakan 'push' agar tombol back kembali ke halaman ini (JakartaPage)
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

                          _buildCommentSection(isMobile: isMobile),

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