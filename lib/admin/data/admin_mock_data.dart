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
        judul: 'Masterclass UI/UX: The Art of Neobrutalism Design',
        deskripsi:
            'Workshop intensif belajar merancang antarmuka web modern dengan gaya Neobrutalism yang memadukan kontras tinggi dan micro-interaction tegas.',
        tanggal: 'Rabu, 9 September 2026',
        waktu: '23:16 - 05:16 WIB',
        lokasi: 'Creative Hub Ruang 404, Bandung & Hybrid Zoom',
        totalKuota: 100,
        kuotaTerisi: 0,
        warnaHeader: const Color(0xFFFFF275),
        panitiaEmail: null,
        panitiaNama: null,
      ),
      EventModel(
        id: 'evt-2',
        nomorEvent: 'EVENT #2',
        status: 'SELESAI',
        judul: 'Nusantara Soundwave Fest 2026',
        deskripsi:
            'Konser musik lintas genre terbesar di pertengahan tahun 2026 yang menghadirkan puluhan musisi nasional dan visual panggung spektakuler.',
        tanggal: '18 - 19 Oktober 2026',
        waktu: '15:00 - 23:00 WIB',
        lokasi: 'GBK Senayan, Jakarta',
        totalKuota: 500,
        kuotaTerisi: 500,
        warnaHeader: const Color(0xFFC3B8E8),
        panitiaEmail: 'budi.soundwave@eventify.id',
        panitiaNama: 'Budi Santoso',
      ),
      EventModel(
        id: 'evt-3',
        nomorEvent: 'EVENT #3',
        status: 'TERSEDIA',
        judul: 'Tech & AI Innovators Expo',
        deskripsi:
            'Pameran teknologi terdepan menampilkan karya Artificial Intelligence, robotika otonom, dan IoT dari startup terbaik se-Asia Tenggara.',
        tanggal: '05 November 2026',
        waktu: '09:00 - 17:00 WIB',
        lokasi: 'JCC Senayan, Jakarta',
        totalKuota: 300,
        kuotaTerisi: 150,
        warnaHeader: const Color(0xFFB8E8C3),
        panitiaEmail: null,
        panitiaNama: null,
      ),
      EventModel(
        id: 'evt-4',
        nomorEvent: 'EVENT #4',
        status: 'AKAN DATANG',
        judul: 'National Cybersecurity & CTF Tournament 2026',
        deskripsi:
            'Kompetisi capture the flag dan seminar keamanan siber tingkat nasional bagi para ethical hacker dan praktisi infosec.',
        tanggal: '22 Desember 2026',
        waktu: '08:00 - 16:00 WIB',
        lokasi: 'Cyber Arena, Gedung Fasilkom UI, Depok',
        totalKuota: 200,
        kuotaTerisi: 45,
        warnaHeader: const Color(0xFFFFAAA5),
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
