import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusSopir { offline, online, bertugas, istirahat }

class SopirModel {
  final String id;
  final String nama;
  final String nomorHP;
  final String urlFoto;
  final String urlKtp;
  final String urlSim;
  final String urlStnk;
  final String urlKir;
  final String platNomor;
  final String jenisKendaraan;
  final String fotoKendaraan;
  final StatusSopir status;
  final double latitude;
  final double longitude;
  final DateTime? terakhirUpdateLokasi;
  final double rating;
  final int totalPengiriman;
  final int poinPelanggaran;
  final bool ditangguhkan;
  final DateTime dibuatPada;

  const SopirModel({
    required this.id,
    required this.nama,
    required this.nomorHP,
    required this.urlFoto,
    required this.urlKtp,
    required this.urlSim,
    required this.urlStnk,
    required this.urlKir,
    required this.platNomor,
    required this.jenisKendaraan,
    required this.fotoKendaraan,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.terakhirUpdateLokasi,
    required this.rating,
    required this.totalPengiriman,
    required this.poinPelanggaran,
    required this.ditangguhkan,
    required this.dibuatPada,
  });

  factory SopirModel.dariMap(
    Map<String, dynamic> map,
    String docId,
  ) => SopirModel(
    id: docId,
    nama: map['nama']?.toString() ?? '',
    nomorHP: map['nomorHP']?.toString() ?? '',
    urlFoto: map['urlFoto']?.toString() ?? '',
    urlKtp: map['urlKtp']?.toString() ?? '',
    urlSim: map['urlSim']?.toString() ?? '',
    urlStnk: map['urlStnk']?.toString() ?? '',
    urlKir: map['urlKir']?.toString() ?? '',
    platNomor: map['platNomor']?.toString() ?? '',
    jenisKendaraan: map['jenisKendaraan']?.toString() ?? 'Truk',
    fotoKendaraan: map['fotoKendaraan']?.toString() ?? '',
    status: StatusSopir.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => StatusSopir.offline,
    ),
    latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
    longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    terakhirUpdateLokasi: (map['terakhirUpdateLokasi'] as Timestamp?)?.toDate(),
    rating: (map['rating'] as num?)?.toDouble() ?? 0,
    totalPengiriman: (map['totalPengiriman'] as num?)?.toInt() ?? 0,
    poinPelanggaran: (map['poinPelanggaran'] as num?)?.toInt() ?? 0,
    ditangguhkan: map['ditangguhkan'] == true,
    dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
