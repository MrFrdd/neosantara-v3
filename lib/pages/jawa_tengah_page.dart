import 'package:flutter/material.dart';

// Model untuk data komentar (Direplikasi dari file Jatim)
class Comment {
  final String user;
  final String date;
  final String content;
  Comment(this.user, this.date, this.content);
}

// Data komentar dihilangkan (sesuai permintaan, tetapi mockComment tetap kosong)
final List<Comment> mockComments = [];

// --- FUNGSI MAIN UNTUK MENJALANKAN APLIKASI ---
void main() {
  // Catatan: Pastikan font 'Nusantara' dan folder assets telah dideklarasikan.
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
// --------------------------------------------------------------------------

class JawaTengahPage extends StatelessWidget {
  const JawaTengahPage({super.key});

  // Widget untuk menampilkan bagian teks konten (Direplikasi)
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

  // Widget untuk menampilkan Kolom Komentar (Direplikasi)
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

        // Comment Input Form (Mock)
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

    final double topSafeAreaPadding = MediaQuery.of(context).padding.top;
    const double kAppBarHeight = 56.0;
    final double topPadding = topSafeAreaPadding + kAppBarHeight;

    // --- Konten Geografi dan Administrasi (BARU) ---
    final String geografiLokasi =
        "Jawa Tengah sebagai salah satu Propinsi di Jawa, letaknya diapit oleh dua Propinsi besar, yaitu Jawa Barat dan Jawa Timur. Letaknya 5º40′ dan 8º30′ Lintang Selatan dan antara 108º30′ dan 111º30′ Bujur Timur (termasuk Pulau Karimunjawa). Jarak terjauh dari Barat ke Timur adalah **263 Km** dan dari Utara ke Selatan **226 Km** (tidak termasuk pulau Karimunjawa).";

    final String administrasiLuas =
        "Secara administratif Propinsi Jawa Tengah terbagi menjadi **29 Kabupaten dan 6 Kota**. Luas Wilayah Jawa Tengah sebesar **3,25 juta hektar** atau sekitar **25,04 persen** dari luas pulau Jawa (1,70 persen luas Indonesia). Luas yang ada terdiri dari **1,00 juta hektar** (30,80 persen) **lahan sawah** dan **2,25 juta hektar** (69,20 persen) **bukan lahan sawah**.";

    final String penggunaanLahan =
        "Menurut penggunaannya, luas lahan sawah terbesar berpengairan teknis (**38,26 persen**), selainnya berpengairan setengah teknis, tadah hujan dan lain-lain. Dengan teknik irigasi yang baik, potensi lahan sawah yang dapat ditanami padi lebih dari dua kali sebesar **69,56 persen**.\n\n"
        "Berikutnya lahan kering yang dipakai untuk tegalan/kebun/ladang/huma sebesar **34,36 persen** dari total bukan lahan sawah. Persentase tersebut merupakan yang terbesar, dibandingkan presentase penggunaan bukan lahan sawah yang lain.";

    final String iklimSuhu =
        "Menurut Stasiun Klimatologi Klas 1 Semarang, suhu udara rata-rata di Jawa Tengah berkisar antara **18ºC sampai 28ºC**. Tempat-tempat yang letaknya dekat pantai mempunyai suhu udara rata-rata relatif tinggi. Sementara itu, suhu rata-rata tanah berumput (kedalaman 5 Cm), berkisar antara **17ºC sampai 35ºC**. Rata-rata suhu air berkisar antara **21ºC sampai 28ºC**. Sedangkan untuk kelembaban udara rata-rata bervariasi, dari **73 persen sampai 94 persen**. Curah hujan terbanyak terdapat di Stasiun Meteorologi Pertanian khusus batas Salatiga sebanyak **3.990 mm**, dengan hari hujan **195 hari**.";
        
    // --- Konten Sejarah Jawa Tengah (Dipertahankan) ---
    final String eraKuno = 
        "Sejak abad VII, banyak terdapat pemerintahan kerajaan yang berdiri di Jawa Tengah (Central Java), yaitu: Kerajaan Budha **Kalingga**, Jepara yang diperintah oleh Ratu Sima pada tahun 674.\n\n"
        "Menurut naskah/prasasti Canggah tahun 732, kerajaan Hindu lahir di **Medang Kamulan**, Jawa Tengah dengan nama Raja Sanjaya atau **Rakai Mataram**. Di bawah pemerintahan Rakai Pikatan dari Dinasti Sanjaya, ia membangun Candi Rorojonggrang atau Candi **Prambanan**. "
        "Kerajaan Mataram Budha yang juga lahir di Jawa Tengah selama era pemerintahan **Dinasti Syailendra**, mereka membangun candi-candi seperi Candi **Borobudur**, Candi Sewu, Candi Kalasan dll.";

    final String eraIslam =
        "Pada abad 16 setelah runtuhnya kerajaan Majapahit Hindu, kerajaan Islam muncul di **Demak**, sejak itulah Agama Islam disebarkan di Jawa Tengah. Setelah kerajaan Demak runtuh, **Djoko Tingkir** anak menantu Raja Demak (Sultan Trenggono) memindahkan kerajaan Demak ke **Pajang** (dekat Solo), dan bergelar **Sultan Adiwijaya**.\n\n"
        "Perang yang paling besar adalah antara Sultan Adiwijaya melawan **Aryo Penangsang**. Sultan Adiwijaya menugaskan **Danang Sutowijaya** untuk menumpas pemberontakan Aryo Penangsang. "
        "Setelah Pajang runtuh, Sutowijaya menjadi Raja Mataram Islam pertama di Jawa Tengah dan bergelar **Panembahan Senopati**.";

    final String eraKolonialPerjuangan =
        "Di pertengahan abad 16, bangsa Portugis dan Spanyol datang ke Indonesia dalam usaha mencari rempah-rempah. Pada saat yang sama, bangsa Inggris dan kemudian bangsa Belanda datang ke Indonesia juga. Dengan **VOC**-nya, bangsa Belanda menindas bangsa Indonesia termasuk rakyat Jawa Tengah baik di bidang politik maupun ekonomi.\n\n"
        "Di awal abad 18, Kerajaan Mataram diperintah oleh **Sri Sunan Pakubuwono II**. Perselisihan keluarga raja dan campur tangan Belanda diselesaikan dengan **Perjanjian Gianti tahun 1755**. "
        "Perjanjian ini membagi Kerajaan Mataram menjadi dua kerajaan yang lebih kecil: **Surakarta Hadiningrat** (Kraton Kasunanan) dan **Ngayogyakarta Hadiningrat** (Kraton Kasultanan).\n\n"
        "Sampai sekarang, daerah Jawa Tengah secara administratif merupakan sebuah propinsi yang ditetapkan dengan Undang-undang No. **10/1950** tanggal 4 Juli 1950.";
    // --------------------------------------------------------------------------

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text('Sejarah Jawa Tengah', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        // AppBar semi-transparan
        backgroundColor: Colors.black.withOpacity(0.6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body: Stack(
        children: [
          // === 1. Background Image (Ganti dengan gambar khas Jawa Tengah) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Placeholder: Ganti dengan gambar khas Jawa Tengah (misal: Merbabu)
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
                constraints: BoxConstraints(maxWidth: maxWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === HERO IMAGE (Jawa Tengah) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/jateng.jpg', // Placeholder: Gambar Hero Jawa Tengah
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
                        'Kantor gubernur di Semarang pada masa kolonial',
                        style: TextStyle(
                          fontFamily: 'Nusantara',
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center, // Pusatkan teks untuk estetika
                      ),
                    ),
                    // === Konten Teks di bawah gambar ===
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Bagian BARU 1: Geografi dan Lokasi ===
                          _buildContentSection(
                            title: "Geografi dan Batas Wilayah",
                            content: geografiLokasi,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian BARU 2: Administrasi dan Luas Wilayah ===
                          _buildContentSection(
                            title: "Administrasi dan Data Luas",
                            content: administrasiLuas,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),
                          
                          // === Bagian BARU 3: Penggunaan Lahan ===
                          _buildContentSection(
                            title: "Potensi Penggunaan Lahan",
                            content: penggunaanLahan,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian BARU 4: Iklim dan Suhu ===
                          _buildContentSection(
                            title: "Kondisi Iklim dan Curah Hujan",
                            content: iklimSuhu,
                            isMobile: isMobile,
                          ),
                          
                          const Divider(color: Colors.white24, height: 40),


                          // === Bagian Sejarah 1: Era Kuno (Mataram Kuno & Borobudur) ===
                          _buildContentSection(
                            title: "Era Kuno: Kerajaan dan Warisan Candi",
                            content: eraKuno,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian Sejarah 2: Era Kesultanan Mataram Islam ===
                          _buildContentSection(
                            title: "Era Kesultanan Mataram Islam",
                            content: eraIslam,
                            isMobile: isMobile,
                          ),

                          // NOTE: Blok gambar Perang Diponegoro telah dihapus di sini sesuai permintaan.

                          // === Bagian Sejarah 3: Era Kolonial dan Perjuangan ===
                          _buildContentSection(
                            title: "Era Kolonial, Perpecahan, dan Administrasi Modern", 
                            content: eraKolonialPerjuangan,
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