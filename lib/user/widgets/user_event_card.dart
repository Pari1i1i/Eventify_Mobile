import 'package:flutter/material.dart';
import '../detail.dart';
import 'event_banner_painters.dart';

/// Widget Kartu Event Bergaya Neobrutalism untuk Katalog User
class UserEventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const UserEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final int totalKuota = event['totalKuota'] ?? 100;
    final int kuotaTerisi = event['kuotaTerisi'] ?? 0;
    final int sisaKuota = totalKuota - kuotaTerisi;
    final double progress = totalKuota > 0 ? kuotaTerisi / totalKuota : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2B2630), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF2B2630), offset: Offset(5, 5)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailEventPage(eventData: event),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BANNER POSTER GAMBAR
            SizedBox(
              height: 180,
              width: double.infinity,
              child: buildEventBannerWidget(event),
            ),
            Container(
              height: 2,
              color: const Color(0xFF2B2630),
            ),

            // DESKRIPSI & DETIL INFORMASI EVENT
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BADGE TIKET ELEKTRONIK & KODE TIKET
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF176), // AdminColors.yellowHero
                          border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.confirmation_number, size: 14, color: Color(0xFF2B2630)),
                            const SizedBox(width: 4),
                            Text(
                              'KODE TIKET: ${event['kodeTiket'] ?? 'EVT-XXXX'}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2B2630),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA8E6CF), // AdminColors.mint
                          border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                        ),
                        child: Text(
                          (event['status'] ?? 'TERSEDIA').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2B2630),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DATE BADGE (KIRI) - OCT 11 / DEC 6
                      Container(
                        width: 58,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC3B8E8), // AdminColors.purpleLight
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2B2630), width: 2),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (event['bulan'] ?? 'OCT').toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF2B2630),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              event['hari'] ?? '11',
                              style: const TextStyle(
                                color: Color(0xFF2B2630),
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // CATEGORY, TIME, LOCATION (KANAN)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFA8E6CF),
                                border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                              ),
                              child: Text(
                                (event['kategori'] ?? 'SPORTS EVENT').toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF2B2630),
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
                                  color: Color(0xFF2B2630),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  event['waktu'] ?? '7:00AM',
                                  style: const TextStyle(
                                    color: Color(0xFF2B2630),
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
                                  color: Color(0xFF2B2630),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    event['lokasi'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF2B2630),
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

                  // EVENT TITLE
                  Text(
                    event['judul'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B2630),
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // HARGA TIKET & SISA KUOTA BADGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9EB1), // AdminColors.pink
                          border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                          ],
                        ),
                        child: Text(
                          'HARGA: ${event['harga'] ?? 'IDR 150.000'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Color(0xFF2B2630),
                          ),
                        ),
                      ),
                      Text(
                        '$sisaKuota Kursi Sisa',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2630),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(color: const Color(0xFF2B2630)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // BUTTON LIHAT DETAIL & TIKET NEOBRUTALISM
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF176),
                        foregroundColor: const Color(0xFF2B2630),
                        side: const BorderSide(color: Color(0xFF2B2630), width: 2),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailEventPage(eventData: event),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LIHAT DETAIL & TIKET',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
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
      ),
    );
  }
}
