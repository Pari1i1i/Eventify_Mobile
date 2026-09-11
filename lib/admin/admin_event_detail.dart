import 'package:flutter/material.dart';
import 'data/admin_mock_data.dart';
import 'models/admin_models.dart';
import 'widgets/admin_shared_widgets.dart';
import 'admin_kelola_panitia.dart';

class AdminEventDetailPage extends StatelessWidget {
  final String eventId;

  const AdminEventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final dataService = AdminMockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final event = dataService.getEventById(eventId);

        if (event == null) {
          return Scaffold(
            backgroundColor: AdminColors.background,
            appBar: const AdminAppBar(showBackButton: true),
            body: Center(
              child: AdminCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AdminColors.textBorder),
                    const SizedBox(height: 12),
                    const Text('Event tidak ditemukan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    AdminButton(
                      label: 'KEMBALI KE DAFTAR',
                      onPressed: () => Navigator.pop(context),
                      fullWidth: false,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final int sisaKuota = event.totalKuota - event.kuotaTerisi;
        final double progressKuota = event.totalKuota > 0 ? event.kuotaTerisi / event.totalKuota : 0.0;

        return Scaffold(
          backgroundColor: AdminColors.background,
          appBar: AdminAppBar(
            showBackButton: true,
            onBack: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigasi breadcrumb / header info
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'DASHBOARD',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AdminColors.textBorder,
                        ),
                      ),
                    ),
                    const Text(
                      ' > ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AdminColors.textBorder),
                    ),
                    const Text(
                      'DETAIL EVENT (ADMIN READ-ONLY)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Responsive Layout: Kiri (Detail Event) & Kanan (Manajemen Admin)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isDesktop = constraints.maxWidth > 768;
                    return isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildKiriDetailEvent(event)),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: _buildKananManajemenEvent(
                                  context,
                                  event,
                                  sisaKuota,
                                  progressKuota,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildKiriDetailEvent(event),
                              const SizedBox(height: 20),
                              _buildKananManajemenEvent(
                                context,
                                event,
                                sisaKuota,
                                progressKuota,
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  // PANEL KIRI: Informasi Event (Read-Only)
  Widget _buildKiriDetailEvent(EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminColors.textBorder, width: 3),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomPaint(
                painter: DotPatternPainter(color: event.warnaHeader),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Text(
                        event.judul.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: AdminColors.textBorder,
                  child: Text(
                    event.nomorEvent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AdminColors.textBorder, width: 1.5),
                  ),
                  child: Text(
                    event.status,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textBorder,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: AdminColors.mint,
                  child: const Text(
                    'TIKET ELEKTRONIK & PRESENSI QR',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobileSmall = constraints.maxWidth < 340;
                    return isMobileSmall
                        ? Column(
                            children: [
                              _buildBoxDetail(
                                Icons.calendar_month,
                                'TANGGAL PELAKSANAAN',
                                event.tanggal,
                                AdminColors.yellowLight,
                              ),
                              const SizedBox(height: 8),
                              _buildBoxDetail(
                                Icons.access_time_filled,
                                'WAKTU / JAM',
                                event.waktu,
                                AdminColors.mint,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _buildBoxDetail(
                                  Icons.calendar_month,
                                  'TANGGAL PELAKSANAAN',
                                  event.tanggal,
                                  AdminColors.yellowLight,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildBoxDetail(
                                  Icons.access_time_filled,
                                  'WAKTU / JAM',
                                  event.waktu,
                                  AdminColors.mint,
                                ),
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 8),
                _buildBoxDetail(
                  Icons.location_on,
                  'LOKASI / TEMPAT',
                  event.lokasi,
                  AdminColors.pink,
                ),
                const SizedBox(height: 20),
                const Divider(color: AdminColors.textBorder, thickness: 1.5),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.notes, size: 18, color: AdminColors.textBorder),
                    SizedBox(width: 6),
                    Text(
                      'Deskripsi & Ketentuan Acara',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textBorder,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.deskripsi,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Topik Utama:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Perancangan Konsep Neobrutalism & Bold Visual Identity\n• Optimasi Sistem Presensi & QR Code Ticketing\n• Manajemen Kuota & Reporting Peserta',
                  style: TextStyle(fontSize: 11, height: 1.5, color: AdminColors.textBorder),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PANEL KANAN: Informasi Manajemen Event untuk Admin
  Widget _buildKananManajemenEvent(
    BuildContext context,
    EventModel event,
    int sisaKuota,
    double progressKuota,
  ) {
    final bool hasPanitia = event.panitiaEmail != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.yellowHero,
        border: Border.all(color: AdminColors.textBorder, width: 3),
        boxShadow: const [
          BoxShadow(color: AdminColors.textBorder, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MANAJEMEN EVENT & TIKET',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AdminColors.textBorder),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AdminColors.textBorder,
                child: const Text(
                  'ADMIN MODE',
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stat Ringkas Kuota
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AdminColors.textBorder, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STATUS KETERISIAN TIKET',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${event.kuotaTerisi} Terjual',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AdminColors.textBorder,
                      ),
                    ),
                    Text(
                      '$sisaKuota Kursi Sisa',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
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
                    widthFactor: progressKuota.clamp(0.0, 1.0),
                    child: Container(color: AdminColors.textBorder),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Total Kapasitas: ${event.totalKuota} Peserta (${(progressKuota * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Panel Status Penugasan Panitia
          const Text(
            'STATUS PENUGASAN PANITIA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AdminColors.textBorder,
            ),
          ),
          const SizedBox(height: 6),

          if (hasPanitia)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.mint,
                border: Border.all(color: AdminColors.textBorder, width: 2),
                boxShadow: const [
                  BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AdminColors.textBorder),
                      const SizedBox(width: 6),
                      Text(
                        'PANITIA AKTIF DITUGASKAN',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AdminColors.textBorder,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.panitiaNama ?? 'Panitia Event',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AdminColors.textBorder,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.panitiaEmail ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.textBorder,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminOutlineButton(
                    label: 'Ganti Panitia Lain',
                    icon: Icons.swap_horiz,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminKelolaPanitiaPage(
                            preselectedEventId: event.id,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AdminColors.textBorder, width: 2),
                boxShadow: const [
                  BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: Colors.grey.shade300,
                        child: const Text(
                          'BELUM ADA PANITIA',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.textBorder,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Event ini belum ditugaskan ke panitia manapun. Panitia bertugas mengelola presensi tiket QR dan check-in peserta.',
                    style: TextStyle(fontSize: 11, height: 1.4, color: AdminColors.textBorder),
                  ),
                  const SizedBox(height: 14),
                  AdminButton(
                    label: 'Tugaskan Panitia Sekarang',
                    icon: Icons.person_add,
                    backgroundColor: AdminColors.pink,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminKelolaPanitiaPage(
                            preselectedEventId: event.id,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          const Divider(color: AdminColors.textBorder, thickness: 1.5),
          const SizedBox(height: 8),
          const Text(
            'Catatan Admin: Fitur manajemen transaksi dan tiket peserta saat ini bersifat read-only pada fase MVP.',
            style: TextStyle(fontSize: 9, color: AdminColors.textBorder, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxDetail(IconData icon, String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AdminColors.textBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: AdminColors.textBorder, width: 1),
            ),
            child: Icon(icon, size: 14, color: AdminColors.textBorder),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textBorder,
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
