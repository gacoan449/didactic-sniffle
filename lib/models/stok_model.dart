import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/logger_service.dart';

enum JenisPerubahanStok {
  stokAwal,
  penambahan,
  pengurangan,
  penyesuaian,
  penjualan,
  pembatalanPesanan,
  returMasuk,
  returKeluar,
  reservasi,
  lepasReservasi,
}

class StokProduk {
  final String idProduk;
  final int jumlahSaatIni;
  final int jumlahDireservasi;
  final int stokMinimum;
  final int stokMaksimum;
  final bool stokRendah;
  final DateTime diperbaruiPada;

  const StokProduk({
    required this.idProduk,
    required this.jumlahSaatIni,
    required this.jumlahDireservasi,
    required this.stokMinimum,
    required this.stokMaksimum,
    required this.stokRendah,
    required this.diperbaruiPada,
  });

  int get jumlahTersedia => jumlahSaatIni - jumlahDireservasi;

  static StokProduk dariSnapshot(DocumentSnapshot snap) {
    try {
      final d = snap.data() as Map<String, dynamic>;
      final jumlah = d['jumlah'] ?? 0;
      final min = d['stokMin'] ?? 5;
      return StokProduk(
        idProduk: snap.id,
        jumlahSaatIni: jumlah,
        jumlahDireservasi: d['direservasi'] ?? 0,
        stokMinimum: min,
        stokMaksimum: d['stokMaks'] ?? 999999,
        stokRendah: jumlah <= min,
        diperbaruiPada:
            (d['diperbarui'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e, t) {
      LayananLog.error("Gagal parsing stok", e, t);
      rethrow;
    }
  }

  StokProduk copyWith({
    int? jumlahSaatIni,
    int? jumlahDireservasi,
    int? stokMinimum,
    int? stokMaksimum,
    bool? stokRendah,
  }) => StokProduk(
    idProduk: idProduk,
    jumlahSaatIni: jumlahSaatIni ?? this.jumlahSaatIni,
    jumlahDireservasi: jumlahDireservasi ?? this.jumlahDireservasi,
    stokMinimum: stokMinimum ?? this.stokMinimum,
    stokMaksimum: stokMaksimum ?? this.stokMaksimum,
    stokRendah: stokRendah ?? this.stokRendah,
    diperbaruiPada: DateTime.now(),
  );

  Map<String, dynamic> keMap() => {
    'jumlah': jumlahSaatIni,
    'direservasi': jumlahDireservasi,
    'stokMin': stokMinimum,
    'stokMaks': stokMaksimum,
    'stokRendah': stokRendah,
    'diperbarui': FieldValue.serverTimestamp(),
  };
}

class RiwayatStok {
  final String id;
  final String idProduk;
  final JenisPerubahanStok jenis;
  final int jumlahSebelum;
  final int jumlahPerubahan;
  final int jumlahSesudah;
  final String idAdmin;
  final String? referensi;
  final String keterangan;
  final DateTime waktu;

  const RiwayatStok({
    required this.id,
    required this.idProduk,
    required this.jenis,
    required this.jumlahSebelum,
    required this.jumlahPerubahan,
    required this.jumlahSesudah,
    required this.idAdmin,
    this.referensi,
    required this.keterangan,
    required this.waktu,
  });

  factory RiwayatStok.dariMap(Map<String, dynamic> m, String docId) {
    JenisPerubahanStok jp = JenisPerubahanStok.penyesuaian;
    switch (m['jenis']?.toString()) {
      case 'stokAwal':
        jp = JenisPerubahanStok.stokAwal;
        break;
      case 'penambahan':
        jp = JenisPerubahanStok.penambahan;
        break;
      case 'pengurangan':
        jp = JenisPerubahanStok.pengurangan;
        break;
      case 'penjualan':
        jp = JenisPerubahanStok.penjualan;
        break;
      case 'reservasi':
        jp = JenisPerubahanStok.reservasi;
        break;
      case 'lepasReservasi':
        jp = JenisPerubahanStok.lepasReservasi;
        break;
    }
    return RiwayatStok(
      id: docId,
      idProduk: m['idProduk'] ?? '',
      jenis: jp,
      jumlahSebelum: m['sebelum'] ?? 0,
      jumlahPerubahan: m['perubahan'] ?? 0,
      jumlahSesudah: m['sesudah'] ?? 0,
      idAdmin: m['idAdmin'] ?? '',
      referensi: m['referensi'],
      keterangan: m['keterangan'] ?? '',
      waktu: (m['waktu'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
