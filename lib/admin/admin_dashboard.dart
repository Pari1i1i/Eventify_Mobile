import 'package:flutter/material.dart';
import 'data/admin_mock_data.dart';
import 'models/admin_models.dart';
import 'widgets/admin_shared_widgets.dart';
import 'admin_event_detail.dart';

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
                  ...filteredEvents.map((event) => _buildEventCard(context, event)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // WIDGET KARTU EVENT UNTUK ADMIN
  Widget _buildEventCard(BuildContext context, EventModel event) {
    final int sisaKuota = event.totalKuota - event.kuotaTerisi;
    final double progress = event.totalKuota > 0 ? event.kuotaTerisi / event.totalKuota : 0.0;
    final bool hasPanitia = event.panitiaEmail != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AdminColors.textBorder, width: 3),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Event dengan Dot Pattern Painter
          Stack(
            children: [
              CustomPaint(
                painter: DotPatternPainter(color: event.warnaHeader),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AdminColors.textBorder, width: 2),
                      ),
                      child: Text(
                        event.judul.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: AdminColors.textBorder,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Badge Nomor Event di Kiri Atas
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: AdminColors.textBorder,
                  child: Text(
                    event.nomorEvent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Badge Status di Kanan Atas
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AdminColors.textBorder, width: 2),
                    boxShadow: const [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Text(
                    event.status,
                    style: const TextStyle(
                      color: AdminColors.textBorder,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Isi Konten Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BADGE PENUGASAN PANITIA (Wajib sesuai spesifikasi 4.2)
                hasPanitia
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AdminColors.mintLight,
                          border: Border.all(color: AdminColors.textBorder, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, size: 14, color: AdminColors.textBorder),
                            const SizedBox(width: 4),
                            Text(
                              'PANITIA: ${event.panitiaNama ?? event.panitiaEmail}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AdminColors.textBorder,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: AdminColors.textBorder, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_off_outlined, size: 14, color: AdminColors.textBorder),
                            SizedBox(width: 4),
                            Text(
                              'BELUM ADA PANITIA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AdminColors.textBorder,
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 10),

                // Judul Event
                Text(
                  event.judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.deskripsi,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AdminColors.divider),
                const SizedBox(height: 16),

                // Info Baris: Tanggal, Waktu, Lokasi
                AdminInfoRow(
                  icon: Icons.calendar_month,
                  text: event.tanggal,
                  iconBgColor: AdminColors.mint,
                ),
                const SizedBox(height: 10),

                AdminInfoRow(
                  icon: Icons.access_time_filled,
                  text: event.waktu,
                  iconBgColor: AdminColors.orange,
                ),
                const SizedBox(height: 10),

                AdminInfoRow(
                  icon: Icons.location_on,
                  text: event.lokasi,
                  iconBgColor: AdminColors.pinkLight,
                ),
                const SizedBox(height: 20),

                // Bar Progres Kuota
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sisa Kuota:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textBorder,
                      ),
                    ),
                    Text(
                      '$sisaKuota dari ${event.totalKuota} Kursi',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AdminColors.textBorder,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: AdminColors.textBorder, width: 1.5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(color: AdminColors.textBorder),
                  ),
                ),
                const SizedBox(height: 20),

                // TOMBOL: "Lihat Detail" (Sesuai spesifikasi 4.2)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: AdminColors.textBorder, offset: Offset(3, 3)),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: event.warnaHeader,
                      foregroundColor: AdminColors.textBorder,
                      side: const BorderSide(color: AdminColors.textBorder, width: 2),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEventDetailPage(eventId: event.id),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
