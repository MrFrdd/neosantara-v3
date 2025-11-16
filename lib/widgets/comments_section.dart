import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final bool isMobile;
  final double horizontalPadding;

  const CommentsSection({
    super.key,
    required this.isMobile,
    required this.horizontalPadding,
  });

  // Helper untuk menampilkan komentar mock individual
  Widget _buildMockComment(String user, String comment, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12, // Latar belakang komentar agak gelap
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama pengguna dengan warna yang berbeda
          Text(
            user,
            style: TextStyle(
              fontFamily: 'Nusantara',
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          // Isi komentar
          Text(
            comment,
            style: const TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white70,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Data komentar mock
    final List<Map<String, dynamic>> mockComments = [
      {
        'user': 'Pengamat Sejarah',
        'comment': 'Informasi tentang era Kerajaan Sunda sangat detail! Saya penasaran bagaimana transisi dari Sunda Kelapa ke Jayakarta memengaruhi populasi lokal pada saat itu.',
        'color': Colors.cyan,
      },
      {
        'user': 'Traveler Jakarta',
        'comment': 'Saya sering mengunjungi Kota Tua, artikel ini memberikan konteks yang bagus mengenai tiga tahap perkembangan Jakarta. Terima kasih!',
        'color': Colors.pinkAccent,
      },
      {
        'user': 'Anonim 3',
        'comment': 'Apakah ada referensi lebih lanjut mengenai kebudayaan Buni yang disebutkan di awal?',
        'color': Colors.lightGreen,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kolom Komentar (Mock)",
            style: TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),

          // Formulir Input Komentar (Mock)
          Row(
            children: [
              Expanded(
                child: TextField(
                  // Ini adalah form mock, jadi tidak perlu controller
                  style: const TextStyle(color: Colors.white, fontFamily: 'Nusantara'),
                  decoration: InputDecoration(
                    hintText: "Tulis komentar Anda di sini (Mock)...",
                    hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Nusantara'),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Kirim Komentar (Mock)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFCC00), Color(0xFFFF9900)], // Gradien Kuning-Oranye
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.comment, color: Colors.black),
                  onPressed: () {
                    // Tampilkan pesan mock saat tombol ditekan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Komentar berhasil dikirim (Fitur Mock)."),
                        backgroundColor: Colors.amber,
                      ),
                    );
                  },
                  tooltip: 'Kirim Komentar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Daftar Komentar (Mock)
          ...mockComments.map((data) => _buildMockComment(
                data['user'] as String,
                data['comment'] as String,
                data['color'] as Color,
              )).toList(),
        ],
      ),
    );
  }
}