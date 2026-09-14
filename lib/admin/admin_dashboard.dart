import 'package:flutter/material.dart';
import 'data/admin_mock_data.dart';
import 'widgets/admin_shared_widgets.dart';
import 'widgets/admin_event_card.dart';

class AdminDashboardPage extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const AdminDashboardPage({super.key, this.onNavigateTab});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataService = AdminMockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final allEvents = dataService.events;
        final filteredEvents = allEvents.where((e) {
          if (_searchQuery.isEmpty) return true;
          return e.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.lokasi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.nomorEvent.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: AdminColors.background,
          appBar: const AdminAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER HERO DASHBOARD ADMIN
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AdminColors.yellowHero,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AdminColors.textBorder, width: 3),
                    boxShadow: const [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(5, 5)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Aksesoris dekoratif neobrutalism
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AdminColors.pink,
                              border: Border.all(color: AdminColors.textBorder, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -8,
                        right: 18,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AdminColors.mint,
                              border: Border.all(color: AdminColors.textBorder, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: AdminColors.textBorder,
                              child: const Text(
                                'ADMINISTRATOR CONTROL DESK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'DASHBOARD ADMIN',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AdminColors.textBorder,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Pantau status seluruh event, kuota peserta, serta penugasan akun panitia penyelenggara dalam satu kontrol terpadu.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AdminColors.textBorder,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 3 STAT CARD (REUSE POLA BERANDA.DART)
                            Row(
                              children: [
                                Expanded(
                                  child: AdminStatCard(
                                    value: '${dataService.totalEvent}',
                                    label: 'TOTAL EVENT',
                                    valueColor: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AdminStatCard(
                                    value: '${dataService.eventAktif}',
                                    label: 'EVENT AKTIF',
                                    valueColor: Colors.teal.shade800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AdminStatCard(
                                    value: '${dataService.totalPanitiaTerdaftar}',
                                    label: 'PANITIA TERDAFTAR',
                                    valueColor: Colors.deepPurple.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // BAR PENCARIAN EVENT & FILTER
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(3, 3)),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Cari event berdasarkan judul atau lokasi...',
                      prefixIcon: const Icon(Icons.search, size: 18, color: AdminColors.textBorder),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16, color: AdminColors.textBorder),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: AdminColors.textBorder, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: AdminColors.textBorder, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // SECTION TITLE: DAFTAR EVENT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Semua Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textBorder,
                      ),
                    ),
                    Text(
                      '${filteredEvents.length} Event Ditemukan',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // LIST EVENT CARDS DENGAN GAYA NEOBRUTALISM
                if (filteredEvents.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AdminColors.textBorder, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'Tidak ada event yang cocok dengan kata kunci pencarian.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...filteredEvents.map((event) => AdminEventCard(event: event)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
