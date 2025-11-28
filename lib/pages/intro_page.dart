import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/merchandise_page.dart';
import '../widgets/menu_button.dart';
import '../widgets/sejarah_dropdown.dart';
// PENTING: Import SharedPreferences untuk menyimpan status login
import 'package:shared_preferences/shared_preferences.dart'; 

// Import file pages yang sudah Anda buat
import '../pages/login_page.dart';
import '../pages/jakarta_page.dart';
import '../pages/jawa_timur_page.dart';
import '../pages/jawa_tengah_page.dart';
import '../pages/jawa_barat_page.dart';
import '../pages/bali_page.dart';
import '../pages/profil_page.dart';
import '../pages/card_page.dart';
import '../pages/merchandise_page.dart';
import '../pages/payment_card.dart';

// === WIDGET BARU: ShortcutCardItem (untuk efek hover) ===
class ShortcutCardItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isMobile;
  final Function(String) onNavigate;

  const ShortcutCardItem({
    required this.item,
    required this.isMobile,
    required this.onNavigate,
    super.key,
  });

  @override
  State<ShortcutCardItem> createState() => _ShortcutCardItemState();
}

class _ShortcutCardItemState extends State<ShortcutCardItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Ukuran card disesuaikan agar terlihat keren di web dan mobile
    final double cardWidth = widget.isMobile
        ? (MediaQuery.of(context).size.width - 2 * 18 - 20) / 2
        : 220;

    // Menentukan faktor skala dan elevasi untuk efek hover
    // Efek hover hanya berlaku jika bukan tampilan mobile
    final double scale = _isHovering && !widget.isMobile ? 1.05 : 1.0;
    final double elevation = _isHovering && !widget.isMobile ? 18.0 : 8.0;

    return MouseRegion(
      // KUNCI: Mendeteksi masuk/keluar pointer mouse
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click, // Mengubah kursor menjadi pointer
      child: InkWell(
        onTap: () => widget.onNavigate(widget.item['name'] as String), // Menggunakan fungsi navigasi yang sudah ada
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          // KUNCI: Animasi transisi yang halus
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: cardWidth,
          height: widget.isMobile ? 140 : 180,
          // Menerapkan efek skala
          transform: Matrix4.identity()..scale(scale), 
          
          decoration: BoxDecoration(
            // Menerapkan bayangan yang lebih besar saat hover
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovering && !widget.isMobile ? 0.6 : 0.3),
                spreadRadius: 0,
                blurRadius: elevation, 
                offset: Offset(0, elevation / 2),
              ),
            ],
            // MENGGUNAKAN DecorationImage UNTUK COVER GAMBAR
            image: DecorationImage(
              image: AssetImage(widget.item['imagePath'] as String),
              fit: BoxFit.cover,
              // Warna fallback jika gambar gagal dimuat
              onError: (exception, stackTrace) => const NetworkImage('assets/images/placeholder.jpg'),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              // Overlay hitam transparan untuk membuat teks mudah dibaca
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              
              // Konten teks dan ikon
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(widget.item['icon'] as IconData, color: Colors.white, size: 36),
                    const SizedBox(height: 10),
                    Text(
                      widget.item['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Nusantara',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1))
                        ]
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item['subtitle'] as String,
                      style: TextStyle(
                        fontFamily: 'Nusantara',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// === AKHIR WIDGET ShortcutCardItem ===


class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool showLogin = false;
  // State untuk melacak status login dan nama user
  bool _isLoggedIn = false; 
  String _userName = 'Profil';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Cek status saat halaman dimuat
  }

  // === FUNGSI UNTUK MEMUAT STATUS LOGIN ===
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Gunakan kunci ('is_logged_in' dan 'user_name') sesuai dengan yang disimpan di login_page.dart
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false; 
    final userName = prefs.getString('user_name') ?? 'Profil';

    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _userName = userName;
      });
    }
  }
  
  // === FUNGSI UNTUK LOGOUT (Dipanggil dari tombol KELUAR di AppBar/Drawer) ===
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in'); // Hapus status login
    await prefs.remove('user_name'); // Hapus nama user
    
    // Tambahkan penghapusan kunci lain yang terkait dengan sesi jika ada
    await prefs.remove('user_email');
    await prefs.remove('user_id');

    if (mounted) {
      setState(() {
        _isLoggedIn = false;
        _userName = 'Profil';
        showLogin = false; // Pastikan overlay login tertutup
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil keluar."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  final List<String> _regions = [
    "Jakarta",
    "Jawa Timur",
    "Jawa Tengah",
    "Jawa Barat",
    "Bali",
  ];

  // === FUNGSI NAVIGASI SEJARAH DAERAH ===
  void _navigateToRegion(String region) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    if (region == "Jakarta") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JakartaPage()));
    } else if (region == "Jawa Timur") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaTimurPage()));
    } else if (region == "Jawa Tengah") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaTengahPage()));
    } else if (region == "Jawa Barat") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const JawaBaratPage()));
    } else if (region == "Bali") {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const BaliPage()));
    }
  }

  // === FUNGSI NAVIGASI PROFIL (FIXED: Menangani hasil logout dari ProfilPage) ===
  void _navigateToProfile() async { 
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    // Menggunakan await untuk mendapatkan nilai balik dari ProfilPage
    final didLogout = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfilPage()));
    
    // Jika ProfilPage mengembalikan true, berarti pengguna menekan tombol "Keluar" di sana
    if (mounted && didLogout == true) {
      // Karena tombol "Keluar" di ProfilPage sudah menghapus data di SharedPreferences
      // kita hanya perlu memperbarui state di IntroPage
      await _checkLoginStatus(); 

      // Tampilkan notifikasi dan tutup overlay jika terbuka
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda telah berhasil keluar.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      setState(() {
        showLogin = false;
      });
    }
  }

  void _navigateToMerchandise() {
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MerchandisePage()),
    );
  }

  // === Kotak utama budaya Indonesia ===
  Widget _mainCultureBox(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : null,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Text(
            'Keanekaragaman Budaya Indonesia',
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.amber,
              fontSize: isMobile ? 20 : 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              height: 1.3,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Indonesia adalah negeri kepulauan yang kaya akan keanekaragaman budaya. '
            'Dari Sabang hingga Merauke, setiap daerah memiliki warisan unik berupa bahasa, kesenian, tradisi, pakaian adat, hingga nilai-nilai kearifan lokal yang menjadi jati diri bangsa.',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white,
              fontSize: isMobile ? 17 : 17,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Budaya Nusantara tidak hanya menjadi peninggalan masa lalu, tetapi juga sumber inspirasi yang terus hidup dan berkembang seiring waktu. '
            'Di tengah arus modernisasi, budaya Indonesia hadir sebagai pengingat akan pentingnya menjaga identitas dan melestarikan tradisi bagi generasi masa depan.',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white,
              fontSize: isMobile ? 17 : 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // === Kotak slogan ===
  Widget _sloganCards(bool isMobile) {
    final List<Map<String, dynamic>> slogans = [
      {
        'text': 'Ayo kenali dan lestarikan budaya Indonesia bersama kami!',
        'icon': Icons.favorite,
        'color': Colors.orangeAccent,
      },
      {
        'text': 'Belajar budaya, cintai Indonesia!',
        'icon': Icons.school,
        'color': Colors.amber,
      },
      {
        'text': 'Mulai perjalananmu menjelajahi budaya Nusantara!',
        'icon': Icons.explore,
        'color': Colors.deepOrangeAccent,
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: slogans.map((item) {
        return Container(
          width: isMobile ? double.infinity : null,
          margin: EdgeInsets.only(bottom: isMobile ? 6 : 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (item['color'] as Color).withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (item['color'] as Color).withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: isMobile ? 28 : 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['text'] as String,
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: Colors.white,
                    fontSize: isMobile ? 15 : 20,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- FUNGSI BARU: Shortcut Cards ---
  Widget _buildShortcutCards(bool isMobile) {
    // Definisi data untuk setiap shortcut DENGAN PENAMBAHAN imagePath
    final List<Map<String, dynamic>> shortcuts = [
      {'name': 'Jakarta', 'page': const JakartaPage(), 'icon': Icons.location_city, 'color': const Color(0xFFE53935), 'subtitle': 'Megapolitan & Betawi', 'imagePath': 'assets/images/jakarta1.jpg'}, // Merah
      {'name': 'Jawa Timur', 'page': const JawaTimurPage(), 'icon': Icons.fastfood, 'color': const Color(0xFF43A047), 'subtitle': 'Sejarah Pembentukan Provinsi', 'imagePath': 'assets/images/jatim.jpg'}, // Hijau
      {'name': 'Jawa Tengah', 'page': const JawaTengahPage(), 'icon': Icons.temple_buddhist, 'color': const Color(0xFF1E88E5), 'subtitle': 'Era Kerajaan & Era Kesultanan', 'imagePath': 'assets/images/jateng.jpg'}, // Biru
      {'name': 'Jawa Barat', 'page': const JawaBaratPage(), 'icon': Icons.music_note, 'color': const Color(0xFF6A1B9A), 'subtitle': 'Sejarah Awal & Era Kerajaan Sunda', 'imagePath': 'assets/images/jabar.jpg'}, // Ungu
      {'name': 'Bali', 'page': const BaliPage(), 'icon': Icons.beach_access, 'color': const Color(0xFFFFB300), 'subtitle': 'Pulau Dewata & Hindu', 'imagePath': 'assets/images/balidulu.jpg'}, // Emas/Jingga
    ];

    final double horizontalPadding = isMobile ? 18 : 40;

    // KUNCI PERUBAHAN: Container luar sekarang memiliki warna overlay gelap
    return Container(
      width: double.infinity,
      // Menggunakan warna overlay yang sama dengan Hero Section (0.45)
      color: Colors.black.withOpacity(0.45), 
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Bagian Shortcut
          const Text(
            '🚀 Akses Cepat Daerah Pilihan',
            style: TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Teks judul tetap putih
            ),
          ),
          const SizedBox(height: 20),

          // Grid/Wrap untuk menampilkan cards
          Center(
            child: Wrap(
              spacing: 20, // Jarak horizontal antar card
              runSpacing: 20, // Jarak vertikal antar baris card
              alignment: WrapAlignment.center,
              // KUNCI PERUBAHAN: Menggunakan ShortcutCardItem yang baru
              children: shortcuts.map((item) => ShortcutCardItem(
                item: item, 
                isMobile: isMobile, 
                onNavigate: _navigateToRegion,
              )).toList(), 
            ),
          ),
        ],
      ),
    );
  }
  // --- Akhir Fungsi Shortcut Cards ---

  // === FUNGSI BARU: Tempoe Doeloe Section (Bundaran HI, Jembatan Merah, Kota Lama, Braga, Catur Muka) ===

  // Helper Widget for a single comparison card (Dulu/Sekarang)
  Widget _buildComparisonCard(Map<String, String> item, bool isMobile) {
    return Container(
      margin: isMobile ? const EdgeInsets.only(bottom: 30) : EdgeInsets.zero,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item['image']!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: isMobile ? 200 : 250, // Fixed height for visual consistency
              alignment: Alignment.center,
              // Fallback jika gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) => Container(
                height: isMobile ? 200 : 250,
                color: Colors.grey.shade800,
                child: Center(
                  child: Text(
                    'Gambar tidak ditemukan: ${item['image']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Title (Dahulu/Sekarang)
          Text(
            item['title']!,
            style: const TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),

          // Description Text
          Text(
            item['text']!,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 15,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper function to build a complete comparison block (e.g., Bundaran HI or Jembatan Merah)
  Widget _buildComparisonView({
    required String subtitle, 
    required List<Map<String, String>> data, 
    required bool isMobile
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Nusantara',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),

        isMobile
            ? Column(
                children: data.map((item) => _buildComparisonCard(item, isMobile)).toList(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((item) => Expanded(
                  child: Padding(
                    padding: item == data.first
                        ? const EdgeInsets.only(right: 15) // Padding kanan untuk gambar pertama
                        : const EdgeInsets.only(left: 15), // Padding kiri untuk gambar kedua
                    child: _buildComparisonCard(item, isMobile),
                  ),
                )).toList(),
              ),
      ],
    );
  }

  // Master Tempoe Doeloe Section
  Widget _buildTempoeDoeloeSection(bool isMobile) {
    final double horizontalPadding = isMobile ? 18 : 40;

    // 1. Data Bundaran HI
    final List<Map<String, String>> hiData = [
      {
        'title': 'Dahulu',
        'image': 'assets/images/bundaranHIold.png',
        'text': 'Diresmikan pada 1962 menjelang Pesta Olahraga Asia (Asian Games), Bundaran Hotel Indonesia (HI) menjadi ikon modernisasi Jakarta. Di tengah-tengahnya, terdapat Monumen Selamat Datang. Monumen tersebut dibuat oleh tim pematung Keluarga Arca, dipimpin oleh Edhi Sunarso, untuk menyambut para tamu dari mancanegara.',
      },
      {
        'title': 'Sekarang',
        'image': 'assets/images/BundaranHInow.jpg',
        'text': 'Bundaran HI kini menjadi pusat aktivitas warga, dari Hari Bebas Kendaraan Bermotor (Car-Free Day) setiap Minggu hingga tempat perayaan tahun baru. Gedung-gedung tinggi, jalur Mass Rapid Transit (MRT), dan trotoar yang rapi mengubahnya menjadi wajah modern Jakarta. Kalau kamu ingin melihat Patung Selamat Datang dengan jelas, silakan naik ke lantai dua Halte Bundaran HI Astra!',
      },
    ];

    // 2. Data Jembatan Merah
    final List<Map<String, String>> jembatanMerahData = [
      {
        'title': 'Dahulu',
        'image': 'assets/images/jembatanmerahOLD.jpg',
        'text': 'Jembatan Merah dibangun pada tahun 1743 sebagai bagian dari perjanjian antara Kesultanan Mataram dan VOC, yang menjadikan kawasan sekitar jembatan sebagai pusat perdagangan penting di Surabaya.',
      },
      {
        'title': 'Sekarang',
        'image': 'assets/images/jembatanmerahNOW.jpg',
        'text': 'sebuah jembatan bersejarah yang terletak di pusat kota Surabaya, Jawa Timur, Indonesia. Jembatan ini terkenal sebagai saksi bisu dari berbagai peristiwa penting dalam sejarah Indonesia, terutama yang terjadi pada masa perjuangan kemerdekaan.',
      },
    ];

    // 3. Data Kota Lama
    final List<Map<String, String>> kotaLamaData = [
      {
        'title': 'Dahulu',
        'image': 'assets/images/kotalamaOLD.webp',
        'text': 'Aktivitas warga dengan latar belakang bangunan gedung kawasan Kota Lama dan jembatan di Jalan Pemuda, Kota Semarang, Jawa Tengah, 23 Agustus 1986.',
      },
      {
        'title': 'Sekarang',
        'image': 'assets/images/kotalamaNOW.webp',
        'text': 'Kota Lama yang dijuluki ”Little Netherland” seperti tumbuh kembali bersama binar cahaya lampu di antara bangunan tuanya beberapa tahun ini. Gairah kota metropolis pada abad ke-19 sebagai pusat perdagangan di pesisir utara Jawa itu seolah dihidupkan kembali seiring denyut hidup pariwisatanya.',
      },
    ];

    // 4. Data Jalan Braga
    final List<Map<String, String>> bragaData = [
      {
        'title': 'Dahulu',
        'image': 'assets/images/bragaOLD.jpg',
        'text': 'Dulunya Jalan Braga hanya sebuah jalan kecil berlumpur. Jalan ini menjadi jalur pedati untuk mengirimkan kopi dari gudang milik Andreas de Wilde ke Jalan Raya Pos (sekarang dikenal dengan Jalan Asia Afrika). Orang-orang dulu mengenal Braga sebagai Jalan Pedati (pedatiweg).',
      },
      {
        'title': 'Sekarang',
        'image': 'assets/images/bragaNOW.jpg',
        'text': 'Seiring berjalannya waktu, jalan ini menjadi destinasi yang kerap disambangi oleh anak-anak muda dari berbagai penjuru sebagai tempat hangout mereka. Ratusan tahun lalu, Jalan Braga mulai ramai di bawah pemerintahan Hindia Belanda.',
      },
    ];
    
    // 5. Data Patung Catur Muka (BARU DITAMBAHKAN)
    final List<Map<String, String>> caturMukaData = [
      {
        'title': 'Dahulu',
        'image': 'assets/images/patungcaturmukaOLD.jpg',
        'text': 'Sebelumnya diketahui bahwa Patung Catur Muka dirusak oleh Warga Negara Asing (WNA) yang tak mengantongi identitas pada Sabtu lalu. Dimana dari uahnya tersebut ornamen di Patung Catur Muka rusak, seperti halnya kelopak, ornamen bebadungan, serta satu slot pipa air mancur.',
      },
      {
        'title': 'Sekarang',
        'image': 'assets/images/patungcaturmukaNOW.jpg',
        'text': 'Patung Carur Muka yang dikenal sebagai landmark Kota Denpasar kini tampil lebih indah. Pasalnya, kelopak teratai pada dasar patung yang sempat dirusak oleh WNA yang tak mengantongi identitas kini sudah kembali terpasang indah. Bahkan, polesan warna yang sempat pudar kini terlihat mengkilap. Berdasarkan pantauan di lapangan, seluruh ornamen telah terpasang dan Patung Catur Muka yang berlokasi di titik nol KM Kota Denpasar kini tampil lebih indah.',
      },
    ];


    return Container(
      width: double.infinity,
      color: Colors.black.withOpacity(0.45), // Consistent dark overlay
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏛️ Tempoe Doeloe', // Adding a relevant icon
            style: TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 10),

          // --- BLOCK 1: Bundaran HI ---
          _buildComparisonView(
            subtitle: 'Bundaran HI Dulu & Sekarang',
            data: hiData,
            isMobile: isMobile,
          ),
          
          // --- Separator ---
          const SizedBox(height: 60), 
          const Divider(color: Colors.white24, thickness: 1.0),
          
          // --- BLOCK 2: Jembatan Merah ---
          _buildComparisonView(
            subtitle: 'Jembatan Merah Dulu & Sekarang',
            data: jembatanMerahData,
            isMobile: isMobile,
          ),

          // --- Separator ---
          const SizedBox(height: 60), 
          const Divider(color: Colors.white24, thickness: 1.0),

          // --- BLOCK 3: Kota Lama ---
          _buildComparisonView(
            subtitle: 'Kota Lama Dulu & Sekarang',
            data: kotaLamaData,
            isMobile: isMobile,
          ),

          // --- Separator ---
          const SizedBox(height: 60), 
          const Divider(color: Colors.white24, thickness: 1.0),

          // --- BLOCK 4: Jalan Braga ---
          _buildComparisonView(
            subtitle: 'Jalan Braga Dulu & Sekarang',
            data: bragaData,
            isMobile: isMobile,
          ),
          
          // --- Separator BARU ---
          const SizedBox(height: 60), 
          const Divider(color: Colors.white24, thickness: 1.0),
          
          // --- BLOCK 5: Patung Catur Muka (BARU DITAMBAHKAN) ---
          _buildComparisonView(
            subtitle: 'Patung Catur Muka Dulu & Sekarang',
            data: caturMukaData,
            isMobile: isMobile,
          ),

        ],
      ),
    );
  }
  // === AKHIR Tempoe Doeloe Section ===

  // === Footer Section (Tentang Pembuat) ===
  Widget _footerSection(bool isMobile) {
    final double horizontalPadding = 16;
    // Tentukan lebar maksimum untuk background card
    final double contentCardMaxWidth = 650; 

    // Bagian Informasi Pembuat (Teks)
    Widget creatorInfo = Column(
      // Perataan diubah ke rata kiri (start) untuk web
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start, 
      children: [
        // Spasi vertikal kembali ke 40px (mempertahankan posisi teks)
        if (!isMobile) const SizedBox(height: 47), 
        Text(
          'Tentang Pembuat',
          style: TextStyle(
            fontFamily: 'Nusantara',
            fontSize: isMobile ? 14 : 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Dibuat oleh: Muhammad Frida & Arfana Ridho',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white,
            fontSize: isMobile ? 13 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NIM: 241011401999 & 241011401690',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white70,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'KELAS: 03TPLP033',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white54,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'MATKUL: Algoritma & Pemrograman II',
          style: TextStyle(
            fontFamily: 'Nusantara',
            color: Colors.white54,
            fontSize: isMobile ? 12 : 12,
          ),
        ),
      ],
    );

    // Widget Gambar
    Widget creatorImage = Container(
      // Memberikan margin kanan hanya pada tampilan Web
      margin: EdgeInsets.only(right: isMobile ? 0 : 20, bottom: isMobile ? 10 : 0),
      child: Transform.translate(
        // Offset vertikal direset ke nol (posisi diatur oleh margin di Column)
        offset: const Offset(0,-30), 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/doyfrid.png', // <<< ASUMSI PATH GAMBAR DARI FILE UPLOADED
            // Ukuran gambar kembali ke 180x180 (mempertahankan ukuran)
            height: isMobile ? 100 : 180, 
            width: isMobile ? 100 : 180,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );


    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizontalPadding,
      ),
      // KUNCI PERUBAHAN: Warna overlay gelap (0.45)
      color: Colors.black.withOpacity(0.45), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: topSpacing), // Dihapus untuk menghemat ruang vertikal

          Divider(
            color: isMobile ? Colors.white70 : Colors.white54,
            thickness: isMobile ? 1.0 : 0.5,
            height: isMobile ? 16 : 35,
          ),

          // --- Konten Utama Footer (Gambar + Info) ---
          
          Container(
            constraints: isMobile ? null : BoxConstraints(maxWidth: contentCardMaxWidth),
            // KUNCI PERUBAHAN: Padding vertikal diperkecil dari 4 menjadi 2
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            decoration: BoxDecoration(
              // Background card info tetap gelap agar kontras
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
              // Menghilangkan border
              border: null, 
            ),
            
            child: !isMobile
              ? IntrinsicHeight( // WEB VIEW
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment.start agar gambar dan teks sejajar rata atas
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      creatorImage, // Gambar di Kiri
                      Expanded(child: creatorInfo), // Teks Info
                    ],
                  ),
                )
              : Column( // MOBILE VIEW (tetap rata tengah karena tampilan stack vertikal)
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    creatorImage, 
                    creatorInfo,  
                  ],
                ),
          ),
          // --- Akhir Konten Utama Footer ---


          const SizedBox(height: 12),
          const Divider(color: Colors.white24, thickness: 0.8),
          const SizedBox(height: 6),
          Text(
            '© 2025 NeoSantara • Melestarikan Warisan Budaya Bangsa',
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white54,
              fontSize: isMobile ? 11 : 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;

    final double? heroHeight = isMobile ? null : 650;
    final double minMobileHeight =
        screenSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);

    return Scaffold(
      backgroundColor: Colors.black,
      // PENTING: Untuk membuat AppBar transparan di Web
      extendBodyBehindAppBar: !isMobile,

      resizeToAvoidBottomInset: true,

      // === DRAWER (untuk mobile) ===
      drawer: isMobile
          ? Drawer(
              backgroundColor: Colors.black87,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    'assets/images/neosantara.jpg', // ASUMSI: Gambar ini ada
                                    height: 38,
                                    width: 38,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "NeoSantara",
                                  style: TextStyle(
                                    fontFamily: 'Nusantara',
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white24, thickness: 0.8),

                          // MENU HOME (MOBILE) - Sudah ada di Drawer
                          MenuButton(
                            text: "Home",
                            isDrawer: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          MenuButton(
                            text: "Merchandise",
                            isDrawer: true,
                            onPressed: _navigateToMerchandise,
                          ),

                          // Menu Sejarah Daerah (MOBILE) - Sudah ada di Drawer
                          SejarahDropdown(
                            regions: _regions,
                            onSelected: (region) {
                              _navigateToRegion(region);
                            },
                          ),

                          const Divider(color: Colors.white24, thickness: 0.8),

                          // >>> KONDISI LOGIN/KELUAR (MOBILE)
                          if (!_isLoggedIn)
                            // Jika BELUM login
                            MenuButton(
                              text: "LOGIN",
                              isDrawer: true,
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  showLogin = true;
                                });
                              },
                            )
                          else
                            // Jika SUDAH login: Tampilkan nama dan tombol KELUAR
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    'Halo, $_userName', // Tampilkan nama user
                                    style: const TextStyle(
                                      fontFamily: 'Nusantara',
                                      color: Colors.amber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                MenuButton(
                                  text: "KELUAR",
                                  isDrawer: true,
                                  onPressed: () {
                                    Navigator.pop(context); // Tutup drawer
                                    _logout(); // Logout (menghapus status)
                                  },
                                ),
                              ],
                            ),
                          // AKHIR KONDISI LOGIN/KELUAR (MOBILE) <<<
                          
                          // MENU PROFIL BARU (MOBILE)
                          MenuButton(
                            text: "Profil",
                            isDrawer: true,
                            onPressed: _navigateToProfile,
                          ),
                        ],
                      ),
                    ),

                    // FOOTER (di Drawer)
                    _footerSection(isMobile),
                  ],
                ),
              ),
            )
          : null,

      // === APPBAR ===
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isMobile ? Colors.black : Colors.transparent,
        elevation: isMobile ? 4 : 0,

        iconTheme: const IconThemeData(color: Colors.white, size: 30),

        leading: isMobile
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: "Menu",
                  );
                },
              )
            : null,

        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- BAGIAN KIRI (Logo & Nama Aplikasi) ---
            if (!isMobile) const SizedBox(width: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/neosantara.jpg', // ASUMSI: Gambar ini ada
                height: 34,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "NeoSantara",
              style: TextStyle(
                fontFamily: 'Nusantara',
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.1,
              ),
            ),
            
            // --- SPACER 1: PUSHES MENU TO CENTER ---
            const Spacer(), 

            // >>> BAGIAN TENGAH (Menu Navigasi - Hanya Web) <<<
            if (!isMobile)
              Row(
                mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
                children: [
                  // 1. Home Button
                  MenuButton(
                    text: "Home",
                    onPressed: () {}, // Sudah di IntroPage, tidak perlu navigasi
                  ),
                  const SizedBox(width: 8),

                  // 2. Merchandise Button
                  MenuButton(
                    text: "Merchandise",
                    onPressed: _navigateToMerchandise,
                  ),
                  const SizedBox(width: 8),

                  // 3. Sejarah Dropdown
                  SejarahDropdown(
                    regions: _regions,
                    onSelected: _navigateToRegion,
                  ),
                ],
              ),
            
            // --- SPACER 2: PUSHES USER ACTIONS TO RIGHT ---
            const Spacer(), 
            
            // >>> BAGIAN KANAN (Aksi Pengguna - Hanya Web) <<<
            if (!isMobile)
              Row(
                mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
                children: [
                  // Nama User (Hanya tampil jika sudah login)
                  if (_isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Halo, $_userName', 
                        style: const TextStyle(
                          fontFamily: 'Nusantara',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                  // 1. ICON PROFIL
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _navigateToProfile,
                    tooltip: "Profil User",
                  ),

                  // 2. MENU LOGIN / KELUAR (Kondisional)
                  if (!_isLoggedIn)
                    // Jika BELUM login
                    MenuButton(
                      text: "LOGIN",
                      onPressed: () {
                        setState(() {
                          showLogin = true;
                        });
                      },
                    )
                  else
                    // Jika SUDAH login
                    MenuButton(
                      text: "KELUAR",
                      onPressed: _logout, // Panggil fungsi logout
                    ),
                  const SizedBox(width: 20), // Padding di paling kanan
                ],
              ),
            // AKHIR KONDISI MENU WEB <<<
          ],
        ),
      ),

      // === BODY ===
      body: Stack(
        children: [
          // KUNCI PERUBAHAN 1: Background Image Global
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tari-bali.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: isMobile ? null : heroHeight,
                      constraints: isMobile
                          ? BoxConstraints(minHeight: minMobileHeight)
                          : null,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Overlay Hitam (0.45)
                          Container(
                            height: isMobile ? null : constraints.maxHeight,
                            constraints: isMobile
                                ? BoxConstraints(minHeight: minMobileHeight)
                                : null,
                            color: Colors.black.withOpacity(0.45), 
                          ),

                          // KONTEN UTAMA DI PUSAT (Bottom Alignment)
                          Align(
                            alignment: isMobile
                                ? Alignment.bottomCenter
                                : Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 18 : 40,
                                vertical: isMobile ? 8 : 20,
                              ),
                              child: isMobile
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _mainCultureBox(isMobile),
                                        const SizedBox(height: 10),
                                        _sloganCards(isMobile),
                                        const SizedBox(height: 8),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: _mainCultureBox(isMobile),
                                        ),
                                        const SizedBox(width: 25),
                                        Flexible(child: _sloganCards(isMobile)),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // === BAGIAN: SHORTCUT CARDS (Menggunakan ShortcutCardItem) ===
                _buildShortcutCards(isMobile),
                // ========================================================
                
                // === BAGIAN: TEMPOE DOELOE ===
                _buildTempoeDoeloeSection(isMobile),
                // =================================

                // FOOTER UNTUK WEB BROWSER
                if (!isMobile) _footerSection(isMobile),
              ],
            ),
          ),

          // === LOGIN OVERLAY ===
          if (showLogin)
            LoginPage(
              // PENTING: Panggil _checkLoginStatus() setelah modal ditutup
              onClose: () async { 
                setState(() {
                  showLogin = false;
                });
                _checkLoginStatus(); 
              },
            ),
        ],
      ),
    );
  }
}