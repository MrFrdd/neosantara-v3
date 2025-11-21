import 'package:flutter/material.dart';

// Asumsi: Pastikan file-file halaman tujuan ini sudah ada
import 'intro_page.dart'; 
import 'jakarta_page.dart';
import 'jawa_timur_page.dart'; 
import 'jawa_tengah_page.dart'; 
import 'bali_page.dart'; 

// Import halaman-halaman tujuan yang BARU DITAMBAHKAN:
import 'merchandise_page.dart'; // <--- DITAMBAHKAN
import 'profil_page.dart'; // <--- DITAMBAHKAN


// --- Model dan Data Tiruan ---

// Model untuk data komentar
class Comment {
  final String user;
  final String date;
  final String content;
  const Comment({
    required this.user,
    required this.date,
    required this.content,
  });
}

// Data komentar tiruan (list global)
final List<Comment> mockComments = [];

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
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const JawaBaratPage(),
    );
  }
}

// ============================================================================
//                   JAWA BARAT PAGE (StatefulWidget)
// ============================================================================
class JawaBaratPage extends StatefulWidget {
  const JawaBaratPage({super.key});

  static const Color accentColor = Colors.amber;

  @override
  State<JawaBaratPage> createState() => _JawaBaratPageState();
}

class _JawaBaratPageState extends State<JawaBaratPage> {
  // Controller untuk mengelola input komentar (Diperlukan karena Stateful)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Map untuk menentukan rute halaman target
  // Dihapus 'Jawa Barat' agar navigasi menggunakan pushReplacement tidak menavigasi ke halaman sendiri
  static const Map<String, Widget> pageRoutes = {
    'Jakarta': JakartaPage(),
    'Jawa Timur': JawaTimurPage(),
    'Jawa Tengah': JawaTengahPage(), 
    'Bali': BaliPage(),
    // 'Merchandise' dan 'Profil' tidak perlu di sini karena menggunakan push bukan pushReplacement
  };

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Logika Mock KIRIM Komentar
  void _submitComment() {
    final name = _nameController.text.trim();
    final content = _commentController.text.trim();

    if (name.isNotEmpty && content.isNotEmpty) {
      setState(() {
        // Tambahkan komentar ke list global
        mockComments.add(Comment(user: name, date: "Baru saja", content: content)); 
      });
      _nameController.clear();
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar berhasil ditambahkan (Mock).', style: TextStyle(fontFamily: 'Nusantara'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan komentar tidak boleh kosong.', style: TextStyle(fontFamily: 'Nusantara'))),
      );
    }
  }

  // --- Widget Bantuan ---

  Widget _buildContentSection({
    required String title,
    required String content,
    required bool isMobile,
    String? imageUrl,
  }) {
    // Menggunakan static accentColor dari parent widget
    const accentColor = JawaBaratPage.accentColor; 
    
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
    final double finalSpacing = (content.isEmpty && imageUrl != null) ? 20 : 30;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: titleStyle),
        SizedBox(height: title.isNotEmpty ? topSpacing : 0),
        if (content.isNotEmpty) Text(content, textAlign: TextAlign.justify, style: contentStyle),
        if (content.isNotEmpty) const SizedBox(height: 10),

        if (imageUrl != null) ...[
          const SizedBox(height: 20),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: isMobile ? 200 : 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: isMobile ? 200 : 300,
                  color: Colors.grey.shade800,
                  child: Center(
                      child: Text("Image Not Found: ${imageUrl.split('/').last}",
                          style: const TextStyle(color: Colors.red))),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        SizedBox(height: finalSpacing),
      ],
    );
  }

  Widget _buildCommentSection({required bool isMobile}) {
    const accentColor = JawaBaratPage.accentColor;

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
          : mockComments.reversed.map((comment) {
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
                    const Divider(color: Colors.white12, height: 10, thickness: 0.5),
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
            color: accentColor,
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
            border: Border.all(color: accentColor.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ]
          ),
          child: Column(
            children: [
              TextField(
                controller: _nameController, // Controller Nama ditambahkan
                decoration: InputDecoration(
                  hintText: "Nama Anda",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontFamily: 'Nusantara'),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                style: const TextStyle(color: Colors.white, fontFamily: 'Nusantara'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _commentController, // Controller Komentar ditambahkan
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tulis komentar Anda di sini...",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontFamily: 'Nusantara'),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                style: const TextStyle(color: Colors.white, fontFamily: 'Nusantara'),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComment, // Panggil fungsi submit
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
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

        // Daftar Komentar
        commentList,
      ],
    );
  }

  // === WIDGET DRAWER BARU (Merchandise sudah hilang dari sini) ===
  Widget _buildAppDrawer(BuildContext context, bool isMobile) {
    const listTileColor = Colors.white70;
    const iconColor = JawaBaratPage.accentColor;
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
        // Navigasi ke halaman regional lain
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

    // List regional history (Jawa Barat sebagai halaman saat ini)
    final List<Map<String, dynamic>> regionalHistory = [
      {'name': 'Jakarta', 'isCurrent': false},
      {'name': 'Jawa Timur', 'isCurrent': false},
      {'name': 'Jawa Tengah', 'isCurrent': false}, 
      {'name': 'Jawa Barat', 'isCurrent': true}, // Halaman saat ini
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
                      'assets/images/jabar.jpg', // Gambar Jabar
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
                            color: JawaBaratPage.accentColor,
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
            iconColor: JawaBaratPage.accentColor, 
            collapsedIconColor: Colors.white70,
            
            // Sub-menu (ListTile)
            children: regionalHistory.map((item) {
              final isCurrent = item['isCurrent'] as bool;
              final name = item['name'] as String;
              
              return ListTile(
                // Jika halaman saat ini, gunakan onTap: () {Navigator.pop(context);}
                // Jika halaman lain, gunakan navigasi
                onTap: isCurrent ? () => Navigator.pop(context) : () => navigateTo(name),
                
                contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0), 
                leading: Icon(
                  isCurrent ? Icons.location_city : Icons.location_city_outlined, 
                  color: isCurrent ? JawaBaratPage.accentColor : listTileColor,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: isCurrent ? JawaBaratPage.accentColor : listTileColor,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
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

    // Konten Teks (Dikutip dari kode asli)
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

    return Scaffold(
      // === DRAWER Dihubungkan ===
      drawer: _buildAppDrawer(context, isMobile),

      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        // PERBAIKAN: Menggunakan Builder untuk memastikan ikon menu dapat membuka Drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: JawaBaratPage.accentColor),
            onPressed: () {
              // Memanggil Scaffold.openDrawer() dari konteks yang melihat Scaffold
              Scaffold.of(context).openDrawer(); 
            },
            tooltip: 'Menu',
          ),
        ),

        title: const Text('Sejarah Jawa Barat', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        
        // Actions (Merchandise dan Profil) <--- DITAMBAHKAN/DIUBAH
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

          // Tombol Profil (Aksi Diperbarui)
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
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body: Stack(
        children: [
          // Background Image dan Overlay (tetap sama)
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Gambar latar belakang
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Center(child: Text("Background Image Not Found", style: TextStyle(color: Colors.red))),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jabar.jpg', // Gambar Hero
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
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContentSection(
                            title: "Sejarah Awal dan Era Kerajaan Sunda",
                            content: eraKunoKerajaan,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          _buildContentSection(
                            title: "Era Prasejarah dan Kebudayaan Buni",
                            content: eraPrasejarah,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          // --- MASA KOLONIAL (Paragraf 1) ---
                          _buildContentSection(
                            title: "Masa Kolonial: Provinsi Jawa Barat, Pasundan, dan VOC",
                            content: eraKolonialParagraf1,
                            isMobile: isMobile,
                          ),
                          
                          // --- GAMBAR (di tengah-tengah) ---
                          _buildContentSection(
                            title: "", 
                            content: "", 
                            isMobile: isMobile,
                            imageUrl: 'assets/images/jabar2.png',
                          ),

                          // --- MASA KOLONIAL (Paragraf 2) ---
                          _buildContentSection(
                            title: "", 
                            content: eraKolonialParagraf2,
                            isMobile: isMobile,
                            imageUrl: null, 
                          ),
                          
                          const Divider(color: Colors.white24, height: 40),
                          _buildContentSection(
                            title: "Masa Awal Kemerdekaan (1945-1950)",
                            content: eraKemerdekaanAwal,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          _buildContentSection(
                            title: "Administrasi Modern, Pemekaran Banten, dan Wacana Pasundan",
                            content: administrasiModern,
                            isMobile: isMobile,
                          ),
                          const Divider(color: Colors.white24, height: 40),
                          
                          // --- Tombol Merchandise Panggilan Cepat (DITAMBAHKAN) ---
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
                                backgroundColor: JawaBaratPage.accentColor,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // --- Akhir Tombol Merchandise Panggilan Cepat ---

                          // Kolom Komentar
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