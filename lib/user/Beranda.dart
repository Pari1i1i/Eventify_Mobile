import 'package:flutter/material.dart';
import '../admin/admin_login.dart';
import 'data/user_mock_data.dart';
import 'widgets/user_event_card.dart';
import 'widgets/user_hero_banner.dart';
import 'widgets/user_search_bar.dart';

/// Halaman utama (Beranda) untuk Pengguna / User
class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final TextEditingController _kodeTiketController = TextEditingController();
  final TextEditingController _cariEventController = TextEditingController();
  bool _isSearchExpanded = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _kodeTiketController.dispose();
    _cariEventController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredEvents {
    if (_searchQuery.trim().isEmpty) return userEventList;
    final query = _searchQuery.toLowerCase();
    return userEventList.where((event) {
      final judul = (event['judul'] ?? '').toString().toLowerCase();
      final lokasi = (event['lokasi'] ?? '').toString().toLowerCase();
      final kategori = (event['kategori'] ?? '').toString().toLowerCase();
      final kodeTiket = (event['kodeTiket'] ?? '').toString().toLowerCase();
      return judul.contains(query) ||
          lokasi.contains(query) ||
          kategori.contains(query) ||
          kodeTiket.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF), // AdminColors.background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2630), // AdminColors.textBorder
                border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                ],
              ),
              child: const Text(
                'EVENTIFY',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 15,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF176), // AdminColors.yellowHero
                border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
              ),
              child: const Text(
                'KATALOG EVENT',
                style: TextStyle(
                  color: Color(0xFF2B2630),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Pencarian & Cek Tiket',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFA8E6CF), // AdminColors.mint
                border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                ],
              ),
              child: Icon(
                _isSearchExpanded ? Icons.close : Icons.search,
                color: const Color(0xFF2B2630),
                size: 18,
              ),
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _cariEventController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            tooltip: 'Admin Panel',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9EB1), // AdminColors.pink
                border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                ],
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, size: 18, color: Color(0xFF2B2630)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BAR PENCARIAN EVENT & CHECK TIKET
            UserSearchTicketBar(
              isExpanded: _isSearchExpanded,
              searchController: _cariEventController,
              kodeTiketController: _kodeTiketController,
              onSearchChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              onCariKodeTiket: () {
                if (_kodeTiketController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mencari Tiket: ${_kodeTiketController.text}')),
                  );
                }
              },
            ),

            // HERO BANNER NEOBRUTALISM
            const UserHeroBanner(),

            // LIST EVENT CARDS NEOBRUTALISM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: _filteredEvents.map((event) {
                  return UserEventCard(event: event);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Alias untuk kompatibilitas
typedef BerandaPage = Beranda;