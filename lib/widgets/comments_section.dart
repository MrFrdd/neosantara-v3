import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:intl/intl.dart'; 

class CommentsSection extends StatefulWidget {
  final bool isMobile;
  final double horizontalPadding;
  final String contentId; 

  const CommentsSection({
    super.key,
    required this.isMobile,
    required this.horizontalPadding,
    required this.contentId, 
  });

  @override
  State<CommentsSection> createState() => CommentsSectionState();
}

class CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;
  String _userName = 'Guest'; 
  String _userId = ''; // ID Pengguna yang sedang login

  // GANTI URL INI DENGAN IP/DOMAIN API ANDA YANG TEPAT!
  final String _baseUrl = 'http://localhost/flutter_budaya_api/'; // Sesuaikan jika perlu
  String get _apiUrl => '${_baseUrl}comments_api.php'; 
  String get _deleteApiUrl => '${_baseUrl}delete_comment.php'; 
  // =========================================================

  @override
  void initState() {
    super.initState();
    // Memuat data user dan komentar saat pertama kali diinisialisasi
    _loadUserData().then((_) {
      if (widget.contentId.isNotEmpty) {
        _fetchComments();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  
  // ==================== A. Logika Data User ====================

  /// KRITIS: Metode publik untuk dipanggil dari halaman luar (JakartaPage)
  /// Memastikan _userId di-refresh setelah login atau logout.
  void loadComments() async {
    await _loadUserData(); 
    _fetchComments();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Gunakan setState hanya jika widget masih terpasang (mounted)
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? 'Guest';
        // Jika user log out, nilai _userId akan menjadi string kosong.
        _userId = prefs.getString('user_id') ?? ''; 
      });
    }
  }
  
  // ==================== B. Logika Ambil Komentar (GET) ====================

  Future<void> _fetchComments() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?content_id=${widget.contentId}'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _comments = List<Map<String, dynamic>>.from(data['comments']);
          });
        } else {
           _showSnackBar(data['message'] ?? 'Gagal mengambil komentar', Colors.orange);
           setState(() {
            _comments = []; // Kosongkan daftar jika gagal
          });
        }
      } else {
        _showSnackBar('Gagal terhubung ke API (Status: ${response.statusCode})', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Terjadi error jaringan: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==================== C. Logika Kirim Komentar (POST) ====================

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) {
      _showSnackBar('Komentar tidak boleh kosong.', Colors.orange);
      return;
    }
    // KRITIS: Jika _userId kosong (belum login), hentikan proses
    if (_userId.isEmpty) { 
       _showSnackBar('Anda harus masuk untuk berkomentar.', Colors.red);
       return;
    }
    
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {
          'content_id': widget.contentId,
          'id_user': _userId, 
          'user_name': _userName, 
          'comment_text': _commentController.text.trim(),
        },
      );
      
      if (!mounted) return;

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _commentController.clear();
        _showSnackBar('Komentar berhasil dikirim!', Colors.green);
        loadComments(); // Refresh komentar
      } else {
        _showSnackBar(data['message'] ?? 'Gagal mengirim komentar.', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Terjadi error jaringan saat mengirim: $e', Colors.red);
    } finally {
      if (mounted) {
       setState(() {
         _isLoading = false;
       });
      }
    }
  }

  // ==================== D. Logika Hapus Komentar ====================

  Future<void> _deleteComment(String commentId) async {
    // KRITIS: Jika _userId kosong (belum login), hentikan proses
    if (_userId.isEmpty) { 
       _showSnackBar('Anda harus masuk untuk menghapus komentar.', Colors.red);
       return;
    }
    
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.post(
        Uri.parse(_deleteApiUrl),
        body: {
          'id_comment': commentId,
          'id_user': _userId, // Verifikasi di backend bahwa user yang menghapus adalah pemiliknya
        },
      );

      if (!mounted) return;

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _showSnackBar('Komentar berhasil dihapus!', Colors.green);
        loadComments(); // Refresh komentar
      } else {
        _showSnackBar(data['message'] ?? 'Gagal menghapus komentar.', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Terjadi error jaringan saat menghapus: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==================== E. Widget Pembantu ====================

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }
  }

  Widget _buildComment(Map<String, dynamic> data) {
    final DateTime dateTime = DateTime.parse(data['created_at']);
    final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dateTime.toLocal());

    // KRITIS: Hanya muncul jika ID user yang melihat sama dengan ID user pemilik komen DAN user sedang login (_userId tidak kosong)
    final bool isUserComment = _userId.isNotEmpty && data['id_user'].toString() == _userId; 

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['user_name'] ?? 'Pengguna',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              // Tombol delete hanya muncul jika isUserComment
              if (isUserComment)
                InkWell(
                  onTap: _isLoading ? null : () => _deleteComment(data['id_comment'].toString()),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            data['comment_text'] ?? 'Tidak ada komentar.',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            formattedDate,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Divider(color: Colors.white12, height: 24),
        ],
      ),
    );
  }

  // ==================== F. Widget Build Utama ====================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Komentar & Diskusi",
            style: TextStyle(
              fontFamily: 'Nusantara',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFCC00),
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
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  // KRITIS: Menonaktifkan input jika user belum login
                  enabled: _userId.isNotEmpty && !_isLoading, 
                  decoration: InputDecoration(
                    hintText: _userId.isEmpty 
                        ? 'Masuk untuk menulis komentar...' // Pesan saat logout
                        : 'Tulis komentar Anda di sini...', // Pesan saat login
                    hintStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                  // KRITIS: Menonaktifkan tombol jika user belum login
                  onPressed: (_isLoading || _userId.isEmpty) ? null : _postComment, 
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
            ..._comments.map((data) => _buildComment(data)).toList(),
        ],
      ),
    );
  }
}