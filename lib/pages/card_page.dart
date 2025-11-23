// lib/pages/card_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/payment_card.dart';
import 'package:shared_preferences/shared_preferences.dart'; // PENTING: Import ini

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final ValueChanged<List<Map<String, dynamic>>> onCartChanged;

  const CartPage({super.key, required this.cart, required this.onCartChanged});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cart;

  // --- State Variabel Dinamis (Status Login) ---
  int _currentUserId = 0; 
  String _currentUserName = 'Tamu';
  bool _isLoggedIn = false;
  // ---------------------------------------------

  @override
  void initState() {
    // Menyalin keranjang dari widget ke state untuk dimodifikasi
    cart = List<Map<String, dynamic>>.from(widget.cart);
    _loadUserData(); // Panggil saat initState
    super.initState();
  }

  // Fungsi untuk memuat data pengguna dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        // PERBAIKAN: Baca ID sebagai String ('user_id') lalu konversi ke int.
        final String? userIdStr = prefs.getString('user_id'); 
        _currentUserId = int.tryParse(userIdStr ?? '0') ?? 0;
        
        // Baca Nama sebagai String ('user_name')
        _currentUserName = prefs.getString('user_name') ?? 'Tamu';
        
        // Status login ditentukan dari keberadaan ID user (> 0)
        _isLoggedIn = _currentUserId != 0; 
      });
    }
  }

  // FIX: total dengan cast aman (menggunakan fold untuk menghitung total harga)
  int get total => cart.fold<int>(
    0,
    (sum, item) =>
        sum + ((item['price'] ?? 0) as int) * ((item['qty'] ?? 0) as int),
  );

  void saveBack() {
    widget.onCartChanged(cart);
  }

  // Widget untuk menampilkan item keranjang
  Widget _buildCartItem(Map<String, dynamic> item) {
    // ... (Logika tampilan item keranjang, tidak ada perubahan mendasar)
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ListTile(
            tileColor: Colors.black.withOpacity(0.4),
            leading: Image.asset(item['image'], width: 55, fit: BoxFit.cover),
            title: Text(
              item['name'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Rp ${item['price']}",
              style: const TextStyle(color: Colors.amber),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.white70,
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      // Mengurangi kuantitas atau menghapus item jika qty <= 1
                      if ((item['qty'] as int) > 1) {
                        item['qty'] = (item['qty'] as int) - 1;
                      } else {
                        cart.remove(item);
                      }
                    });
                    saveBack();
                  },
                ),
                Text(
                  "${item['qty']}",
                  style: const TextStyle(color: Colors.white),
                ),
                IconButton(
                  color: Colors.white70,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => item['qty'] = (item['qty'] as int) + 1);
                    saveBack();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData, // Refresh data user saat tombol refresh ditekan
          )
        ],
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'Keranjang Anda kosong. Ayo belanja!',
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return _buildCartItem(cart[index]);
              },
            ),
      
      // --- BOTTOM NAVIGATION BAR (LOGIKA UTAMA STATUS LOGIN) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18),
        color: Colors.grey[900],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              // Tombol di-DISABLE (null) jika keranjang kosong ATAU belum login
              onPressed: cart.isEmpty || !_isLoggedIn ? null : () async { 
                // Jika tombol ini diklik, PASTI _isLoggedIn adalah true dan cart tidak kosong
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      total: total,
                      cartItems: cart,
                      // Kirim data user yang sudah dijamin ada
                      idUser: _currentUserId, 
                      namaUser: _currentUserName, 
                    ),
                  ),
                ).then((isSuccess) {
                  // Jika transaksi sukses (pop(true) dari PaymentPage)
                  if (isSuccess == true) {
                    setState(() {
                      cart.clear();
                      saveBack();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaksi berhasil! Keranjang dikosongkan.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  // Muat ulang data user jika ada perubahan (misal: user login setelah klik disable)
                  _loadUserData();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoggedIn ? Colors.amber[700] : Colors.grey, // Warna tombol berdasarkan status login
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                cart.isEmpty
                    ? 'Keranjang Kosong'
                    : !_isLoggedIn 
                        ? 'Masuk untuk Bayar' // Teks saat belum login
                        : 'Lanjutkan ke Pembayaran', // Teks saat sudah login
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}