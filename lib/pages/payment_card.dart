// lib/pages/payment_page.dart
import 'dart:async';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final int total;
  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool processing = false;
  String selectedMethod = 'Transfer Bank';

  Future<void> _pay() async {
    setState(() => processing = true);

    // Simulasi pemrosesan pembayaran
    await Future.delayed(const Duration(seconds: 2));

    setState(() => processing = false);

    // Kembalikan hasil sukses ke halaman sebelumnya
    if (mounted) {
      Navigator.of(context).pop(true);
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
