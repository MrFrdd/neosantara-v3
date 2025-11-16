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
      title: 'Formasi Geologi Bali',
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
      home: const BaliPage(),
    );
  }
}
// --------------------------------------------------------------------------

class BaliPage extends StatelessWidget {
  const BaliPage({super.key});

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

  // Widget untuk menampilkan Kolom Komentar (Logika tetap sama)
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
              // Comment Item Widget (disingkat untuk fokus pada struktur)
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

    // --- Konten Formasi Geologi Bali ---
    final String part1Awal = 
        "Pulau Bali, seperti kebanyakan pulau di kepulauan Indonesia, adalah hasil dari **subduksi tektonik** lempeng Indo-Australia di bawah lempeng Eurasia. Dasar laut tersier, yang terbuat dari endapan laut purba termasuk akumulasi terumbu karang, terangkat di atas permukaan laut oleh subduksi. Lapisan batu kapur tersier yang terangkat dari dasar samudra masih terlihat di daerah-daerah seperti **Bukit semenanjung** dengan tebing batu kapur besar di Uluwatu, atau di barat laut pulau di Prapat Agung.";

    final String part2Majapahit =
        "Deformasi lokal lempeng Eurasia yang diciptakan oleh subduksi telah mendorong kerak kerak, yang menyebabkan munculnya **fenomena vulkanik**. Sederetan gunung berapi berjajar di bagian utara pulau itu, di poros Barat-Timur di mana bagian barat tertua, dan bagian timur terbaru. Gunung berapi tertinggi adalah gunung berapi strato-aktif **Gunung Agung**, pada 3.142 m (10.308 kaki).";
    
    final String part3Perlawanan =
        "Aktivitas vulkanik telah berlangsung intens selama berabad-abad, dan sebagian besar permukaan pulau (diluar Semenanjung Bukit dan Prapat Agung) telah ditutupi oleh magma vulkanik. Beberapa endapan lama tetap (lebih tua dari 1 juta tahun), sementara sebagian besar bagian tengah pulau ditutupi oleh endapan vulkanik muda (kurang dari 1 juta tahun), dengan beberapa ladang lava yang sangat baru di timur laut karena letusan dahsyat akibat bencana alam **Gunung Agung pada tahun 1963**.\n\n"
        "Aktivitas gunung berapi, karena endapan abu yang tebal dan kesuburan tanah yang dihasilkannya, juga merupakan faktor kuat dalam kemakmuran pertanian pulau tersebut.";

    final String part4Kemerdekaan =
        "Di tepi subduksi, Bali juga berada di tepi beting **Paparan Sunda**, tepat di sebelah barat **garis Wallace**, dan pada satu waktu terhubung ke pulau tetangga Jawa, terutama selama penurunan permukaan laut di dalam Zaman es. Karena itu fauna dan floranya mendekati benua Asia.";
    
    // --- Konten Baru yang diminta sebelumnya ---
    final String part5Paleolitik = 
        "Bali menjadi bagian dari paparan Sunda, pulau ini telah terhubung ke pulau Jawa berkali-kali dalam sejarah. Bahkan hari ini, kedua pulau hanya dipisahkan oleh Selat Bali yang berjarak 2,4 km.\n\n"
        "Pendudukan oleh manusia Jawa kuno sendiri terakreditasi oleh temuan **manusia Jawa**, berumur antara 1,7 dan 0,7 juta tahun, salah satu spesimen **Homo erectus** yang pertama diketahui.\n\n"
        "Bali juga dihuni pada zaman **Paleolitik** (diperkirakan 1 SM hingga 200.000 SM), disaksikan oleh penemuan alat kuno seperti kapak tangan yang ditemukan di desa Sembiran dan Trunyan di Bali.\n\n"
        "Sebuah periode **Mesolitik** (200.000-30.000 SM) juga telah diidentifikasi, ditandai dengan pengumpulan dan perburuan makanan canggih, tetapi masih oleh Homo Erectus. Periode ini menghasilkan alat yang lebih canggih, seperti mata panah, dan juga alat yang terbuat dari tulang hewan atau ikan. Mereka tinggal di gua-gua sementara, seperti yang ditemukan di bukit Pecatu di Kabupaten Badung, seperti gua Selanding dan Karang Boma. Gelombang pertama **Homo Sapiens** tiba sekitar 45.000 SM ketika orang-orang Australoid bermigrasi ke selatan, menggantikan Homo Erectus.";

