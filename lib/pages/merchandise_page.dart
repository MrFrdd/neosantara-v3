// lib/pages/merchandise_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_uas_budayaindonesia/pages/card_page.dart';

class MerchandisePage extends StatefulWidget {
  const MerchandisePage({super.key});

  @override
  State<MerchandisePage> createState() => _MerchandisePageState();
}

class _MerchandisePageState extends State<MerchandisePage> {
  final List<Map<String, dynamic>> products = [
    {
      'id': 'p1',
      'name': 'Kaos Batik Modern',
      'price': 120000,
      'image': 'assets/images/batik_noder.jpg',
    },
    {
      'id': 'p2',
      'name': 'Totebag Nusantara',
      'price': 65000,
      'image': 'assets/images/totebag.jpg',
    },
    {
      'id': 'p3',
      'name': 'Stiker Wayang Kulit',
      'price': 15000,
      'image': 'assets/images/stiker.jpg',
    },
    {
      'id': 'p4',
      'name': 'Gantungan Kunci Bali',
      'price': 20000,
      'image': 'assets/images/gantungan_bali.jpg',
    },
  ];

  final List<Map<String, dynamic>> cart = [];

  int get cartCount => cart.fold(0, (sum, it) => sum + (it['qty'] as int));

  void addToCart(Map<String, dynamic> product) {
    final idx = cart.indexWhere((c) => c['id'] == product['id']);
    setState(() {
      if (idx >= 0) {
        cart[idx]['qty'] = cart[idx]['qty'] + 1;
      } else {
        cart.add({
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'qty': 1,
        });
      }
    });
  }

  void updateCartFromChild(List<Map<String, dynamic>> updated) {
    setState(() {
      cart
        ..clear()
        ..addAll(updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Merchandise", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cart: List<Map<String, dynamic>>.from(cart),
                        onCartChanged: (updated) {
                          updateCartFromChild(updated);
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ===========================================================
      //   RESPONSIVE WINDOWS LAYOUT (MAKS LEBAR 1400)
      // ===========================================================
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              int crossAxisCount = 2;
              if (width < 450)
                crossAxisCount = 1;
              else if (width < 850)
                crossAxisCount = 2;
              else if (width < 1200)
                crossAxisCount = 3;
              else
                crossAxisCount = 4;

              final aspectRatio = width < 450 ? 0.85 : 0.72;

              return GridView.builder(
                padding: const EdgeInsets.all(18),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final p = products[i];
                  return MerchandiseCard(
                    name: p['name'],
                    price: p['price'],
                    image: p['image'],
                    isDark: true,
                    onBuy: () => addToCart(p),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// ===================================================================
//  CARD UNTUK WINDOWS + MOBILE (DARK MODE GLASSMORPHISM)
// ===================================================================

class MerchandiseCard extends StatefulWidget {
  final String name;
  final int price;
  final String image;
  final bool isDark;
  final VoidCallback onBuy;

  const MerchandiseCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.isDark,
    required this.onBuy,
  });

  @override
  State<MerchandiseCard> createState() => _MerchandiseCardState();
}

class _MerchandiseCardState extends State<MerchandiseCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(hovering ? 1.04 : 1.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(hovering ? 0.5 : 0.3),
                    blurRadius: hovering ? 22 : 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),

                  // TEXT
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp ${widget.price}",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      onPressed: widget.onBuy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        minimumSize: Size(isMobile ? double.infinity : 120, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Beli",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}