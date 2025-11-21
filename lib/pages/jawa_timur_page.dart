import 'package:flutter/material.dart';
// Asumsi Anda memiliki IntroPage di path yang sama atau relatif
import 'intro_page.dart';

// Import halaman-halaman tujuan yang lain:
// PASTIKAN FILE-FILE INI ADA DI FOLDER YANG SAMA!
import 'jakarta_page.dart';
import 'jawa_tengah_page.dart';
import 'jawa_barat_page.dart';
import 'bali_page.dart';
import 'merchandise_page.dart';
import 'profil_page.dart';

// --- Model dan Data Tiruan ---

// Model untuk data komentar tiruan
class Comment {
  final String user;
  final String date;
  final String content;
  Comment(this.user, this.date, this.content);
}

// Data komentar tiruan untuk halaman Jawa Timur
final List<Comment> mockCommentsJawaTimur = [];

// --- Halaman JawaTimurPage (StatefulWidget) ---

class JawaTimurPage extends StatefulWidget {
  const JawaTimurPage({super.key});

  @override
  State<JawaTimurPage> createState() => _JawaTimurPageState();
}

class _JawaTimurPageState extends State<JawaTimurPage> {
  // Controller untuk mengelola input komentar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Map untuk menentukan rute halaman target
  // Dihapus: 'Merchandise' dari list ini karena hanya diakses melalui AppBar.actions
  final Map<String, Widget> pageRoutes = {
    'Jakarta': const JakartaPage(),
    'Jawa Tengah': const JawaTengahPage(),
    'Jawa Barat': const JawaBaratPage(),
    'Bali': const BaliPage(),
    'Profil': const ProfilPage(), 
  };

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // --- Widget Pembantu ---

