// lib/pages/card_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/payment_card.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final ValueChanged<List<Map<String, dynamic>>> onCartChanged;

  const CartPage({super.key, required this.cart, required this.onCartChanged});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cart;

  // --- Data User Placeholder ---
  // Gunakan data user dummy (contoh) yang akan dikirim ke API
  final int _currentUserId = 1; 
  final String _currentUserName = 'Pelanggan Ujian Flutter';
  // -----------------------------

  @override
  void initState() {
    // Menyalin keranjang dari widget ke state untuk dimodifikasi
    cart = List<Map<String, dynamic>>.from(widget.cart);
    super.initState();
  }

  // FIX: total dengan cast aman (menggunakan fold untuk menghitung total harga)
  int get total => cart.fold<int>(
    0,
    (sum, item) =>
        sum + ((item['price'] ?? 0) as int) * ((item['qty'] ?? 0) as int),
  );

  void saveBack() {
    // Memberikan kembali data keranjang yang telah diupdate ke halaman MerchandisePage
    widget.onCartChanged(cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Keranjang", style: TextStyle(color: Colors.white)),
      ),

      // =============================================================
      // RESPONSIVE WRAPPER UNTUK WINDOWS / WEB
      // =============================================================
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Expanded(
                  child: cart.isEmpty
                      ? const Center(
                          child: Text(
                            "Keranjang kosong",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, i) {
                            final item = cart[i];
                            return _buildCartItem(item);
                          },
                        ),
                ),

                // TOTAL + BAYAR
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Rp $total",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: cart.isEmpty
                            ? null
                            : () async {
                                // Meneruskan data keranjang, total, id user, dan nama user
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PaymentPage(
                                      total: total,
                                      cartItems: cart, // Meneruskan daftar item keranjang
                                      idUser: _currentUserId, // Meneruskan ID User
                                      namaUser: _currentUserName, // Meneruskan Nama User
                                    ),
                                  ),
                                );

                                // Jika PaymentPage mengembalikan true (pembayaran sukses)
                                if (result == true) {
                                  setState(() => cart.clear());
                                  saveBack();
                                  // Menampilkan pesan sukses ke user setelah kembali ke CartPage (opsional)
                                  if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Pembayaran berhasil dan keranjang dikosongkan!'))
                                      );
                                  }
                                  // Navigasi kembali ke halaman sebelumnya (MerchandisePage)
                                  Navigator.pop(context); 
                                }
                              },
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // ITEM KERANJANG (GLASSMORPHISM + DARK MODE)
  // =============================================================
  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: ListTile(
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
}