    // Memisahkan teks untuk menyisipkan gambar di tengah
    final String part6PenjajahanAwal =
        "Sejak **kerajaan Buleleng** jatuh ke tangan Belanda mulailah pemerintah Belanda ikut campur mengurus soal pemerintahan di Bali. Hal ini dilaksanakan dengan mengubah nama raja sebagai penguasa daerah dengan nama regent untuk daerah Buleleng dan Jembrana serta menempatkan P.L. Van Bloemen Waanders sebagai controleur yang pertama di Bali.\n\n"
        "Struktur pemerintahan di Bali masih berakar pada struktur pemerintahan tradisional, yaitu tetap mengaktifkan kepemimpinan tradisional dalam melaksanakan pemerintahan di daerah-daerah. Untuk di daerah Bali, kedudukan raja merupakan pemegang kekuasaan tertinggi, yang pada waktu pemerintahan kolonial didampingi oleh seorang **controleur**. Di dalam bidang pertanggungjawaban, raja langsung bertanggung jawab kepada Residen Bali dan Lombok yang berkedudukan di Singaraja, sedangkan untuk Bali Selatan, raja-rajanya betanggung jawab kepada Asisten Residen yang berkedudukan di Denpasar.\n\n";
    
    final String part6PenjajahanAkhir = 
        "Untuk memenuhi kebutuhan tenaga administrasi, pemerintah Belanda telah membuka sebuah sekolah rendah yang pertama di Bali, yakni di Singaraja (1875) yang dikenal dengan nama **Tweede Klasse School**. Pada 1913, dibuka sebuah sekolah dengan nama **Erste Inlandsche School** dan kemudian disusul dengan sebuah sekolah Belanda dengan nama **Hollands Inlandshe School (HIS)** yang muridnya kebanyakan berasal dari anak-anak bangsawan dan golongan kaya.";
    
    // --- Konten BARU yang diminta ---
    final String part7Organisasi = 
        "Akibat pengaruh pendidikan yang didapat, para pemuda pelajar dan beberapa orang yang telah mendapatkan pekerjaan di kota Singaraja berinisiatif untuk mendirikan sebuah perkumpulan dengan nama \"Suita Gama Tirta\" yang bertujuan untuk memajukan masyarakat Bali dalam dunia ilmu pengetahuan melalui ajaran agama. Sayang perkumpulan ini tidak burumur panjang. Kemudian beberapa guru yang masih haus dengan pendidikan agama mendirikan sebuah perkumpulan yang diberi nama \"Shanti\" pada tahun 1923. Perkumpulan ini memiliki sebuah majalah yang bernama \"Shanti Adnyana\" yang kemudian berubah menjadi \"Bali Adnyana\"\n\n"
        "Pada tahun 1925 di Singaraja juga didirikan sebuah perkumpulan yang diberi nama \"Suryakanta\" dan memiliki sebuah majalah yang diberi nama \"Suryakanta\". Seperti perkumpulan Shanti, Suryakanta menginginkan agar masyarakat Bali mengalami kemajuan dalam bidang pengetahuan dan menghapuskan adat istiadat yang sudah tidak sesuai dengan perkembangan zaman. Sementara itu, di Karangasem lahir suatu perhimpunan yang bernama \"Satya Samudaya Baudanda Bali Lombok\" yang anggotanya terdiri atas pegawai negeri dan masyarakat umum dengan tujuan menyimpan dan mengumpulkan uang untuk kepentingan studiefonds.";

