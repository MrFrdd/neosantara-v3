// lib/pages/order_history_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // Untuk glassmorphism effect

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // Base URL API Anda: PENTING! Ganti localhost menjadi 10.0.2.2 untuk Android Emulator
  // Pastikan Anda juga menerapkan perubahan ini pada profil_page.dart dan file Dart lainnya
  final String baseUrl = 'http://localhost/flutter_budaya_api/';
  
  String _idUser = "";
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchOrders();
  }

  // Ambil ID User dari Shared Preferences dan panggil fetch
  Future<void> _loadUserIdAndFetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('user_id') ?? "";

    if (savedId.isEmpty) {
      if(mounted) {
        setState(() {
          _idUser = "";
          _isLoading = false;
          _errorMessage = "ID pengguna tidak ditemukan. Silakan login ulang.";
        });
      }
      return;
    }

    if(mounted) {
      setState(() {
        _idUser = savedId;
      });
    }
    _fetchOrderHistory();
  }

  // === Fungsi untuk mengambil riwayat transaksi dari server ===
  Future<void> _fetchOrderHistory() async {
    if(mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });
    }

    // Menggunakan fetch_transaksi.php
    final endpoint = Uri.parse('${baseUrl}fetch_transaksi.php?id_user=$_idUser');

    try {
      final response = await http.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (mounted) {
          if (responseData['success'] == true) {
            setState(() {
              _orders = responseData['data'] ?? [];
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMessage = responseData['message'] ?? "Gagal memuat data transaksi.";
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Gagal terhubung ke server. Status: ${response.statusCode}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan jaringan: $e';
          _isLoading = false;
        });
      }
    }
  }

  // === Fungsi untuk membatalkan pesanan (CANCEL) ===
  Future<void> _cancelOrder(String idTransaksi) async {
    // Tampilkan dialog konfirmasi
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batalkan Pesanan"),
        content: const Text("Apakah Anda yakin ingin membatalkan pesanan ini? Aksi ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Ya, Batalkan"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm != true) return; // Jika user membatalkan dialog

    _showSnackbar('Memproses pembatalan...', Colors.blue); 

    // Menggunakan cancel_transaksi.php
    final endpoint = Uri.parse('${baseUrl}cancel_transaksi.php');

    try {
      final response = await http.post(
        endpoint,
        body: {'id_transaksi': idTransaksi},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showSnackbar(responseData['message'], responseData['success'] ? Colors.green : Colors.red);
        if (responseData['success']) {
          _fetchOrderHistory(); // Refresh daftar pesanan setelah sukses
        }
      } else {
        _showSnackbar('Gagal terhubung ke server: ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Kesalahan jaringan: $e', Colors.red);
    }
  }

  // Utility function for showing SnackBar
  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Card untuk menampilkan satu item transaksi
  Widget _buildOrderCard(Map<String, dynamic> order) {
    // Pisahkan item-item yang dibeli
    final itemNames = (order['nama_barang'] as String).split('||');
    final itemQtys = (order['jumlah_barang'] as String).split('||').map((e) => int.tryParse(e) ?? 0).toList();
    final itemPrices = (order['harga_satuan'] as String).split('||').map((e) => int.tryParse(e) ?? 0).toList();
    
    final status = order['status'] ?? 'Lunas'; // Default Lunas

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID Transaksi: ${order['id_transaksi']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildStatusChip(status),
                  ],
                ),
                const Divider(color: Colors.white12, height: 20),
                
                // Daftar Item
                ...List.generate(itemNames.length, (index) {
                  if(index >= itemNames.length || index >= itemQtys.length || index >= itemPrices.length) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(color: Colors.white54),
                        ),
                        Expanded(
                          child: Text(
                            // Format rupiah sederhana
                            '${itemNames[index]} (${itemQtys[index]}x) - Rp ${itemPrices[index].toString()}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                const Divider(color: Colors.white12, height: 20),
                
                // Total dan Pembayaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Bayar:',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${order['total_bayar']}', 
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Metode:',
                      style: TextStyle(color: Colors.white54),
                    ),
                    Text(
                      order['metode_pembayaran'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tanggal:',
                      style: TextStyle(color: Colors.white54),
                    ),
                    Text(
                      order['tanggal_transaksi'] ?? '-', 
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                // Tombol Cancel (hanya jika status belum 'Dibatalkan' atau 'Selesai')
                if (status != 'Dibatalkan' && status != 'Selesai')
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        // Panggil fungsi _cancelOrder
                        onPressed: () => _cancelOrder(order['id_transaksi'].toString()),
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        label: const Text("Batalkan Pesanan"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Widget Chip Status
  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    switch (status) {
      case 'Lunas': // Status default baru
      case 'Selesai':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'Dibatalkan':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'Diproses':
        color = Colors.blue;
        icon = Icons.local_shipping;
        break;
      default:
        color = Colors.amber;
        icon = Icons.help_outline;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        if (_idUser.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: ElevatedButton.icon(
                              onPressed: _fetchOrderHistory,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Coba Lagi"),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              : _orders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_toggle_off, color: Colors.white54, size: 60),
                          SizedBox(height: 10),
                          Text(
                            "Belum ada riwayat pesanan.",
                            style: TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(18),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(_orders[index]);
                      },
                    ),
    );
  }
}