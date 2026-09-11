import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String nomorEvent;
  final String judul;
  final String deskripsi;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String status; // TERSEDIA / SELESAI / AKAN DATANG
  final int totalKuota;
  final int kuotaTerisi;
  final Color warnaHeader;
  final String? panitiaEmail; // null jika belum ada panitia ditugaskan
  final String? panitiaNama;

  EventModel({
    required this.id,
    required this.nomorEvent,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.status,
    required this.totalKuota,
    required this.kuotaTerisi,
    required this.warnaHeader,
    this.panitiaEmail,
    this.panitiaNama,
  });

  EventModel copyWith({
    String? id,
    String? nomorEvent,
    String? judul,
    String? deskripsi,
    String? tanggal,
    String? waktu,
    String? lokasi,
    String? status,
    int? totalKuota,
    int? kuotaTerisi,
    Color? warnaHeader,
    String? panitiaEmail,
    bool clearPanitia = false,
    String? panitiaNama,
  }) {
    return EventModel(
      id: id ?? this.id,
      nomorEvent: nomorEvent ?? this.nomorEvent,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      tanggal: tanggal ?? this.tanggal,
      waktu: waktu ?? this.waktu,
      lokasi: lokasi ?? this.lokasi,
      status: status ?? this.status,
      totalKuota: totalKuota ?? this.totalKuota,
      kuotaTerisi: kuotaTerisi ?? this.kuotaTerisi,
      warnaHeader: warnaHeader ?? this.warnaHeader,
      panitiaEmail: clearPanitia ? null : (panitiaEmail ?? this.panitiaEmail),
      panitiaNama: clearPanitia ? null : (panitiaNama ?? this.panitiaNama),
    );
  }
}

class PanitiaAccountModel {
  final String id;
  final String nama;
  final String email;
  final String password; // dummy untuk MVP
  final String eventId;
  final String eventJudul;
  final DateTime tanggalDibuat;

  PanitiaAccountModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.eventId,
    required this.eventJudul,
    required this.tanggalDibuat,
  });

  PanitiaAccountModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? password,
    String? eventId,
    String? eventJudul,
    DateTime? tanggalDibuat,
  }) {
    return PanitiaAccountModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      password: password ?? this.password,
      eventId: eventId ?? this.eventId,
      eventJudul: eventJudul ?? this.eventJudul,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    );
  }
}
