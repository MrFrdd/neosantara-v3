// lib/pages/payment_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:convert'; // Import dart:convert

class PaymentPage extends StatefulWidget {
  final int total;
  final List<Map<String, dynamic>> cartItems; // Tambahkan cartItems
  final int idUser; // Tambahkan idUser
  final String namaUser; // Tambahkan namaUser

  const PaymentPage({
    super.key,
    required this.total,
    required this.cartItems, // Diperlukan
    required this.idUser, // Diperlukan
    required this.namaUser, // Diperlukan
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool processing = false;
  String selectedMethod = 'Transfer Bank';

  // Alamat API (Ganti [IP_KOMPUTER_ANDA] dengan IP lokal Anda atau '10.0.2.2' jika menggunakan Android Emulator)
  // Pastikan XAMPP Anda berjalan dan folder 'api_flutter' ada di htdocs
  static const String _apiBaseUrl = 'http://localhost/flutter_budaya_api/insert_transaksi.php'; 

  Future<void> _pay() async {
    setState(() => processing = true);

    final dataToSend = {
      'id_user': widget.idUser,
      'nama_user': widget.namaUser,
      'cart_items': widget.cartItems, // Data keranjang lengkap
      'total_bayar': widget.total,
      'metode_pembayaran': selectedMethod,
    };

    try {
      final response = await http.post(
        Uri.parse(_apiBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataToSend),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          // Berhasil, kembalikan true ke CartPage
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pembayaran Sukses! ID Transaksi: ${result['id_transaksi']}')),
          );
          Navigator.of(context).pop(true); 
        } else {
          // Gagal dari PHP
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pembayaran Gagal: ${result['message']}')),
          );
        }
      } else {
        // Gagal koneksi/server (misalnya status 500)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Server (${response.statusCode}): ${response.body}'),
          ),
        );
      }
    } catch (e) {
      // Error lain (koneksi, parsing, dll.)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan koneksi: $e')),
        );
      }
    }

    setState(() => processing = false);
  }

  @override
  Widget build(BuildContext context) {
    // ... (widget build tetap sama)
    final total = widget.total;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ... (Card Ringkasan Pembayaran)
            Card(
              color: Colors.grey[900],
              child: ListTile(
                leading: const Icon(Icons.receipt, color: Colors.white70),
                title: const Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Total: Rp $total',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // ... (Card Pilihan Metode Pembayaran)
            Card(
              color: Colors.grey[900],
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'Transfer Bank',
                    groupValue: selectedMethod,
                    title: const Text(
                      'Transfer Bank',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeColor: Colors.greenAccent[400],
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                  RadioListTile<String>(
                    value: 'QRIS',
                    groupValue: selectedMethod,
                    title: const Text(
                      'QRIS (scan)',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeColor: Colors.greenAccent[400],
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                  RadioListTile<String>(
                    value: 'Cod',
                    groupValue: selectedMethod,
                    title: const Text(
                      'Cash on Delivery (COD)',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeColor: Colors.greenAccent[400],
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // ... (Loading/Button)
            if (processing)
              const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              )
            else
              ElevatedButton(
                onPressed: _pay,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.greenAccent[700],
                  foregroundColor: Colors.black,
                ),
                child: Text('Bayar (Metode: $selectedMethod)'),
              ),
          ],
        ),
      ),
    );
  }
}