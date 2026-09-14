import 'package:flutter/material.dart';
import '../models/admin_models.dart';

class AdminMockDataService extends ChangeNotifier {
  // Singleton pattern
  static final AdminMockDataService _instance = AdminMockDataService._internal();
  factory AdminMockDataService() => _instance;
  AdminMockDataService._internal() {
    _initData();
  }

  late List<EventModel> _events;
  late List<PanitiaAccountModel> _panitiaList;

  List<EventModel> get events => List.unmodifiable(_events);
  List<PanitiaAccountModel> get panitiaList => List.unmodifiable(_panitiaList);

  int get totalEvent => _events.length;
  int get eventAktif => _events.where((e) => e.status != 'SELESAI').length;
  int get totalPanitiaTerdaftar => _panitiaList.length;

  void _initData() {
    _events = [
      EventModel(
        id: 'evt-1',
        nomorEvent: 'EVENT #1',
        status: 'TERSEDIA',
        judul: '8Finity Charity Fun Run 2026',
        deskripsi:
            'Infinite Steps, Endless Love. Lari maraton charity terbesar tahun 2026 di Jodjokodi Convention Center (JCC). Dapatkan jersey eksklusif, medali finisher, dan snack box!',
        tanggal: 'Minggu, 11 Oktober 2026',
        waktu: '7:00AM',
        lokasi: 'Jodjokodi Convention Center (JCC)',
        totalKuota: 500,
        kuotaTerisi: 350,
        warnaHeader: const Color(0xFFFFF275),
        kategori: 'SPORTS EVENT',
        harga: 'IDR 150.000',
        bulan: 'OCT',
        hari: '11',
        kodeTiket: 'EVT-8F2026',
        panitiaEmail: null,
        panitiaNama: null,
      ),
      EventModel(
        id: 'evt-2',
        nomorEvent: 'EVENT #2',
        status: 'TERSEDIA',
        judul: 'Pushbike Competition Ride Race Fun 2026',
        deskripsi:
            'Ride • Race • Fun! Kompetisi sepeda keseimbangan anak tingkat nasional di Area Parkir Bandara Trunojoyo Sumenep. Berhadiah piala, piagam, dan medali finisher.',
        tanggal: 'Minggu, 6 Desember 2026',
        waktu: '08:00AM',
        lokasi: 'Area Parkir Bandara Trunojoyo Sumenep',
        totalKuota: 100,
        kuotaTerisi: 80,
        warnaHeader: const Color(0xFFC3B8E8),
        kategori: 'SPORTS EVENT',
        harga: 'IDR 50.000',
        bulan: 'DEC',
        hari: '6',
        kodeTiket: 'EVT-PB2026',
        panitiaEmail: 'budi.soundwave@eventify.id',
        panitiaNama: 'Budi Santoso',
      ),
      EventModel(
        id: 'evt-3',
        nomorEvent: 'EVENT #3',
        status: 'TERSEDIA',
        judul: 'Tech & AI Innovators Expo 2026',
        deskripsi:
            'Pameran teknologi terdepan menampilkan karya Artificial Intelligence, robotika otonom, dan IoT dari startup terbaik se-Asia Tenggara.',
        tanggal: 'Kamis, 5 November 2026',
        waktu: '9:00AM',
        lokasi: 'JCC Senayan, Jakarta',
        totalKuota: 300,
        kuotaTerisi: 150,
        warnaHeader: const Color(0xFFB8E8C3),
        kategori: 'TECH EVENT',
        harga: 'IDR 100.000',
        bulan: 'NOV',
        hari: '5',
        kodeTiket: 'EVT-TC2026',
        panitiaEmail: null,
        panitiaNama: null,
      ),
      EventModel(
        id: 'evt-4',
        nomorEvent: 'EVENT #4',
        status: 'AKAN DATANG',
        judul: 'Masterclass UI/UX: The Art of Neobrutalism Design',
        deskripsi:
            'Workshop intensif merancang antarmuka web dan mobile modern dengan konsep Neobrutalism terkini bersama profesional industri.',
        tanggal: 'Rabu, 9 September 2026',
        waktu: '1:00PM',
        lokasi: 'Creative Hub Ruang 404, Bandung & Hybrid Zoom',
        totalKuota: 100,
        kuotaTerisi: 45,
        warnaHeader: const Color(0xFFFFAAA5),
        kategori: 'DESIGN WORKSHOP',
        harga: 'IDR 75.000',
        bulan: 'SEP',
        hari: '9',
        kodeTiket: 'EVT-UI2026',
        panitiaEmail: null,
        panitiaNama: null,
      ),
    ];

    _panitiaList = [
      PanitiaAccountModel(
        id: 'pnt-1',
        nama: 'Budi Santoso',
        email: 'budi.soundwave@eventify.id',
        password: 'PassSoundwave2026!',
        eventId: 'evt-2',
        eventJudul: 'Nusantara Soundwave Fest 2026',
        tanggalDibuat: DateTime(2026, 8, 15, 10, 30),
      ),
    ];
  }

  EventModel? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  PanitiaAccountModel? getPanitiaByEventId(String eventId) {
    try {
      return _panitiaList.firstWhere((p) => p.eventId == eventId);
    } catch (_) {
      return null;
    }
  }

  /// Membuat akun panitia baru dan menautkannya ke event yang dipilih.
  /// Jika event sebelumnya sudah memiliki panitia lain, akun lama akan dilepas tautannya.
  bool tambahPanitia({
    required String nama,
    required String email,
    required String password,
    required String eventId,
  }) {
    final eventIndex = _events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) return false;

    final targetEvent = _events[eventIndex];

    // Hapus panitia lama jika ada yang terhubung dengan event ini
    _panitiaList.removeWhere((p) => p.eventId == eventId);

    final newPanitia = PanitiaAccountModel(
      id: 'pnt-${DateTime.now().millisecondsSinceEpoch}',
      nama: nama.trim(),
      email: email.trim(),
      password: password,
      eventId: eventId,
      eventJudul: targetEvent.judul,
      tanggalDibuat: DateTime.now(),
    );

    _panitiaList.insert(0, newPanitia);

    // Update event dengan panitia baru
    _events[eventIndex] = targetEvent.copyWith(
      panitiaEmail: newPanitia.email,
      panitiaNama: newPanitia.nama,
    );

    notifyListeners();
    return true;
  }

  /// Menghapus akun panitia dan melepaskan penugasan pada event terkait
  bool hapusPanitia(String panitiaId) {
    final index = _panitiaList.indexWhere((p) => p.id == panitiaId);
    if (index == -1) return false;

    final panitia = _panitiaList[index];
    final eventIndex = _events.indexWhere((e) => e.id == panitia.eventId);

    if (eventIndex != -1) {
      _events[eventIndex] = _events[eventIndex].copyWith(clearPanitia: true);
    }

    _panitiaList.removeAt(index);
    notifyListeners();
    return true;
  }

  /// Reset password untuk panitia tertentu
  bool resetPassword(String panitiaId, String newPassword) {
    final index = _panitiaList.indexWhere((p) => p.id == panitiaId);
    if (index == -1) return false;

    _panitiaList[index] = _panitiaList[index].copyWith(password: newPassword);
    notifyListeners();
    return true;
  }
}
