import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'wallet_transaksi_model.g.dart';

enum JenisTransaksiDompet {
  isiSaldo,
  bayarPesanan,
  terimaTransfer,
  kirimTransfer,
  tarikSaldo,
  potongan,
}

@HiveType(typeId: 19)
class WalletTransaksiModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String penggunaId;
  @HiveField(2)
  final JenisTransaksiDompet jenis;
  @HiveField(3)
  final double jumlah;
  @HiveField(4)
  final double saldoSebelum;
  @HiveField(5)
  final double saldoSesudah;
  @HiveField(6)
  final String keterangan;
  @HiveField(7)
  final String? referensiId;
  @HiveField(8)
  final DateTime dibuatPada;

  const WalletTransaksiModel({
    required this.id,
    required this.penggunaId,
    required this.jenis,
    required this.jumlah,
    required this.saldoSebelum,
    required this.saldoSesudah,
    required this.keterangan,
    this.referensiId,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    'penggunaId': penggunaId,
    'jenis': jenis.name,
    'jumlah': jumlah,
    'saldoSebelum': saldoSebelum,
    'saldoSesudah': saldoSesudah,
    'keterangan': keterangan,
    'referensiId': referensiId,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
  };

  factory WalletTransaksiModel.dariMap(Map<String, dynamic> m, String docId) =>
      WalletTransaksiModel(
        id: docId,
        penggunaId: m['penggunaId'] ?? '',
        jenis: JenisTransaksiDompet.values.firstWhere(
          (e) => e.name == m['jenis'],
          orElse: () => JenisTransaksiDompet.bayarPesanan,
        ),
        jumlah: (m['jumlah'] as num?)?.toDouble() ?? 0,
        saldoSebelum: (m['saldoSebelum'] as num?)?.toDouble() ?? 0,
        saldoSesudah: (m['saldoSesudah'] as num?)?.toDouble() ?? 0,
        keterangan: m['keterangan'] ?? '',
        referensiId: m['referensiId'],
        dibuatPada: (m['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}
