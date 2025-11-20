import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/merchandise_page.dart';
import '../widgets/menu_button.dart';
import '../widgets/sejarah_dropdown.dart';
// Import file pages yang sudah Anda buat di langkah perbaikan
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

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool showLogin = false;

  final List<String> _regions = [
    "Jakarta",
    "Jawa Timur",
    "Jawa Tengah",
    "Jawa Barat",
    "Bali",
  ];

  // === FUNGSI NAVIGASI SEJARAH DAERAH ===
  void _navigateToRegion(String region) {
    // Tutup Drawer jika terbuka (penting untuk mobile)
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    // Navigasi ke halaman spesifik
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

  // === FUNGSI NAVIGASI PROFIL ===
  void _navigateToProfile() {
    // Tutup Drawer jika terbuka (penting untuk mobile)
    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.pop(context);
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfilPage()));
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

  // === Footer Section (Tentang Pembuat) ===
  Widget _footerSection(bool isMobile) {
    final double horizontalPadding = 16;
    final double webContentMaxWidth = 1200;
    final double topSpacing = isMobile ? 0 : 10;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizontalPadding,
      ),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),

          Divider(
            color: isMobile ? Colors.white70 : Colors.white54,
            thickness: isMobile ? 1.0 : 0.5,
            height: isMobile ? 16 : 35,
          ),

          if (!isMobile)
            SizedBox(
              width: webContentMaxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tentang Pembuat',
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dibuat oleh: Frida Debugging',
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kontak: neosantara@idn.com',
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Alamat: UNPAM VIKTOR',
                    style: TextStyle(
                      fontFamily: 'Nusantara',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tentang Pembuat',
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Dibuat oleh: Frida Debugging',
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kontak: neosantara@idn.com',
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Alamat: UNPAM VIKTOR',
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

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

                          // MENU HOME (MOBILE)
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

                          // Menu Sejarah Daerah (MOBILE)
                          SejarahDropdown(
                            regions: _regions,
                            onSelected: (region) {
                              // SejarahDropdown sudah memanggil Navigator.pop(context) di _selectItem
                              _navigateToRegion(region);
                            },
                          ),

                          const Divider(color: Colors.white24, thickness: 0.8),

                          // MENU LOGIN (MOBILE)
                          MenuButton(
                            text: "Login",
                            isDrawer: true,
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                showLogin = true;
                              });
                            },
                          ),

                          // MENU PROFIL BARU (MOBILE)
                          MenuButton(
                            text: "Profil",
                            isDrawer: true,
                            onPressed: _navigateToProfile,
                          ),
                        ],
                      ),
                    ),

                    // FOOTER
                    _footerSection(isMobile),
                  ],
                ),
              ),
            )
          : null,

      // === APPBAR ===
      appBar: AppBar(
        // Menghilangkan tombol back/menu otomatis
        automaticallyImplyLeading: false,

        // Latar Belakang Transparan di Web, Hitam di Mobile
        backgroundColor: isMobile ? Colors.black : Colors.transparent,
        elevation: isMobile ? 4 : 0,

        iconTheme: const IconThemeData(color: Colors.white, size: 30),

        // --- LEADING BARU (Menggantikan Tombol Back/Drawer) ---
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 28),
                onPressed: () {
                  // Tutup Drawer jika terbuka
                  if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
                    Navigator.pop(context);
                  }
                  // Karena ini adalah IntroPage, navigasi ke "Home" adalah pop ke root.
                  // Jika ini bukan root, Anda perlu: Navigator.of(context).popUntil((route) => route.isFirst);
                  // Di kasus ini, karena Anda di IntroPage (root), tidak perlu aksi pop.
                  // JIKA ADA MAKSUD UNTUK MEMBUKA DRAWER DI SINI: ganti logika ini
                  // dengan Scaffold.of(context).openDrawer();

                  // Karena Anda ingin fungsinya menjadi "Home", jika tombol back
                  // muncul (artinya ada halaman sebelumnya), maka pop. Jika tombol
                  // drawer muncul (di root), maka tidak perlu aksi (kecuali membuka drawer).

                  // Untuk kasus IntroPage ini (asumsi ini adalah root):
                  Scaffold.of(context).openDrawer();
                },
                tooltip: "Menu", // Tetap berfungsi sebagai menu
              )
            : null,

        // --- AKHIR LEADING BARU ---
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Jika bukan mobile, kita ingin ada sedikit padding
            // di sebelah kiri logo (karena leading: null)
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

            // Spacer di kiri (Opsional, untuk menengahkan)
            if (!isMobile) const Spacer(),

            // --- BAGIAN NAVIGASI UTAMA (WEB) ---
            if (!isMobile)
              Row(
                children: [
                  // MENU HOME (WEB)
                  MenuButton(text: "Home", onPressed: () {}),

                  // MENU MERCHANDISE (WEB)
                  MenuButton(
                    text: "Merchandise",
                    onPressed: _navigateToMerchandise,
                  ),

                  // Menu Sejarah Daerah (WEB)
                  SejarahDropdown(
                    regions: _regions,
                    onSelected: _navigateToRegion,
                  ),
                ],
              ),

            // Spacer di tengah untuk memisahkan navigasi utama dan aksi user
            const Spacer(),

            // --- BAGIAN AKSI/USER (WEB) ---
            if (!isMobile)
              Row(
                children: [
                  // 1. ICON PROFIL BARU
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _navigateToProfile,
                    tooltip: "Profil User",
                  ),

                  // 2. MENU LOGIN
                  MenuButton(
                    text: "Login",
                    onPressed: () {
                      setState(() {
                        showLogin = true;
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),

      // === BODY ===
      body: Stack(
        children: [
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
                          // Latar Belakang & Overlay Hitam
                          Container(
                            height: isMobile ? null : constraints.maxHeight,
                            constraints: isMobile
                                ? BoxConstraints(minHeight: minMobileHeight)
                                : null,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/tari-bali.jpg',
                                ), // ASUMSI: Gambar ini ada
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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

                // FOOTER UNTUK WEB BROWSER
                if (!isMobile) _footerSection(isMobile),
              ],
            ),
          ),

          // === LOGIN OVERLAY ===
          if (showLogin)
            LoginPage(
              onClose: () {
                setState(() {
                  showLogin = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
