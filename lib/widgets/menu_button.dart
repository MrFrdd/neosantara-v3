// file kode menu_button.dart (FINAL CODE)
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String text; 
  final VoidCallback onPressed;
  final bool isDrawer; 

  const MenuButton({
    super.key, 
    required this.text, 
    required this.onPressed,
    this.isDrawer = false, 
  });

  // Fungsi untuk menentukan warna teks berdasarkan state interaksi
  Color _getTextColor(Set<WidgetState> states) {
    final Color defaultColor = Colors.white; 
    final Color highlightColor = Colors.amber.shade400; 

    if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
      return highlightColor;
    }
    
    return defaultColor; 
  }

  // Fungsi untuk menentukan style teks (ukuran/font weight)
  TextStyle _getTextStyle() {
    return TextStyle(
      fontFamily: 'Nusantara',
      fontSize: isDrawer ? 16 : 17,
      // FontWeight disesuaikan
      fontWeight: isDrawer ? FontWeight.w500 : FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        // Menyesuaikan padding berdasarkan lokasi (Drawer atau AppBar)
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(isDrawer 
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12) 
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        
        minimumSize: WidgetStateProperty.all<Size>(Size.zero), 
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        
        // Menggunakan foregroundColor untuk reaktivitas warna teks
        foregroundColor: WidgetStateProperty.resolveWith(_getTextColor),
        
        // Mengubah warna overlay/splash menjadi transparan atau putih samar
        overlayColor: isDrawer 
            ? null 
            : WidgetStateProperty.all<Color>(Colors.white.withOpacity(0.1)),
      ),
      child: Align(
        // Teks rata kiri di Drawer, rata tengah/default di AppBar
        alignment: isDrawer ? Alignment.centerLeft : Alignment.center,
        child: Text(
          text,
          style: _getTextStyle(),
        ),
      ),
    );
  }
}