    final String part8Kemerdekaan =
        "Menyusul Proklamasi Kemerdekaan Indonesia, pada tanggal 23 Agustus 1945, Mr. I Gusti Ketut Puja tiba di Bali dengan membawa mandat pengangkatannya sebagai Gubernur Sunda Kecil. Sejak kedatangan dia inilah Proklamasi Kemerdekaan Indonesia di Bali mulai disebarluaskan sampai ke desa-desa. Pada saat itulah mulai diadakan persiapan-persiapan untuk mewujudkan susunan pemerintahan di Bali sebagai daerah Sunda Kecil dengan ibu kotanya Singaraja.\n\n"
        "Sejak pendaratan NICA di Bali, Bali selalu menjadi arena pertempuran. Dalam pertempuran itu pasukan RI menggunakan sistem gerilya. Oleh karena itu, MBO sebagai induk pasukan selalu berpindah-pindah. Untuk memperkuat pertahanan di Bali, didatangkan bantuan ALRI dari Jawa yang kemudian menggabungkan diri ke dalam pasukan yang ada di Bali. Karena seringnya terjadi pertempuran, pihak Belanda pernah mengirim surat kepada Rai untuk mengadakan perundingan. Akan tetapi, pihak pejuang Bali tidak bersedia, bahkan terus memperkuat pertahanan dengan mengikutsertakan seluruh rakyat.\n\n"
        "Untuk memudahkan kontak dengan Jawa, Rai pernah mengambil siasat untuk memindahkan perhatian Belanda ke bagian timur Pulau Bali. Pada 28 Mei 1946 Rai mengerahkan pasukannya menuju ke timur dan ini terkenal dengan sebutan \"Long March\". Selama diadakan \"Long March\" itu pasukan gerilya sering dihadang oleh tentara Belanda sehingga sering terjadi pertempuran. Pertempuran yang membawa kemenangan di pihak pejuang ialah pertempuran Tanah Arun, yaitu pertempuran yang terjadi di sebuah desa kecil di lereng Gunung Agung, Kabupaten Karangasem. Dalam pertempuran Tanah Arun yang terjadi 9 Juli 1946 itu pihak Belanda banyak menjadi korban. Setelah pertempuran itu pasukan Ngurah Rai kembali menuju arah barat yang kemudian sampai di Desa Marga (Tabanan). Untuk lebih menghemat tenaga karena terbatasnya persenjataan, ada beberapa anggota pasukan terpaksa disuruh berjuang bersama-sama dengan masyarakat.";
    // --------------------------------------------------------------------------

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text('Sejarah Bali', style: TextStyle(fontFamily: 'Nusantara', color: Colors.white, fontWeight: FontWeight.bold)),
        // AppBar semi-transparan
        backgroundColor: Colors.black.withOpacity(0.6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0, 
      ),

      body: Stack(
        children: [
          // === 1. Background Image (Ganti dengan gambar khas Bali) ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/tari-bali.jpg', // Placeholder: Ganti dengan gambar khas Bali (misal: Pura)
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
              color: Colors.black.withOpacity(0.75), // Overlay gelap 
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
                    // === HERO IMAGE (Bali) ===
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          'assets/images/balidulu.jpg', // Placeholder: Gambar Hero Bali (misal: Sawah/Pura Agung)
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
                            'B A L I',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Bagian 1: Subduksi Tektonik dan Pengangkatan Lempeng ===
                          _buildContentSection(
                            title: "Subduksi Tektonik dan Pengangkatan Lempeng",
                            content: part1Awal,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 2: Kemunculan Fenomena Vulkanik (Gunung Berapi) ===
                          _buildContentSection(
                            title: "Kemunculan Fenomena Vulkanik (Gunung Berapi)",
                            content: part2Majapahit,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),
                          
                          // === Bagian 3: Dampak Aktivitas Vulkanik dan Kesuburan Tanah ===
                          _buildContentSection(
                            title: "Dampak Aktivitas Vulkanik dan Kesuburan Tanah", 
                            content: part3Perlawanan,
                            isMobile: isMobile,
                          ),
                          
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 4: Posisi di Paparan Sunda dan Garis Wallace ===
                          _buildContentSection(
                            title: "Posisi di Paparan Sunda dan Garis Wallace", 
                            content: part4Kemerdekaan,
                            isMobile: isMobile,
                          ),
                          
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 5: Masa Paleolitik dan Mesolitik ===
                          _buildContentSection(
                            title: "Masa Paleolitik dan Mesolitik", 
                            content: part5Paleolitik,
                            isMobile: isMobile,
                          ),
                          
                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 6: Masa Penjajahan Belanda (dengan Gambar) ===
                          _buildContentSection(
                            title: "Masa Penjajahan Belanda", 
                            content: part6PenjajahanAwal, // Bagian awal teks
                            isMobile: isMobile,
                          ),
                          
                          // === Gambar di tengah bagian "Masa Penjajahan Belanda" ===
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Sudut membulat
                              child: Image.asset(
                                'assets/images/bali2.jpg', // Gambar yang diminta
                                width: double.infinity,
                                height: isMobile ? 200 : 300, // Tinggi responsif
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: isMobile ? 200 : 300,
                                  color: Colors.grey.shade800,
                                  child: const Center(child: Text("Image Not Found", style: TextStyle(color: Colors.red))),
                                ),
                              ),
                            ),
                          ),
                          
                          _buildContentSection(
                            title: "", // Judul kosong karena ini kelanjutan
                            content: part6PenjajahanAkhir, // Bagian akhir teks
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 7: Lahirnya Organisasi Pergerakan ===
                          _buildContentSection(
                            title: "Lahirnya Organisasi Pergerakan",
                            content: part7Organisasi,
                            isMobile: isMobile,
                          ),

                          const Divider(color: Colors.white24, height: 40),

                          // === Bagian 8: Masa Kemerdekaan ===
                          _buildContentSection(
                            title: "Masa Kemerdekaan",
                            content: part8Kemerdekaan,
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