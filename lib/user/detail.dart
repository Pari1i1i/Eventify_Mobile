import 'package:flutter/material.dart';
import 'widgets/event_banner_painters.dart';

class DetailEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const DetailEventPage({super.key, required this.eventData});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller Form Pendaftaran
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _waController = TextEditingController();
  final _instansiController = TextEditingController();
  int _jumlahTiket = 1;

  // Data Event Lainnya (3 Event bisa digeser ke samping)
  final List<Map<String, String>> eventLainnya = [
    {
      'tanggal': '22 SEPTEMBER 2026',
      'judul': 'National Cybersecurity & CTF Tournament 2026',
      'lokasi': 'Cyber Arena, Gedung Fasilkom UI, Depok',
      'warnaHeader': '0xFFFFF275',
    },
    {
      'nomor': 'EVENT #2',
      'tanggal': '12 DESEMBER 2026',
      'judul': 'Indie Art & Creative Market 2026',
      'lokasi': 'Mbloc Space, Jakarta Selatan',
      'warnaHeader': '0xFFE8C3B8',
    },
    {
      'nomor': 'EVENT #3',
      'tanggal': '20 DESEMBER 2026',
      'judul': 'National Game Dev & AI Workshop',
      'lokasi': 'Grand Indonesia, Jakarta Pusat',
      'warnaHeader': '0xFFB8E8C3',
    },
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _waController.dispose();
    _instansiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalKuota = widget.eventData['totalKuota'] ?? 100;
    int kuotaTerisi = widget.eventData['kuotaTerisi'] ?? 0;
    int sisaKuota = totalKuota - kuotaTerisi;
    double progressKuota = totalKuota > 0 ? kuotaTerisi / totalKuota : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B2630)),
        title: const Text(
          'EVENTIFY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2630),
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LAYOUT RESPONSIF: KIRI & KANAN
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 768;
                      return isDesktop
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildKiriDetailEvent(sisaKuota, totalKuota)),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: _buildKananFormPendaftaran(sisaKuota, totalKuota, progressKuota)),
                        ],
                      )
                          : Column(
                        children: [
                          _buildKiriDetailEvent(sisaKuota, totalKuota),
                          const SizedBox(height: 20),
                          _buildKananFormPendaftaran(sisaKuota, totalKuota, progressKuota),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // SECTION: EVENT LAINNYA YANG MENARIK (Garis Horisontal BISA DIGESER KE SAMPING)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'EVENT LAINNYA YANG MENARIK',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2B2630)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('LIHAT SEMUA >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2B2630))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // List Horizontal 3 Event
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventLainnya.length,
                      itemBuilder: (context, index) {
                        final item = eventLainnya[index];
                        return Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 14, bottom: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF2B2630), width: 2),
                            boxShadow: const [BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    color: Color(int.parse(item['warnaHeader']!)),
                                    child: Text(
                                      item['tanggal']!,
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['judul']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['lokasi']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF2B2630), width: 1.5),
                                  minimumSize: const Size(double.infinity, 30),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {},
                                child: const Text('Lihat Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2B2630))),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KIRI: INFORMASI EVENT
  Widget _buildKiriDetailEvent(int sisaKuota, int totalKuota) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2B2630), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF2B2630), offset: Offset(4, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomPaint(
                painter: DotPatternPainter(color: widget.eventData['warnaHeader'] ?? const Color(0xFFFFF275)),
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
                        (widget.eventData['judul'] ?? '').toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF2B2630)),
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
                  color: const Color(0xFF2B2630),
                  child: const Text('EVENTIFY OFFICIAL', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF2B2630), width: 1.5)),
                  child: Text(widget.eventData['status'] ?? 'AKAN DATANG', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
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
                  color: const Color(0xFFA8E6CF),
                  child: const Text('TIKET ELEKTRONIK & PRESENSI QR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.eventData['judul'] ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2B2630)),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobileSmall = constraints.maxWidth < 340;
                    return isMobileSmall
                        ? Column(
                      children: [
                        _buildBoxDetail(Icons.calendar_month, 'TANGGAL PELAKSANAAN', widget.eventData['tanggal'] ?? 'Rabu, 9 September 2026', const Color(0xFFFFF275)),
                        const SizedBox(height: 8),
                        _buildBoxDetail(Icons.access_time_filled, 'WAKTU / JAM', widget.eventData['waktu'] ?? '09:00 - 17:00 WIB', const Color(0xFFA8E6CF)),
                      ],
                    )
                        : Row(
                      children: [
                        Expanded(child: _buildBoxDetail(Icons.calendar_month, 'TANGGAL PELAKSANAAN', widget.eventData['tanggal'] ?? 'Rabu, 9 September 2026', const Color(0xFFFFF275))),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBoxDetail(Icons.access_time_filled, 'WAKTU / JAM', widget.eventData['waktu'] ?? '09:00 - 17:00 WIB', const Color(0xFFA8E6CF))),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildBoxDetail(Icons.location_on, 'LOKASI / TEMPAT', widget.eventData['lokasi'] ?? 'Creative Hub Ruang 404, Bandung & Hybrid Zoom', const Color(0xFFFF9EB1)),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF2B2630), thickness: 1.5),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.notes, size: 18),
                    SizedBox(width: 6),
                    Text('Deskripsi & Ketentuan Acara', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.eventData['deskripsi'] ?? 'Konferensi teknologi terbesar tahun ini yang mempertemukan para inovator Artificial Intelligence, arsitek Cloud Computing, dan tech leaders internasional.',
                  style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black),
                ),
                const SizedBox(height: 12),
                const Text('Topik Utama:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Text('• Building Resilient Generative AI Pipelines\n• Enterprise Multi-Cloud Architecture & Kubernetes\n• Zero-Trust Security & DevSecOps Mastery', style: TextStyle(fontSize: 11, height: 1.5)),
                const SizedBox(height: 12),
                const Text('Fasilitas: E-Certificate, Snack & Lunch, Goodie Bag eksklusif, dan akses networking dengan 500+ profesional.', style: TextStyle(fontSize: 11, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET KANAN: FORM PENDAFTARAN PESERTA
  Widget _buildKananFormPendaftaran(int sisaKuota, int totalKuota, double progressKuota) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF176),
        border: Border.all(color: const Color(0xFF2B2630), width: 3),
        boxShadow: const [BoxShadow(color: Color(0xFF2B2630), offset: Offset(4, 4))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('FORM PENDAFTARAN PESERTA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: const Color(0xFF2B2630),
                  child: const Text('GRATIS', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sisa Kuota:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text('$sisaKuota Kursi Tersedia', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF2B2630), width: 1)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressKuota > 1 ? 1 : progressKuota,
                child: Container(color: const Color(0xFF2B2630)),
              ),
            ),
            const SizedBox(height: 16),
            _buildLabelForm('NAMA LENGKAP PESERTA *'),
            _buildTextFieldForm(_namaController, 'Contoh: Muhammad Ramdan'),
            const SizedBox(height: 12),
            _buildLabelForm('ALAMAT EMAIL AKTIF *'),
            _buildTextFieldForm(_emailController, 'nama@domain.com'),
            const SizedBox(height: 12),
            _buildLabelForm('NOMOR WHATSAPP / HP *'),
            _buildTextFieldForm(_waController, '081234567890'),
            const SizedBox(height: 12),
            _buildLabelForm('JUMLAH TIKET *'),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (_jumlahTiket > 1) setState(() => _jumlahTiket--);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF2B2630), width: 2)),
                    child: const Center(child: Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF2B2630), width: 2)),
                    child: Center(child: Text('$_jumlahTiket', style: const TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _jumlahTiket++);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF2B2630), width: 2)),
                    child: const Center(child: Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLabelForm('INSTANSI / PERUSAHAAN / KELAS'),
            _buildTextFieldForm(_instansiController, 'Contoh: Universitas Indonesia / PT ABC'),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Color(0xFF2B2630), offset: Offset(3, 3))]),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9EB1),
                  foregroundColor: const Color(0xFF2B2630),
                  side: const BorderSide(color: Color(0xFF2B2630), width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pendaftaran Berhasil! Kode QR Tiket sedang dibuat.')),
                    );
                  }
                },
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Daftar & Dapatkan Tiket QR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Tiket otomatis di-generate setelah formulir dikirimkan.', style: TextStyle(fontSize: 9, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: BOX INFORMASI DETAIL
  Widget _buildBoxDetail(IconData icon, String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: bgColor, border: Border.all(color: const Color(0xFF2B2630), width: 1)),
            child: Icon(icon, size: 14, color: const Color(0xFF2B2630)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2B2630))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: LABEL FORM
  Widget _buildLabelForm(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF2B2630))),
    );
  }

  // WIDGET HELPER: TEXT FIELD FORM
  Widget _buildTextFieldForm(TextEditingController controller, String hint) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2))]),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Wajib diisi';
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFF2B2630), width: 1.5)),
          focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Color(0xFF2B2630), width: 1.5)),
        ),
      ),
    );
  }
}