import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'admin_kelola_panitia.dart';
import 'admin_daftar_panitia.dart';
import 'widgets/admin_shared_widgets.dart';

class AdminMainNavigation extends StatefulWidget {
  final int initialIndex;

  const AdminMainNavigation({super.key, this.initialIndex = 0});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AdminDashboardPage(
        onNavigateTab: (index) => _onTabTapped(index),
      ),
      const AdminKelolaPanitiaPage(),
      const AdminDaftarPanitiaPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AdminColors.textBorder, width: 2.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AdminColors.textBorder,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AdminColors.textBorder,
          unselectedItemColor: Colors.grey.shade600,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.3),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard, color: AdminColors.textBorder),
              label: 'Beranda Event',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt),
              activeIcon: Icon(Icons.person_add, color: AdminColors.textBorder),
              label: 'Kelola Panitia',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined),
              activeIcon: Icon(Icons.badge, color: AdminColors.textBorder),
              label: 'Akun Panitia',
            ),
          ],
        ),
      ),
    );
  }
}
