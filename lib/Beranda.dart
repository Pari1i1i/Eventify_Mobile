import 'package:flutter/material.dart';
import 'detail.dart'; // Menghubungkan ke file detail.dart
import 'admin/admin_login.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final TextEditingController _kodeTiketController = TextEditingController();
  final TextEditingController _cariEventController = TextEditingController();
   
  // Data katalog event
  final List<Map<String, dynamic>> listEvent = [
    {
      'nomorEvent': 'EVENT #1',
      'status': 'TERSEDIA',
      'judul': 'Masterclass UI/UX: The Art of Neobrutalism Design',
      'deskripsi':
      'Workshop intensif belajar merancang antarmuka web modern dengan gaya Neobrutalism yang...',
      'tanggal': 'Rabu, 9 September 2026',
      'waktu': '23:16 - 05:16 WIB',
      'lokasi': 'Creative Hub Ruang 404, Bandung & Hybrid Zoom',
      'kuotaTerisi': 0,
      'totalKuota': 100,
      'warnaHeader': const Color(0xFFFFF275),
    },
    {
      'nomorEvent': 'EVENT #2',
      'status': 'SELESAI',
      'judul': 'Nusantara Soundwave Fest 2026',
      'tanggal': '18 - 19 Oktober 2026',
      'waktu': '15:00 - 23:00 WIB',
      'lokasi': 'GBK Senayan, Jakarta',
      'deskripsi': 'Konser musik lintas genre terbesar di pertengahan tahun 2026...',
      'kuotaTerisi': 500,
      'totalKuota': 500,
      'warnaHeader': const Color(0xFFC3B8E8),
    },
    {
      'nomorEvent': 'EVENT #3',
      'status': 'TERSEDIA',
      'judul': 'Tech & AI Innovators Expo',
      'tanggal': '05 November 2026',
      'waktu': '09:00 - 17:00 WIB',
      'lokasi': 'JCC Senayan, Jakarta',
      'deskripsi': 'Pameran teknologi terdepan menampilkan karya AI dan robotika terkini...',
      'kuotaTerisi': 150,
      'totalKuota': 300,
      'warnaHeader': const Color(0xFFB8E8C3),
    },
  ];

  @override
  void dispose() {
    _kodeTiketController.dispose();
    _cariEventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        elevation: 0,
        title: const Text(
          'EVENTIFY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2630),
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Tombol Masuk Admin Panel Neobrutalism di kanan atas
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF176),
                border: Border.all(color: const Color(0xFF2B2630), width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings, size: 14, color: Color(0xFF2B2630)),
                  SizedBox(width: 4),
                  Text(
                    'ADMIN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B2630),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xFF615983),
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER HERO UTAMA
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF176),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF2B2630), width: 3),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(5, 5)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Transform.rotate(
                      angle: 0.2,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9EB1),
                          border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 12,
                    child: Transform.rotate(
                      angle: -0.1,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA8E6CF),
                          border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
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
                          color: const Color(0xFF2B2630),
                          child: const Text(
                            'EVENT MANAGEMENT & E-TICKET QR SCANNER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'TEMUKAN EVENT PILIHAN,\nDAPATKAN TIKET DIGITAL QR!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2B2630),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Platform pendaftaran kegiatan seminar, workshop, dan kompetisi tanpa ribet. Daftar instan, dapatkan kode QR digital, dan tunjukkan saat check-in di lokasi.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2B2630),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isWide = constraints.maxWidth > 500;
                            return isWide
                                ? Row(
                              children: [
                                Expanded(child: _buildCariEventTextField()),
                                const SizedBox(width: 10),
                                _buildTemukanEventButton(),
                              ],
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildCariEventTextField(),
                                const SizedBox(height: 10),
                                _buildTemukanEventButton(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildStatCard('3', 'EVENT AKTIF', Colors.black)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildStatCard('0', 'PESERTA TERDAFTAR', Colors.red.shade700)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildStatCard('3', 'MENDATANG', Colors.teal.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Banner Cari Tiket (UUID)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFC7F9EE),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF2B2630), width: 3),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(4, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFF2B2630),
                    child: const Text(
                      'SUDAH MENDAFTAR?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lihat & Simpan Tiket Anda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B2630),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Masukkan kode tiket (UUID) yang Anda miliki untuk mengakses e-tiket dan kode QR check-in.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF2B2630)),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 500;
                      return isWide
                          ? Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                                ],
                              ),
                              child: TextField(
                                controller: _kodeTiketController,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'KODE TIKET (EVT-XXXX-XXXX)',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9EB1),
                                foregroundColor: const Color(0xFF2B2630),
                                side: const BorderSide(color: Color(0xFF2B2630), width: 2),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                elevation: 0,
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.search, size: 18),
                              label: const Text(
                                'Cari Tiket',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                              ],
                            ),
                            child: TextField(
                              controller: _kodeTiketController,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'KODE TIKET (EVT-XXXX-XXXX)',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9EB1),
                                foregroundColor: const Color(0xFF2B2630),
                                side: const BorderSide(color: Color(0xFF2B2630), width: 2),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                elevation: 0,
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.search, size: 18),
                              label: const Text(
                                'Cari Tiket',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Katalog Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2630),
              ),
            ),
            const SizedBox(height: 12),

            // Card Event
            ...listEvent.map((event) {
              int sisaKuota = event['totalKuota'] - event['kuotaTerisi'];
              double progress = event['kuotaTerisi'] / event['totalKuota'];

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF2B2630), width: 3),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF2B2630), offset: Offset(4, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CustomPaint(
                          painter: DotPatternPainter(color: event['warnaHeader']),
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
                                  border: Border.all(color: const Color(0xFF2B2630), width: 2),
                                ),
                                child: Text(
                                  event['judul'].toString().toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Color(0xFF2B2630),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            color: const Color(0xFF2B2630),
                            child: Text(
                              event['nomorEvent'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFF2B2630), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                              ],
                            ),
                            child: Text(
                              event['status'],
                              style: const TextStyle(
                                color: Color(0xFF2B2630),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
                          Text(
                            event['judul'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2B2630),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event['deskripsi'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFE0E0E0)),
                          const SizedBox(height: 16),

                          _buildInfoRow(
                            Icons.calendar_month,
                            event['tanggal'],
                            const Color(0xFFA8E6CF),
                          ),
                          const SizedBox(height: 10),

                          _buildInfoRow(
                            Icons.access_time_filled,
                            event['waktu'],
                            const Color(0xFFFFD3B6),
                          ),
                          const SizedBox(height: 10),

                          _buildInfoRow(
                            Icons.location_on,
                            event['lokasi'],
                            const Color(0xFFFFAAA5),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sisa Kuota:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B2630),
                                ),
                              ),
                              Text(
                                '$sisaKuota dari ${event['totalKuota']} Kursi',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2B2630),
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
                              border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                color: const Color(0xFF2B2630),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // NAVIGASI MEMANGGIL DETAIL.DART
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: event['warnaHeader'],
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
                                    'Detail & Registrasi',
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCariEventTextField() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
        ],
      ),
      child: TextField(
        controller: _cariEventController,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Cari nama event, topik, atau lokasi...',
          prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF2B2630)),
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
            borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildTemukanEventButton() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9EB1),
          foregroundColor: const Color(0xFF2B2630),
          side: const BorderSide(color: Color(0xFF2B2630), width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          elevation: 0,
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temukan Event',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2B2630), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2B2630),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconBgColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconBgColor,
            border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF2B2630)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B2630),
            ),
          ),
        ),
      ],
    );
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF2B2630).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const double spacing = 12.0;
    const double radius = 1.2;

    for (double x = 6; x < size.width; x += spacing) {
      for (double y = 6; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}