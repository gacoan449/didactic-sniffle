import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'gudang_model.g.dart';

@HiveType(typeId: 21)
class GudangModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nama;
  @HiveField(2)
  final String alamatLengkap;
  @HiveField(3)
  final String pengelolaId;
  @HiveField(4)
  final String lokasiRak;
  @HiveField(5)
  final int totalStok;
  @HiveField(6)
  final int barangMasukHariIni;
  @HiveField(7)
  final int barangKeluarHariIni;
  @HiveField(8)
  final int barangRusak;
  @HiveField(9)
  final int returCount;
  @HiveField(10)
  final int expiredCount;
  @HiveField(11)
  final String barcodeGudang;
  @HiveField(12)
  final DateTime? tanggalAuditTerakhir;
  @HiveField(13)
  final bool aktif;

  const GudangModel({
    required this.id,
    required this.nama,
    required this.alamatLengkap,
    required this.pengelolaId,
    required this.lokasiRak,
    required this.totalStok,
    required this.barangMasukHariIni,
    required this.barangKeluarHariIni,
    required this.barangRusak,
    required this.returCount,
    required this.expiredCount,
    required this.barcodeGudang,
    this.tanggalAuditTerakhir,
    required this.aktif,
  });

  Map<String, dynamic> keMap() => {
    'nama': nama,
    'alamatLengkap': alamatLengkap,
    'pengelolaId': pengelolaId,
    'lokasiRak': lokasiRak,
    'totalStok': totalStok,
    'barangMasukHariIni': barangMasukHariIni,
    'barangKeluarHariIni': barangKeluarHariIni,
    'barangRusak': barangRusak,
    'returCount': returCount,
    'expiredCount': expiredCount,
    'barcodeGudang': barcodeGudang,
    'tanggalAuditTerakhir': tanggalAuditTerakhir != null
        ? Timestamp.fromDate(tanggalAuditTerakhir!)
        : null,
    'aktif': aktif,
  };

  factory GudangModel.dariMap(Map<String, dynamic> m, String docId) =>
      GudangModel(
        id: docId,
        nama: m['nama'] ?? '',
        alamatLengkap: m['alamatLengkap'] ?? '',
        pengelolaId: m['pengelolaId'] ?? '',
        lokasiRak: m['lokasiRak'] ?? '',
        totalStok: (m['totalStok'] as num?)?.toInt() ?? 0,
        barangMasukHariIni: (m['barangMasukHariIni'] as num?)?.toInt() ?? 0,
        barangKeluarHariIni: (m['barangKeluarHariIni'] as num?)?.toInt() ?? 0,
        barangRusak: (m['barangRusak'] as num?)?.toInt() ?? 0,
        returCount: (m['returCount'] as num?)?.toInt() ?? 0,
        expiredCount: (m['expiredCount'] as num?)?.toInt() ?? 0,
        barcodeGudang: m['barcodeGudang'] ?? '',
        tanggalAuditTerakhir: (m['tanggalAuditTerakhir'] as Timestamp?)
            ?.toDate(),
        aktif: m['aktif'] == true,
      );
}
