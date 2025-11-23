import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // PENTING: Import HTTP
import 'dart:convert'; // PENTING: Import untuk JSON
import 'package:shared_preferences/shared_preferences.dart'; // Untuk data user

class CommentsSection extends StatefulWidget {
  final bool isMobile;
  final double horizontalPadding;
  final String contentId; // ID konten yang dikomentari (Wajib)

  const CommentsSection({
    super.key,
    required this.isMobile,
    required this.horizontalPadding,
    required this.contentId, 
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;
  String _userName = 'Guest'; 
  String _userId = '';

  // GANTI URL INI DENGAN ENDPOINT PHP ANDA YANG SEBENARNYA!
  final String _apiUrl = 'http://localhost/komentar.php/'; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // --- FUNGSI UTILITY API ---

  // 1. Ambil data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil user_id juga (sesuai profil_page.dart)
    final savedId = prefs.getString('user_id') ?? ''; 
    final savedName = prefs.getString('user_name') ?? 'Guest User';
    
    if (mounted) {
      setState(() {
        _userName = savedName;
        _userId = savedId;
      });
    }
  }

  // 2. Ambil Komentar dari API (Menggunakan GET)
  Future<void> _fetchComments() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Mengirim content_id sebagai query parameter
      final uri = Uri.parse('$_apiUrl?content_id=${widget.contentId}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Karena PHP mengembalikan array of comments, langsung di-decode
        final List<dynamic> fetchedComments = json.decode(response.body);
        
        if (mounted) {
          setState(() {
            _comments = fetchedComments.cast<Map<String, dynamic>>();
          });
        }
      } else {
        // Jika server mengembalikan error (misal 400 atau 500)
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Gagal memuat komentar.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error ${response.statusCode}: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Error koneksi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error koneksi server. Pastikan API berjalan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 3. Kirim Komentar ke API (Menggunakan POST)
  Future<void> _postComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar tidak boleh kosong.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Mengirim komentar..."),
            backgroundColor: Colors.blueAccent,
            duration: Duration(seconds: 1),
        ),
    );

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        // Body dikirim sebagai JSON, sesuai dengan penanganan di komentar.php
        body: json.encode({
          'content_id': widget.contentId,
          'user': _userName, 
          'id_user': _userId, // Opsional
          'comment': commentText,
        }),
      );

      // Cek apakah response berhasil (201 Created atau 200 OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Komentar berhasil dikirim!"),
            backgroundColor: Colors.green,
          ),
        );
        _fetchComments(); // Muat ulang komentar
      } else {
         // Jika server mengembalikan error
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Gagal mengirim komentar.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${response.statusCode}: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error koneksi saat kirim komentar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // --- FUNGSI WIDGET HELPER ---

  Widget _buildComment(Map<String, dynamic> data) {
    final user = data['user'] as String? ?? 'Anonim';
    final comment = data['comment'] as String? ?? 'Tidak ada teks.';
    final color = user == _userName ? Colors.amber : Colors.cyanAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12, 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Komentar",
            style: TextStyle(
              fontFamily: 'Nusantara',
              color: Colors.white,
              fontSize: widget.isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Input Komentar
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  maxLines: null, 
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar Anda di sini sebagai $_userName...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Tombol Kirim
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFCC00), Color(0xFFFF9900)],
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
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _postComment, // Panggil fungsi kirim API
                  tooltip: 'Kirim Komentar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Daftar Komentar (Dari API)
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            )
          else if (_comments.isEmpty)
            const Text(
              "Belum ada komentar. Jadilah yang pertama berkomentar!",
              style: TextStyle(color: Colors.white70),
            )
          else
            // Mapping data API ke widget komentar
            ..._comments.map((data) => _buildComment(data)).toList(),
        ],
      ),
    );
  }
}