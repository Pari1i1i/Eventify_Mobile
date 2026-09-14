import 'package:flutter/material.dart';
import '../admin_event_detail.dart';
import '../models/admin_models.dart';
import 'admin_shared_widgets.dart';

/// Widget Kartu Event Khusus Dashboard Admin
class AdminEventCard extends StatelessWidget {
  final EventModel event;

  const AdminEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
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
                // BADGES: PANITIA & KODE TIKET FORMAT USER
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AdminColors.yellowHero,
                        border: Border.all(color: AdminColors.textBorder, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.confirmation_number, size: 14, color: AdminColors.textBorder),
                          const SizedBox(width: 4),
                          Text(
                            'KODE TIKET: ${event.kodeTiket}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AdminColors.textBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // BARIS TIKET: BOX TANGGAL (KIRI) & INFORMASI KATEGORI/WAKTU (KANAN)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DATE BADGE BOX SAMA SEPERTI USER TIKET
                    Container(
                      width: 58,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AdminColors.purpleLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AdminColors.textBorder, width: 2),
                        boxShadow: const [
                          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            event.bulan.toUpperCase(),
                            style: const TextStyle(
                              color: AdminColors.textBorder,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.hari,
                            style: const TextStyle(
                              color: AdminColors.textBorder,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // KATEGORI, WAKTU & LOKASI
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AdminColors.mint,
                              border: Border.all(color: AdminColors.textBorder, width: 1.5),
                            ),
                            child: Text(
                              event.kategori.toUpperCase(),
                              style: const TextStyle(
                                color: AdminColors.textBorder,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled,
                                size: 14,
                                color: AdminColors.textBorder,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                event.waktu,
                                style: const TextStyle(
                                  color: AdminColors.textBorder,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AdminColors.textBorder,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.lokasi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AdminColors.textBorder,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Judul Event
                Text(
                  event.judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AdminColors.textBorder,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event.deskripsi,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // HARGA TIKET BADGE FORMAT USER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AdminColors.pink,
                        border: Border.all(color: AdminColors.textBorder, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: AdminColors.textBorder, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Text(
                        'HARGA: ${event.harga}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: AdminColors.textBorder,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AdminColors.divider),
                const SizedBox(height: 14),

                // Bar Progres Kuota Tiket
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sisa Kuota Tiket:',
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

                // TOMBOL: "Lihat Detail"
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
