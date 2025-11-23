// lib/pages/payment_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class PaymentPage extends StatefulWidget {
  final int total;
  final List<Map<String, dynamic>> cartItems; // Tambahkan cartItems
  final int idUser; // Tambahkan idUser
  final String namaUser; // Tambahkan namaUser

  const PaymentPage({
    super.key,
    required this.total,
    required this.cartItems, 
    required this.idUser, 
    required this.namaUser, 
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool processing = false;
  String selectedMethod = 'Transfer Bank';

  // Alamat API untuk proses transaksi
  // GANTI: Sesuaikan dengan IP Anda atau '10.0.2.2' jika Emulator
  static const String _apiBaseUrl = 'http://localhost/flutter_budaya_api/insert_transaksi.php'; 

  Future<void> _pay() async {
    // --- SAFETY CHECK (PENTING) ---
    if (widget.idUser <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID Pengguna tidak valid. Harap login ulang di halaman sebelumnya.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    // ---------------------------------
    
    setState(() => processing = true);

    final dataToSend = {
      // Kirim ID dan Total sebagai String (best practice)
      'id_user': widget.idUser.toString(), 
      'nama_user': widget.namaUser,
      'total_bayar': widget.total.toString(),
      'metode_pembayaran': selectedMethod,
      'cart_items': widget.cartItems,
    };
    
    try {
      final response = await http.post(
        Uri.parse(_apiBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dataToSend),
      );

      if (!mounted) return;

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } on FormatException {
        // Error jika respons bukan JSON
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ERROR DECODE JSON: Server mengirim respons tidak valid (Status HTTP: ${response.statusCode}).'),
            backgroundColor: Colors.deepOrange,
          ),
        );
        return;
      }

      if (responseData['success'] == true) { 
        // Sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Pembayaran berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke CartPage dengan hasil true (agar keranjang dikosongkan)
        Navigator.of(context).pop(true);
      } else {
        // Gagal dari server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Pembayaran gagal. Mohon coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan jaringan/server: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => processing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // ... (Tampilan Kartu Total Bayar, sudah benar)
            Card(
              color: Colors.grey[900],
              child: ListTile(
                title: const Text(
                  'TOTAL BAYAR',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  'Rp $total',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // ... (Pilihan Metode Pembayaran, sudah benar)
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Pilih Metode Pembayaran:',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    value: 'Transfer Bank',
                    groupValue: selectedMethod,
                    title: const Text(
                      'Transfer Bank (BCA/Mandiri)',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeColor: Colors.greenAccent[400],
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                  RadioListTile<String>(
                    value: 'Qris',
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
            // --- TOMBOL BAYAR ---
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