  // Widget untuk menampilkan bagian teks konten (Diperbarui untuk mendukung title kosong)
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
      fontSize: isMobile ? 16 : 18,
      color: Colors.white70, // Warna putih pudar untuk konten
      height: 1.6,
      letterSpacing: 0.5,
    );

    // Sesuaikan jarak antar bagian berdasarkan apakah ada judul atau tidak
    final double topSpacing = title.isEmpty ? 0 : 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: titleStyle),
        SizedBox(height: title.isNotEmpty ? topSpacing : 0),
        Text(content, textAlign: TextAlign.justify, style: contentStyle),
        // Menambahkan sedikit ruang ekstra antar bagian
        const SizedBox(height: 30),
      ],
    );
  }

  // Widget untuk menampilkan Kolom Komentar
  Widget _buildCommentSection({required bool isMobile}) {
    // Logika Mock KIRIM Komentar (Menggunakan mockCommentsJawaTimur)
    void _submitComment() {
      final name = _nameController.text.trim();
      final content = _commentController.text.trim();

      if (name.isNotEmpty && content.isNotEmpty) {
        // Tambahkan komentar ke list global Jawa Timur
        setState(() {
          mockCommentsJawaTimur.add(Comment(name, "Baru saja", content));
        });
        _nameController.clear();
        _commentController.clear();
        // Tampilkan Snackbar konfirmasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Komentar berhasil ditambahkan (Mock).',
                  style: TextStyle(fontFamily: 'Nusantara'))),
        );
      } else {
        // Tampilkan Snackbar jika input kosong
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nama dan komentar tidak boleh kosong.',
                  style: TextStyle(fontFamily: 'Nusantara'))),
        );
      }
    }

    // List Komentar yang akan di-build
    final commentList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mockCommentsJawaTimur.isEmpty
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
              )
            ]
          : mockCommentsJawaTimur.reversed.map((comment) {
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
                        color: Colors.white12, height: 10, thickness: 0.5),
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
              ]),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nama Anda",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontFamily: 'Nusantara'),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                style: const TextStyle(color: Colors.white, fontFamily: 'Nusantara'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tulis komentar Anda di sini...",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontFamily: 'Nusantara'),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                style: const TextStyle(color: Colors.white, fontFamily: 'Nusantara'),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComment,
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

        // Daftar Komentar Tiruan
        commentList,
      ],
    );
  }

  // Widget untuk membuat menu drawer (menu strip 3)
  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = Colors.amber;
    final double headerHeight = isMobile ? 180 : 220;

    // Fungsi navigasi
    void navigateTo(String destination) {
      Navigator.pop(context); // Tutup drawer

      if (destination == 'Home') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()),
        );
      } else if (pageRoutes.containsKey(destination)) {
        Widget nextPage = pageRoutes[destination]!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      }
    }

    // Daftar menu Sejarah Daerah
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': false},
      {'name': 'Jawa Timur', 'isCurrent': true}, // Jawa Timur adalah halaman saat ini
      {'name': 'Jawa Tengah', 'isCurrent': false},
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
                  // Gambar Background Header (Menggunakan gambar Bromo sebagai placeholder)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jatim.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                            child: Text("Header Image Not Found",
                                style: TextStyle(color: Colors.red))),
                      ),
                    ),
                  ),
                  // Overlay Gradien
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
                          'Sejarah Jawa Timur',
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
            title: const Text('Home',
                style: TextStyle(
                    fontFamily: 'Nusantara', color: listTileColor, fontSize: 18)),
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
                onTap: () => navigateTo(name),
              );
            }).toList(),
          ),

          const Divider(color: Colors.white12),
          
          // === Menu Merchandise DITAMBAHKAN SEBELUMNYA, KINI DIHAPUS ===
          /* ListTile(
            leading: const Icon(Icons.shopping_bag, color: iconColor),
            title: const Text('Merchandise',
                style: TextStyle(
                    fontFamily: 'Nusantara', color: listTileColor, fontSize: 18)),
            // Menggunakan push, bukan pushReplacement, agar bisa kembali ke halaman ini.
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MerchandisePage()),
              );
            }, 
          ),
          
          const Divider(color: Colors.white12),
          */
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

    // Hitung padding atas untuk konten di bawah AppBar transparan
    final double topSafeAreaPadding = MediaQuery.of(context).padding.top;
    const double kAppBarHeight = 56.0;
    final double topPadding = topSafeAreaPadding + kAppBarHeight;

    // =========================================================================
    // Konten Teks Sejarah Jawa Timur (DARI INPUT PENGGUNA)
    // =========================================================================

    final String part1KerajaanAwal =
        "Jawa Timur merupakan salah satu dari delapan provinsi paling awal di Indonesia. Provinsi lainnya adalah Sumatra, Borneo, Jawa Barat, Jawa Tengah, Sulawesi, Maluku, dan Sunda Kecil. Gubernur pertama provinsi Jawa Timur adalah R.M.T.A. Surjo.\n\n"
        "Kehidupan manusia sebagai masyarakat baru muncul sekitar abad ke-8, yaitu, dengan ditemukannya PRASASTI DINOYO di daerah Malang. Prasasti yang bertahun 760 M ini menceritakan peristiwa politik dan kebudayaan di Kerajaan Dinoyo. Nama Malang sendiri diperkirakan berasal dari nama sebuah bangunan suci yang disebut MALANGKUSESWARA. Kerajaan Dinoyo berdiri sekitar abad ke-8 hingga awal abad ke-11 Masehi. Setelah itu, KERAJAAN KEDIRI pun muncul, sekitar abad ke-11 hingga abad ke-13 Masehi. Dinoyo merupakan salah satu kerajaan yang lebih awal di Jawa Timur sebelum digantikan oleh Kediri dan kemudian Singasari.";

    final String part2Singasari =
        "Pada tahun 1222, KEN AROK mendirikan KERAJAAN SINGASARI. Ia berkuasa di kerajaan itu sampai tahun 1292. Sebelum berkuasa, Ken Arok merebut kekuasaan di Tumapel, Kediri, dari Tungul Ametung. Keturunan Dinasti Ken Arok ini kemudian menjadi raja-raja Singasari dan Majapahit pada abad ke-13 sampai abad ke-15.\n\n"
        "Perebutan kekuasaan internal segera terjadi. Pada tahun 1227, ANUSAPATI membunuh Ken Arok dan menjadi raja. Kekuasaan Anusapati hanya berlangsung 20 tahun. Ia dibunuh TOHJAYA. Tiga tahun kemudian, Tohjaya terbunuh dalam pemberontakan yang dipimpin oleh JAYA WISNUWARDHANA, putra Anusapati. Tahun 1268, takhtanya digantikan oleh KERTANEGARA (1268-1292). Pada tahun 1292, Kertanegara dikalahkan oleh pemberontak bernama JAYAKATWANG, mengakhiri riwayat Kerajaan Singasari.";

    final String part3Majapahit =
        "Pada tahun 1294, Kerajaan Majapahit berdiri. Pendirinya adalah RADEN WIJAYA. Majapahit mencapai puncak kejayaannya pada masa pemerintahan HAYAM WURUK. Dia didampingi oleh mahapatih GAJAH MADA. Bersama patihnya ini Hayam Wuruk berhasil menyatukan wilayah yang luas di bawah nama Dwipantara.\n\n"
        "Pada tahun 1357, Terjadi Peristiwa Bubat, yaitu perang antara Raja Sunda dan Patih Majapahit Gajah Mada. Peristiwa ini bermula dari keinginan raja Hayam Wuruk untuk mengambil putri Sunda yang bernama Dyah Pitaloka sebagai permaisurinya. Namun karena terjadi salah paham mengenai prosedur perkawinan, rencana tersebut berujung pada suatu pertempuran di Bubat. Pasukan Majapahit, di bawah pimpinan Patih Gajah Mada berhasil menaklukan Pajajaran dalam perang Bubat tersebut. Pada tahun 1389, Hayam Wuruk meninggal dunia. Posisinya digantikan oleh Wikramawardhana. Era ini merupakan awal dari runtuhnya Majapahit. Salah satunya diakibatkan adanya kekecewaan anak Hayam Wuruk yang lain, yaitu Wirabumi.";

    final String part4Perjuangan =
        "Pada era penjajahan Jepang, perlawanan rakyat tetap terjadi. Di Blitar terjadi pemberontakan PETA (Pembela Tanah Air) pada awal tahun 1945. Pemberontakan ini dipimpin oleh Supriyadi, Moeradi, Halir Mangkudijoyo, dan Soemarto. Meskipun pada akhirnya pemberontakan ini dapat dipadamkan. Namun jiwa pemberontakan tersebut mampu mengobarkan semangat kemerdekaan pada seluruh rakyat Jawa Timur.\n\n"
        "Dua pekan setelah proklamasi kemerdekaan, Surabaya telah memiliki pemerintahan sendiri dan berbentuk residen. Residennya yang pertama adalah R. Soedirman. Terbentuknya pemerintahan di Surabaya ini menimbulkan sengketa dengan Jepang, bahkan terjadi berbagai pertempuran. Penyebabnya adalah Jepang yang saat itu telah menyerah kepada sekutu, diwajibkan untuk tetap berkuasa sampai saatnya kekuasaan tersebut diserahkan kepada sekutu.\n\n"
        "Kedatangan pasukan sekutu dengan diboncengi Belanda (NICA) ke Surabaya, menambah panas suasana. Puncaknya terjadi pada tanggal **10 November 1945** di mana terjadi perang besar antara arek-arek Suroboyo melawan Sekutu. Tanggal 10 November kemudian ditetapkan sebagai Hari Pahlawan.\n\n"
        "Pertempuran tersebut memaksa gubernur Suryo, atas saran Tentara Keamanan Rakyat (TKR), memindahkan kedudukan pemerintahan daerah ke Mojokerto. Seminggu kemudian, pemerintahan pindah lagi ke tempat yang lebih aman, yaitu, di Kediri. Namun kondisi keamanan Kediri kian hari kian buruk sampai akhirnya, pada bulan Februari 1947, pemerintahan provinsi Jawa Timur dipindah lagi ke Malang. Pada waktu pemerintahan berada di Malang ini, terjadi pergantian Gubernur, Suryo digantikan oleh R.P. Suroso yang kemudian digantikan lagi oleh Dr. Moerdjani. Pada tanggal 21 Juli 1947, meskipun masih terikat dengan perjanjian Linggarjati dan perjanjian gencatan senjata yang berlaku sejak tanggal 14 Oktober 1946, Belanda melakukan Aksi Militer I. Aksi militer Belanda ini menyebabkan kondisi keamanan di Malang memburuk. Akhirnya Pemerintahan Provinsi Jawa Timur pindah lagi ke Blitar.";

    final String part5PerjuanganLanjutan =
        "Aksi militer ini berakhir setelah dilakukan **perjanjian Renville**. Namun perjanjian ini berakibat negatif bagi Jawa Timur, yakni, berkurangnya wilayah kekuasaan pemerintah provinsi Jawa Timur. Belanda kemudian menjadikan daerah yang dikuasainya sebagai negara baru, misalnya negara Madura dan negara Jawa Timur.\n\n"
        "Ditengah kesulitan yang dihadapi pemerintah RI ini, terjadi **pemberontakan PKI di Madiun** tanggal 18 September 1948. Namun akhirnya pemberontakan ini dapat ditumpas oleh Tentara Republik Indonesia. Tanggal 19 Desember 1948, Belanda melancarkan **Aksi Militer II**. Blitar, yang waktu itu masih dipergunakan sebagai tempat pemerintahan provinsi Jawa Timur diserang. Gubernur Dr. Moerdjani dan stafnya terpaksa menyingkir dan bergerilya di lereng Gunung Willis. Aksi militer II berakhir setelah tercapai persetujuan Roem-Royen tanggal 7 Mei 1949.\n\n"
        "Belanda menarik pasukannya dari Jawa Timur setelah diadakan **Konferensi Meja Bundar (KMB)** yang menghasilkan piagam pengakuan kedaulatan negara Republik Indonesia Serikat (RIS). Jawa Timur berubah status dari provinsi menjadi negara bagian. Namun rakyat Jawa Timur ternyata tidak mendukung perubahan status tersebut. Rakyat menuntut dibubarkannya negara Jawa Timur. Akhirnya pada tanggal 25 Februari 1950, negara Jawa Timur dibubarkan dan menjadi bagian wilayah Republik Indonesia. Keputusan untuk bergabung kembali dengan RI ini diikuti oleh negara Madura.";

    // =========================================================================

    return Scaffold(
      // === DRAWER (MENU STRIP 3) ===
      drawer: _buildAppDrawer(context, isMobile),

      // Setelan untuk AppBar transparan
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        automaticallyImplyLeading: false,

        // 1. Tombol Menu Kustom (Hamburger)
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.amber),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),

        title: const Text('Sejarah Jawa Timur',
            style: TextStyle(
                fontFamily: 'Nusantara',
                color: Colors.white,
                fontWeight: FontWeight.bold)),

        // 2. Actions (Tombol Merchandise dan Profil)
        actions: [
          // Tombol Merchandise
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            onPressed: () {
              // Menggunakan 'push' agar tombol back kembali ke halaman ini
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MerchandisePage()),
              );
            },
            tooltip: 'Merchandise',
          ),

          // Tombol Profil
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

        // AppBar semi-transparan
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
      ),

      body: Stack(
        children: [
          // === 1. Background Image ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Gambar umum Jawa Timur
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Center(
                    child: Text("Background Image Not Found",
                        style: TextStyle(color: Colors.red))),
              ),
            ),
          ),

          // === 2. Dark Overlay ===
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // === 3. Main Content ===
          SingleChildScrollView(
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === HERO IMAGE (Jawa Timur) - Menggunakan 'jatim.jpg' dari input Anda ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jatim.jpg', // Gambar Hero Jawa Timur
                          width: double.infinity,
                          height: isMobile ? 220 : 350,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: isMobile ? 220 : 350,
                            color: Colors.grey.shade800,
                            child: const Center(
                                child: Text("Hero Image Not Found",
                                    style: TextStyle(color: Colors.red))),
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
                              left: horizontalPadding, bottom: 20),
                          child: const Text(
                            'J A W A   T I M U R',
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

                    // === Konten Teks Sejarah (DARI INPUT PENGGUNA) ===
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Bagian 1: Sejarah Pembentukan Provinsi & Kerajaan Awal (Dinoyo - Kediri) ===
                          _buildContentSection(
                            title: "Sejarah Pembentukan Provinsi & Kerajaan Awal",
                            content: part1KerajaanAwal,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 2: Era Kerajaan Singasari dan Dinasti Ken Arok ===
                          _buildContentSection(
                            title: "Era Kerajaan Singasari dan Dinasti Ken Arok",
                            content: part2Singasari,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 3: Era Kerajaan Majapahit ===
                          _buildContentSection(
                            title: "Era Kerajaan Majapahit",
                            content: part3Majapahit,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 4: Era Perjuangan Kemerdekaan (Bagian 1) ===
                          _buildContentSection(
                            title: "Era Perjuangan Kemerdekaan",
                            content: part4Perjuangan,
                            isMobile: isMobile,
                          ),
                          // Tidak perlu Divider di sini karena ada gambar di tengah

                          // === Tambahan: Tampilan Gambar Jatimg2.jpg & Caption ===
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/jatim2.jpg', // Gambar baru: Perjanjian Renville/KMB
                                    width: double.infinity,
                                    height: isMobile ? 180 : 300,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      height: isMobile ? 180 : 300,
                                      color: Colors.grey.shade900,
                                      child: const Center(
                                          child: Text(
                                              "Image: Perjuangan Kemerdekaan (Placeholder)",
                                              style: TextStyle(
                                                  color: Colors.grey))),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Protes rakyat menolak berdirinya Negara Jawa Timur, Agustus 1950',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: 'Nusantara',
                                    fontSize: isMobile ? 13 : 15,
                                    color: Colors.grey.shade400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10), // Tambahkan sedikit jarak setelah caption

                          // === Tambahan: Era Perjuangan Kemerdekaan (Bagian 2 - Lanjutan) ===
                          _buildContentSection(
                            title: "", // Judul kosong untuk lanjutan teks
                            content: part5PerjuanganLanjutan,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // --- Tombol Merchandise Panggilan Cepat ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Menggunakan 'push' agar tombol back kembali ke halaman ini
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


                          // === Kolom Komentar ===
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