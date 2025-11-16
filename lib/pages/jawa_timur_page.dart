import 'package:flutter/material.dart';

// Model untuk data komentar
class Comment {
  final String user;
  final String date;
  final String content;
  Comment(this.user, this.date, this.content);
}

// Data komentar dihilangkan (sesuai permintaan)
final List<Comment> mockComments = [];

// --- FUNGSI MAIN UNTUK MENJALANKAN APLIKASI ---
void main() {
  // Catatan: Jika Anda masih melihat tanda merah pada fontFamily 'Nusantara' atau path 'assets/images', 
  // pastikan Anda telah mendeklarasikan font dan folder assets di file pubspec.yaml.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sejarah Jawa Timur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema gelap untuk tampilan yang dramatis
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber, // Warna utama
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black, // Background global
      ),
      home: const JawaTimurPage(),
    );
  }
}
// --------------------------------------------------------------------------

class JawaTimurPage extends StatelessWidget {
  const JawaTimurPage({super.key});

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
    
    // Sesuaikan padding atas jika title kosong (untuk continuation text)
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

  // Widget baru untuk menampilkan Kolom Komentar
  Widget _buildCommentSection({required bool isMobile}) {
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
                    const Divider(color: Colors.white12, height: 10, thickness: 0.5),
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

        // Comment Input Form (Mock: Tidak ada fungsi nyata)
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
            ]
          ),
          child: Column(
            children: [
              TextField(
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
                  onPressed: () {
                    // Logika KIRIM (Mock: Tidak ada fungsi nyata)
                  },
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

        // Daftar Komentar
        commentList,
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;

    final double horizontalPadding = isMobile ? 20 : 60;
    final double maxWebWidth = 1200;

    // Menghitung padding atas (status bar + AppBar height)
    final double topSafeAreaPadding = MediaQuery.of(context).padding.top;
    const double kAppBarHeight = 56.0; // Tinggi standar AppBar
    final double topPadding = topSafeAreaPadding + kAppBarHeight;

    // --- Konten Sejarah Era Perjuangan Kemerdekaan (Dibagi menjadi 2 bagian) ---
    final String part1Perjuangan = 
        "Pada era penjajahan Jepang, perlawanan rakyat tetap terjadi. Di Blitar terjadi pemberontakan PETA (Pembela Tanah Air) pada awal tahun 1945. Pemberontakan ini dipimpin oleh Supriyadi, Moeradi, Halir Mangkudijoyo, dan Soemarto. Meskipun pada akhirnya pemberontakan ini dapat dipadamkan. Namun jiwa pemberontakan tersebut mampu mengobarkan semangat kemerdekaan pada seluruh rakyat Jawa Timur.\n\n"
        "Dua pekan setelah proklamasi kemerdekaan, Surabaya telah memiliki pemerintahan sendiri dan berbentuk residen. Residennya yang pertama adalah R. Soedirman. Terbentuknya pemerintahan di Surabaya ini menimbulkan sengketa dengan Jepang, bahkan terjadi berbagai pertempuran. Penyebabnya adalah Jepang yang saat itu telah menyerah kepada sekutu, diwajibkan untuk tetap berkuasa sampai saatnya kekuasaan tersebut diserahkan kepada sekutu.\n\n"
        "Kedatangan pasukan sekutu dengan diboncengi Belanda (NICA) ke Surabaya, menambah panas suasana. Puncaknya terjadi pada tanggal **10 November 1945** di mana terjadi perang besar antara arek-arek Suroboyo melawan Sekutu. Tanggal 10 November kemudian ditetapkan sebagai Hari Pahlawan.\n\n"
        "Pertempuran tersebut memaksa gubernur Suryo, atas saran Tentara Keamanan Rakyat (TKR), memindahkan kedudukan pemerintahan daerah ke Mojokerto. Seminggu kemudian, pemerintahan pindah lagi ke tempat yang lebih aman, yaitu, di Kediri. Namun kondisi keamanan Kediri kian hari kian buruk sampai akhirnya, pada bulan Februari 1947, pemerintahan provinsi Jawa Timur dipindah lagi ke Malang. Pada waktu pemerintahan berada di Malang ini, terjadi pergantian Gubernur, Suryo digantikan oleh R.P. Suroso yang kemudian digantikan lagi oleh Dr. Moerdjani. Pada tanggal 21 Juli 1947, meskipun masih terikat dengan perjanjian Linggarjati dan perjanjian gencatan senjata yang berlaku sejak tanggal 14 Oktober 1946, Belanda melakukan Aksi Militer I. Aksi militer Belanda ini menyebabkan kondisi keamanan di Malang memburuk. Akhirnya Pemerintahan Provinsi Jawa Timur pindah lagi ke Blitar.";

    final String part2Perjuangan =
        "Aksi militer ini berakhir setelah dilakukan **perjanjian Renville**. Namun perjanjian ini berakibat negatif bagi Jawa Timur, yakni, berkurangnya wilayah kekuasaan pemerintah provinsi Jawa Timur. Belanda kemudian menjadikan daerah yang dikuasainya sebagai negara baru, misalnya negara Madura dan negara Jawa Timur.\n\n"
        "Ditengah kesulitan yang dihadapi pemerintah RI ini, terjadi **pemberontakan PKI di Madiun** tanggal 18 September 1948. Namun akhirnya pemberontakan ini dapat ditumpas oleh Tentara Republik Indonesia. Tanggal 19 Desember 1948, Belanda melancarkan **Aksi Militer II**. Blitar, yang waktu itu masih dipergunakan sebagai tempat pemerintahan provinsi Jawa Timur diserang. Gubernur Dr. Moerdjani dan stafnya terpaksa menyingkir dan bergerilya di lereng Gunung Willis. Aksi militer II berakhir setelah tercapai persetujuan Roem-Royen tanggal 7 Mei 1949.\n\n"
        "Belanda menarik pasukannya dari Jawa Timur setelah diadakan **Konferensi Meja Bundar (KMB)** yang menghasilkan piagam pengakuan kedaulatan negara Republik Indonesia Serikat (RIS). Jawa Timur berubah status dari provinsi menjadi negara bagian. Namun rakyat Jawa Timur ternyata tidak mendukung perubahan status tersebut. Rakyat menuntut dibubarkannya negara Jawa Timur. Akhirnya pada tanggal 25 Februari 1950, negara Jawa Timur dibubarkan dan menjadi bagian wilayah Republik Indonesia. Keputusan untuk bergabung kembali dengan RI ini diikuti oleh negara Madura.";
    // --------------------------------------------------------------------------

    return Scaffold(
      // Atur background Scaffold menjadi transparan dan biarkan body meluas di belakang AppBar
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text('Sejarah Jawa Timur', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        // AppBar semi-transparan agar gambar background tetap terlihat
        backgroundColor: Colors.black.withOpacity(0.6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0, // Hilangkan bayangan/shadow
      ),

      body: Stack(
        children: [
          // === 1. Background Image (Ganti dengan gambar khas Jawa Timur) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Placeholder: Ganti dengan gambar khas Jawa Timur (misal: Bromo)
              fit: BoxFit.cover,
              // Fallback jika gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black,
                child: const Center(child: Text("Background Image Not Found", style: TextStyle(color: Colors.red))),
              ),
            ),
          ),

          // === 2. Dark Overlay for Contrast ===
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Overlay gelap untuk meningkatkan kontras teks
            ),
          ),

          // === 3. Main Content (SingleChildScrollView) ===
          SingleChildScrollView(
            // Padding atas untuk menggeser konten di bawah AppBar transparan
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === HERO IMAGE (Jawa Timur) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jatim.jpg', // Placeholder: Gambar Hero Jawa Timur (misal: Bromo)
                          width: double.infinity,
                          height: isMobile ? 220 : 350, // Tinggi responsif
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
                          padding: EdgeInsets.only(left: horizontalPadding, bottom: 20),
                          child: const Text(
                            'J A W A   T I M U R',
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
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Mengatasi potensi alignment issue
                        children: [
                          // === Bagian 1: Sejarah Pembentukan Provinsi & Kerajaan Awal (Dinoyo - Kediri) ===
                          _buildContentSection(
                            title: "Sejarah Pembentukan Provinsi & Kerajaan Awal",
                            content:
                                "Jawa Timur merupakan salah satu dari delapan provinsi paling awal di Indonesia. Provinsi lainnya adalah Sumatra, Borneo, Jawa Barat, Jawa Tengah, Sulawesi, Maluku, dan Sunda Kecil. Gubernur pertama provinsi Jawa Timur adalah R.M.T.A. Surjo.\n\n"
                                "Kehidupan manusia sebagai masyarakat baru muncul sekitar abad ke-8, yaitu, dengan ditemukannya PRASASTI DINOYO di daerah Malang. Prasasti yang bertahun 760 M ini menceritakan peristiwa politik dan kebudayaan di Kerajaan Dinoyo. Nama Malang sendiri diperkirakan berasal dari nama sebuah bangunan suci yang disebut MALANGKUSESWARA. Kerajaan Dinoyo berdiri sekitar abad ke-8 hingga awal abad ke-11 Masehi. Setelah itu, KERAJAAN KEDIRI pun muncul, sekitar abad ke-11 hingga abad ke-13 Masehi. Dinoyo merupakan salah satu kerajaan yang lebih awal di Jawa Timur sebelum digantikan oleh Kediri dan kemudian Singasari.",
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 2: Era Kerajaan Singasari dan Dinasti Ken Arok ===
                          _buildContentSection(
                            title: "Era Kerajaan Singasari dan Dinasti Ken Arok",
                            content:
                                "Pada tahun 1222, KEN AROK mendirikan KERAJAAN SINGASARI. Ia berkuasa di kerajaan itu sampai tahun 1292. Sebelum berkuasa, Ken Arok merebut kekuasaan di Tumapel, Kediri, dari Tungul Ametung. Keturunan Dinasti Ken Arok ini kemudian menjadi raja-raja Singasari dan Majapahit pada abad ke-13 sampai abad ke-15.\n\n"
                                "Perebutan kekuasaan internal segera terjadi. Pada tahun 1227, ANUSAPATI membunuh Ken Arok dan menjadi raja. Kekuasaan Anusapati hanya berlangsung 20 tahun. Ia dibunuh TOHJAYA. Tiga tahun kemudian, Tohjaya terbunuh dalam pemberontakan yang dipimpin oleh JAYA WISNUWARDHANA, putra Anusapati. Tahun 1268, takhtanya digantikan oleh KERTANEGARA (1268-1292). Pada tahun 1292, Kertanegara dikalahkan oleh pemberontak bernama JAYAKATWANG, mengakhiri riwayat Kerajaan Singasari.",
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 3: Era Kerajaan Majapahit ===
                          _buildContentSection(
                            title: "Era Kerajaan Majapahit",
                            content:
                                "Pada tahun 1294, Kerajaan Majapahit berdiri. Pendirinya adalah RADEN WIJAYA. Majapahit mencapai puncak kejayaannya pada masa pemerintahan HAYAM WURUK. Dia didampingi oleh mahapatih GAJAH MADA. Bersama patihnya ini Hayam Wuruk berhasil menyatukan wilayah yang luas di bawah nama Dwipantara.\n\n"
                                "Pada tahun 1357, Terjadi Peristiwa Bubat, yaitu perang antara Raja Sunda dan Patih Majapahit Gajah Mada. Peristiwa ini bermula dari keinginan raja Hayam Wuruk untuk mengambil putri Sunda yang bernama Dyah Pitaloka sebagai permaisurinya. Namun karena terjadi salah paham mengenai prosedur perkawinan, rencana tersebut berujung pada suatu pertempuran di Bubat. Pasukan Majapahit, di bawah pimpinan Patih Gajah Mada berhasil menaklukan Pajajaran dalam perang Bubat tersebut. Pada tahun 1389, Hayam Wuruk meninggal dunia. Posisinya digantikan oleh Wikramawardhana. Era ini merupakan awal dari runtuhnya Majapahit. Salah satunya diakibatkan adanya kekecewaan anak Hayam Wuruk yang lain, yaitu Wirabumi.",
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 4: Era Perjuangan Kemerdekaan (Bagian 1) ===
                          _buildContentSection(
                            title: "Era Perjuangan Kemerdekaan",
                            content: part1Perjuangan,
                            isMobile: isMobile,
                          ),
                          // Catatan: _buildContentSection sudah menambahkan SizedBox(height: 30) di akhir

                          // === Tambahan: Tampilan Gambar Jatimg2.jpg & Caption (SUDAH DIUBAH) ===
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
                                    height: isMobile ? 180 : 300, // Tinggi responsif
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: isMobile ? 180 : 300,
                                      color: Colors.grey.shade900,
                                      child: const Center(child: Text("Image: Perjuangan Kemerdekaan (Placeholder)", style: TextStyle(color: Colors.grey))),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10), // Jarak antara gambar dan deskripsi
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

                          // === Tambahan: Era Perjuangan Kemerdekaan (Bagian 2 - Lanjutan) ===
                          // Menggunakan title kosong agar tidak menampilkan judul lagi, tetapi mempertahankan style konten
                          _buildContentSection(
                            title: "", 
                            content: part2Perjuangan,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Kolom Komentar ===
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