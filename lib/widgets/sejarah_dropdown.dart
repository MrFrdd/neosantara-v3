// file kode sejarah_dropdown.dart (FINAL CODE)
import 'package:flutter/material.dart';

// --- WIDGET UNTUK SETIAP ITEM SUB-MENU (MENGELOLA STATE WARNA TEKS) ---
class _DropdownItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDrawer;

  const _DropdownItem({
    required this.text,
    required this.onTap,
    required this.isDrawer,
  });

  @override
  State<_DropdownItem> createState() => __DropdownItemState();
}

class __DropdownItemState extends State<_DropdownItem> {
  bool _isHighlighted = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isHighlighted = true;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isHighlighted = false;
    });
  }
  
  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isHighlighted = false;
    });
    // Memanggil fungsi utama setelah interaksi selesai
    widget.onTap(); 
  }

  // Fungsi utilitas untuk menentukan warna default item
  Color _getDefaultColor() {
    // Daftar daerah yang diminta menggunakan warna Putih
    const List<String> whiteRegions = [
      'Jakarta',
      'Jawa Timur',
      'Jawa Tengah',
      'Jawa Barat',
      'Bali',
    ];
    
    if (whiteRegions.contains(widget.text)) {
      return Colors.white;
    }
    return Colors.amber.shade200; 
  }

  @override
  Widget build(BuildContext context) {
    
    final Color defaultColor = _getDefaultColor();
    final Color highlightColor = Colors.amber.shade400; 
    
    final Color textColor = _isHighlighted ? highlightColor : defaultColor;

    final Color splashColor = Colors.white.withOpacity(0.15);
    final Color hoverHighlightColor = Colors.white.withOpacity(0.1);

    final EdgeInsets itemPadding = EdgeInsets.symmetric(
        vertical: 10, horizontal: widget.isDrawer ? 32 : 0); 

    return InkWell(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        // Biarkan onTapUp yang memicu fungsi onTap utama
      },

      splashColor: splashColor,
      highlightColor: hoverHighlightColor,
      
      child: Container( 
        width: double.infinity, 
        padding: itemPadding, 
        child: Text(
          widget.text,
          style: TextStyle(
            color: textColor, 
            fontFamily: 'Nusantara',
            fontSize: widget.isDrawer ? 15 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
// --------------------------------------------------------------------


class SejarahDropdown extends StatefulWidget {
  final Function(String)? onSelected;
  final List<String> regions; 

  const SejarahDropdown({super.key, this.onSelected, required this.regions});

  @override
  State<SejarahDropdown> createState() => _SejarahDropdownState();
}

class _SejarahDropdownState extends State<SejarahDropdown> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _expanded = false;
  
  // State highlight untuk TOMBOL UTAMA di Drawer
  bool _isMainButtonHighlighted = false;


  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleExpanded() {
    final isDrawer = Scaffold.maybeOf(context)?.isDrawerOpen ?? false;

    if (_expanded) {
      _removeOverlay();
      setState(() {
        _expanded = false;
      });
    } else {
      setState(() {
        _expanded = true;
      });

      if (!isDrawer) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_buttonKey.currentContext != null) {
            _overlayEntry = _createOverlayEntry();
            Overlay.of(context).insert(_overlayEntry!);
          } else {
            setState(() {
              _expanded = false;
            });
          }
        });
      }
    }
  }

  void _selectItem(String item) {
    widget.onSelected?.call(item);
    
    _removeOverlay();
    setState(() {
      _expanded = false;
    });
    // Tutup Drawer setelah memilih item di mobile
    // Logika ini dipindahkan ke intro_page.dart untuk memisahkan UI dan Navigasi
    // if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
    //   Future.delayed(const Duration(milliseconds: 100), () { 
    //     Navigator.pop(context);
    //   });
    // }
  }

  OverlayEntry _createOverlayEntry() {
    if (_buttonKey.currentContext == null) return OverlayEntry(builder: (context) => Container());

    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) { 
        return Positioned.fill(
          child: GestureDetector(
            onTap: _toggleExpanded, 
            behavior: HitTestBehavior.translucent, 
            child: Stack(
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy + size.height + 4,
                  child: Material(
                    color: Colors.transparent,
                    child: _dropdownMenu(isDrawer: false),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _dropdownMenu({required bool isDrawer}) {
    final double menuWidth = isDrawer ? double.infinity : 180;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> items = widget.regions.asMap().entries.expand((entry) { 
      final index = entry.key;
      final region = entry.value;

      List<Widget> children = [
        _DropdownItem(
          text: region,
          onTap: () => _selectItem(region),
          isDrawer: isDrawer,
        ),
      ];

      if (index < widget.regions.length - 1 && !isDrawer) {
        children.add(
          const Divider(
            color: Colors.white24, 
            height: 1, 
            thickness: 0.8,
          ),
        );
      }
      return children;
    }).toList();

    Widget content;

    if (isDrawer) {
      // MODE DRAWER (Mobile) - Dibuat Scrollable dengan batasan tinggi
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.5, 
        ),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true, 
          padding: EdgeInsets.zero, 
          children: items,
        ),
      );
    } else {
      // MODE WEB (Overlay)
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      );
    }

    // Gabungkan dalam Container dekorasi
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isDrawer ? 0 : 12, vertical: isDrawer ? 0 : 6),
      decoration: BoxDecoration(
        color: isDrawer ? Colors.transparent : Colors.black, 
        borderRadius: BorderRadius.circular(isDrawer ? 0 : 10),
        border: isDrawer ? null : Border.all(color: Colors.white24, width: 0.6),
        boxShadow: isDrawer
            ? null
            : const [
                BoxShadow(
                    color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))
              ],
      ),
      child: content,
    );
  }

  Color _getButtonTextColor(Set<WidgetState> states) {
    final Color defaultColor = Colors.white; 
    final Color highlightColor = Colors.amber.shade400; 
    
    if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
      return highlightColor; 
    }
    return defaultColor; 
  }

  @override
  Widget build(BuildContext context) {
    final isDrawer = Scaffold.maybeOf(context)?.isDrawerOpen ?? false;

    // --- Mode AppBar (Desktop/Web) ---
    if (!isDrawer) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            key: _buttonKey, 
            onPressed: _toggleExpanded,
            style: ButtonStyle(
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 8),
                ),
                foregroundColor: WidgetStateProperty.resolveWith(_getButtonTextColor),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                      return Colors.white.withOpacity(0.05);
                    }
                    return null;
                  },
                ),
            ),
            child: Row(
              children: [
                const Text(
                  "Sejarah Daerah",
                  style: TextStyle(
                    fontFamily: 'Nusantara',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Icon(
                  _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    // --- Mode Drawer (Mobile) ---
    final Color defaultColor = Colors.white; 
    final Color highlightColor = Colors.amber; 
    
    final Color mainButtonTextColor = _isMainButtonHighlighted 
        ? highlightColor 
        : defaultColor;

    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOMBOL UTAMA "Sejarah Daerah"
        InkWell(
          onTap: _toggleExpanded,
          // Mengelola state highlight secara manual untuk tombol utama Drawer
          onTapDown: (_) => setState(() => _isMainButtonHighlighted = true),
          onTapCancel: () => setState(() => _isMainButtonHighlighted = false),
          onTapUp: (_) => setState(() => _isMainButtonHighlighted = false),

          splashColor: Colors.amber.withOpacity(0.15), 
          highlightColor: Colors.amber.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sejarah Daerah",
                  style: TextStyle(
                    color: mainButtonTextColor, 
                    fontFamily: 'Nusantara',
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: mainButtonTextColor, 
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        // DROP DOWN MENU (Sub-menu)
        if (_expanded)
          _dropdownMenu(isDrawer: true),
      ],
    );
  }
}