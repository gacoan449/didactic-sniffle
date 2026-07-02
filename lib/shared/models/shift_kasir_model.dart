import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'shift_kasir_model.g.dart';

@HiveType(typeId: 3)
class ShiftKasirModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String kasirId;
  @HiveField(2)
  final String namaKasir;
  @HiveField(3)
  final String tokoId;
  @HiveField(4)
  final double saldoAwal;
  @HiveField(5)
  final double saldoAkhirSistem;
  @HiveField(6)
  final double saldoAkhirFisik;
  @HiveField(7)
  final double selisihKas;
  @HiveField(8)
  final double totalPenjualan;
  @HiveField(9)
  final double totalTunai;
  @HiveField(10)
  final double totalQris;
  @HiveField(11)
  final double totalTransfer;
  @HiveField(12)
  final double totalEwallet;
  @HiveField(13)
  final double totalDebit;
  @HiveField(14)
  final double totalKredit;
  @HiveField(15)
  final int jumlahTransaksi;
  @HiveField(16)
  final String status;
  @HiveField(17)
  final String catatan;
  @HiveField(18)
  final String disetujuiOleh;
  @HiveField(19)
  final DateTime mulaiPada;
  @HiveField(20)
  final DateTime? selesaiPada;

  const ShiftKasirModel({
    required this.id,
    required this.kasirId,
    required this.namaKasir,
    required this.tokoId,
    required this.saldoAwal,
    required this.saldoAkhirSistem,
    required this.saldoAkhirFisik,
    required this.selisihKas,
    required this.totalPenjualan,
    required this.totalTunai,
    required this.totalQris,
    required this.totalTransfer,
    required this.totalEwallet,
    required this.totalDebit,
    required this.totalKredit,
    required this.jumlahTransaksi,
    required this.status,
    required this.catatan,
    required this.disetujuiOleh,
    required this.mulaiPada,
    this.selesaiPada,
  });

  Map<String, dynamic> keMap() => {
    'kasirId': kasirId,
    'namaKasir': namaKasir,
    'tokoId': tokoId,
    'saldoAwal': saldoAwal,
    'saldoAkhirSistem': saldoAkhirSistem,
    'saldoAkhirFisik': saldoAkhirFisik,
    'selisihKas': selisihKas,
    'totalPenjualan': totalPenjualan,
    'totalTunai': totalTunai,
    'totalQris': totalQris,
    'totalTransfer': totalTransfer,
    'totalEwallet': totalEwallet,
    'totalDebit': totalDebit,
    'totalKredit': totalKredit,
    'jumlahTransaksi': jumlahTransaksi,
    'status': status,
    'catatan': catatan,
    'disetujuiOleh': disetujuiOleh,
    'mulaiPada': Timestamp.fromDate(mulaiPada),
    'selesaiPada': selesaiPada == null
        ? null
        : Timestamp.fromDate(selesaiPada!),
  };

  factory ShiftKasirModel.dariMap(Map<String, dynamic> map, String docId) =>
      ShiftKasirModel(
        id: docId,
        kasirId: map['kasirId']?.toString() ?? '',
        namaKasir: map['namaKasir']?.toString() ?? '',
        tokoId: map['tokoId']?.toString() ?? '',
        saldoAwal: (map['saldoAwal'] as num?)?.toDouble() ?? 0,
        saldoAkhirSistem: (map['saldoAkhirSistem'] as num?)?.toDouble() ?? 0,
        saldoAkhirFisik: (map['saldoAkhirFisik'] as num?)?.toDouble() ?? 0,
        selisihKas: (map['selisihKas'] as num?)?.toDouble() ?? 0,
        totalPenjualan: (map['totalPenjualan'] as num?)?.toDouble() ?? 0,
        totalTunai: (map['totalTunai'] as num?)?.toDouble() ?? 0,
        totalQris: (map['totalQris'] as num?)?.toDouble() ?? 0,
        totalTransfer: (map['totalTransfer'] as num?)?.toDouble() ?? 0,
        totalEwallet: (map['totalEwallet'] as num?)?.toDouble() ?? 0,
        totalDebit: (map['totalDebit'] as num?)?.toDouble() ?? 0,
        totalKredit: (map['totalKredit'] as num?)?.toDouble() ?? 0,
        jumlahTransaksi: (map['jumlahTransaksi'] as num?)?.toInt() ?? 0,
        status: map['status']?.toString() ?? 'aktif',
        catatan: map['catatan']?.toString() ?? '',
        disetujuiOleh: map['disetujuiOleh']?.toString() ?? '',
        mulaiPada: (map['mulaiPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
        selesaiPada: (map['selesaiPada'] as Timestamp?)?.toDate(),
      );
}

class AuditLogModel {
  final String id;
  final String userId;
  final String namaPengguna;
  final String aksi;
  final String modul;
  final String referensiId;
  final Map<String, dynamic> dataSebelum;
  final Map<String, dynamic> dataSesudah;
  final DateTime waktu;

  const AuditLogModel({
    required this.id,
    required this.userId,
    required this.namaPengguna,
    required this.aksi,
    required this.modul,
    required this.referensiId,
    required this.dataSebelum,
    required this.dataSesudah,
    required this.waktu,
  });

  Map<String, dynamic> keMap() => {
    'userId': userId,
    'namaPengguna': namaPengguna,
    'aksi': aksi,
    'modul': modul,
    'referensiId': referensiId,
    'dataSebelum': dataSebelum,
    'dataSesudah': dataSesudah,
    'waktu': Timestamp.fromDate(waktu),
  };
}
