import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../config/konstanta.dart';
import '../models/laporan_model.dart';
import 'logger_service.dart';

class LaporanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int batasPerHalaman = 50;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  /// Ambil ringkasan laporan REALTIME & EFISIEN
  Stream<RingkasanLaporan> streamRingkasan(DateTime awal, DateTime akhir) {
    if (_uid.isEmpty) return Stream.value(_ringkasanKosong(awal, akhir));

    final awalTgl = Timestamp.fromDate(
      DateTime(awal.year, awal.month, awal.day),
    );
    final akhirTgl = Timestamp.fromDate(
      DateTime(akhir.year, akhir.month, akhir.day, 23, 59, 59),
    );

    final streamPesanan = _db
        .collection(Konstanta.KOLEKSI_PESANAN)
        .where('idPenjual', isEqualTo: _uid)
        .where('tanggal', isGreaterThanOrEqualTo: awalTgl)
        .where('tanggal', isLessThanOrEqualTo: akhirTgl)
        .snapshots();

    final streamRiwayat = _db
        .collection(Konstanta.KOLEKSI_RIWAYAT)
        .where('idPengguna', isEqualTo: _uid)
        .where('waktu', isGreaterThanOrEqualTo: awalTgl)
        .where('waktu', isLessThanOrEqualTo: akhirTgl)
        .snapshots();

    /// Gabungkan dua stream dengan tipe jelas
    return Rx.combineLatest2<
      QuerySnapshot<Map<String, dynamic>>,
      QuerySnapshot<Map<String, dynamic>>,
      RingkasanLaporan
    >(streamPesanan, streamRiwayat, (snapPesanan, snapRiwayat) {
      int totalPesanan = snapPesanan.docs.length;
      int totalSelesai = 0;
      int totalDibatalkan = 0;
      int totalPendapatan = 0;

      for (final p in snapPesanan.docs) {
        final data = p.data();
        final status = data['status'] as String?;
        final bayarStatus = data['statusPembayaran'] as String?;
        final total = data['total'] as int? ?? 0;

        if (status == Konstanta.STATUS_PESANAN_SELESAI &&
            bayarStatus == Konstanta.STATUS_BAYAR_SELESAI) {
          totalSelesai++;
          totalPendapatan += total;
        } else if (status == Konstanta.STATUS_PESANAN_DIBATALKAN) {
          totalDibatalkan++;
        }
      }

      int totalPengeluaran = 0;
      for (final r in snapRiwayat.docs) {
        final jenis = r.data()['jenis'] as String;
        final jumlah = r.data()['jumlah'] as int;
        if (_jenisDariString(jenis).isPemasukan == false) {
          totalPengeluaran += jumlah.abs();
        }
      }

      return RingkasanLaporan(
        totalPesanan: totalPesanan,
        totalSelesai: totalSelesai,
        totalDibatalkan: totalDibatalkan,
        totalPendapatan: totalPendapatan,
        totalPengeluaran: totalPengeluaran,
        periodeAwal: awal,
        periodeAkhir: akhir,
      );
    });
  }

  Future<HasilPaginationLaporan> ambilDaftarTransaksi({
    required DateTime awal,
    required DateTime akhir,
    DocumentSnapshot? terakhirDokumen,
  }) async {
    if (_uid.isEmpty)
      return const HasilPaginationLaporan(
        data: [],
        dokumenTerakhir: null,
        adaLagi: false,
      );
    try {
      final awalTgl = Timestamp.fromDate(
        DateTime(awal.year, awal.month, awal.day),
      );
      final akhirTgl = Timestamp.fromDate(
        DateTime(akhir.year, akhir.month, akhir.day, 23, 59, 59),
      );

      Query query = _db
          .collection(Konstanta.KOLEKSI_RIWAYAT)
          .where('idPengguna', isEqualTo: _uid)
          .where('waktu', isGreaterThanOrEqualTo: awalTgl)
          .where('waktu', isLessThanOrEqualTo: akhirTgl)
          .orderBy('waktu', descending: true)
          .limit(batasPerHalaman);

      if (terakhirDokumen != null) {
        query = query.startAfterDocument(terakhirDokumen);
      }

      final snap = await query.get();
      final dokumenTerakhir = snap.docs.isNotEmpty ? snap.docs.last : null;

      return HasilPaginationLaporan(
        data: snap.docs.map((d) {
          final data = d.data() as Map<String, dynamic>;
          final jenisStr = data['jenis'] as String;
          return ItemLaporanTransaksi(
            id: d.id,
            keterangan: data['keterangan'] ?? '-',
            jumlah: data['jumlah'] as int,
            tanggal: (data['waktu'] as Timestamp).toDate(),
            jenis: _jenisDariString(jenisStr),
          );
        }).toList(),
        dokumenTerakhir: dokumenTerakhir,
        adaLagi: snap.docs.length == batasPerHalaman,
      );
    } catch (e, t) {
      LayananLog.error("Ambil daftar transaksi gagal", e, t);
      return const HasilPaginationLaporan(
        data: [],
        dokumenTerakhir: null,
        adaLagi: false,
      );
    }
  }

  JenisTransaksi _jenisDariString(String str) {
    switch (str) {
      case 'terimaPembayaran':
        return JenisTransaksi.terimaPembayaran;
      case 'bayarPesanan':
        return JenisTransaksi.bayarPesanan;
      case 'ditahan':
        return JenisTransaksi.bayarPesanan;
      case 'topup':
        return JenisTransaksi.topup;
      case 'tarikSaldo':
        return JenisTransaksi.tarikSaldo;
      case 'biayaAdmin':
        return JenisTransaksi.biayaAdmin;
      case 'refund':
        return JenisTransaksi.refund;
      case 'dibatalkan':
        return JenisTransaksi.saldoDilepas;
      default:
        return JenisTransaksi.lainLain;
    }
  }

  RingkasanLaporan _ringkasanKosong(DateTime awal, DateTime akhir) {
    return RingkasanLaporan(
      totalPesanan: 0,
      totalSelesai: 0,
      totalDibatalkan: 0,
      totalPendapatan: 0,
      totalPengeluaran: 0,
      periodeAwal: awal,
      periodeAkhir: akhir,
    );
  }
}
