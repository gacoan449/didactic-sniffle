import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_model.dart';
import 'logger_service.dart';
import 'format_service.dart';

class LayananDashboard {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String formatUang(int nilai) => LayananFormat.uang(nilai);

  Future<RingkasanDashboard> ambilRingkasanUtama() async {
    try {
      final sekarang = DateTime.now();
      final awalBulan = DateTime(sekarang.year, sekarang.month, 1);

      final snapPesanan = await _db
          .collection('pesanan')
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(awalBulan),
          )
          .orderBy('tanggal', descending: true)
          .get();

      int totalPendapatan = 0;
      int totalLaba = 0;
      int selesai = 0;
      int menunggu = 0;

      for (final doc in snapPesanan.docs) {
        final d = doc.data();

        // ✅ Validasi tanggal aman
        final ts = d['tanggal'];
        if (ts is! Timestamp) continue;

        final status = d['status'] ?? '';
        final total = d['total'] ?? 0;
        final modal = d['modalTotal'] ?? 0;

        if (status == 'selesai') {
          selesai++;
          totalPendapatan += total;
          totalLaba += (total - modal);
        } else if (status == 'menunggu' || status == 'proses') {
          menunggu++;
        }
      }

      return RingkasanDashboard(
        totalPesanan: snapPesanan.docs.length,
        totalPendapatan: totalPendapatan,
        totalLaba: totalLaba,
        rataRataTransaksi: selesai == 0 ? 0 : totalPendapatan ~/ selesai,
        pesananSelesai: selesai,
        pesananMenunggu: menunggu,
      );
    } catch (e, t) {
      LayananLog.error("Ambil ringkasan gagal", e, t);
      return const RingkasanDashboard(
        totalPesanan: 0,
        totalPendapatan: 0,
        totalLaba: 0,
        rataRataTransaksi: 0,
        pesananSelesai: 0,
        pesananMenunggu: 0,
      );
    }
  }

  Future<List<DataGrafikWaktu>> ambilPenjualanHarian({
    int hariTerakhir = 14,
  }) async {
    try {
      final sekarang = DateTime.now();
      final awal = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day,
      ).subtract(Duration(days: hariTerakhir - 1));

      final snap = await _db
          .collection('pesanan')
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(awal))
          .where('status', isEqualTo: 'selesai')
          .orderBy('tanggal')
          .get();

      Map<DateTime, int> kelompok = {};
      for (int i = 0; i < hariTerakhir; i++) {
        final tgl = awal.add(Duration(days: i));
        kelompok[DateTime(tgl.year, tgl.month, tgl.day)] = 0;
      }

      for (final doc in snap.docs) {
        final d = doc.data();
        // ✅ Validasi aman
        final ts = d['tanggal'];
        if (ts is! Timestamp) continue;

        final tgl = ts.toDate();
        final hari = DateTime(tgl.year, tgl.month, tgl.day);
        kelompok[hari] = (kelompok[hari] ?? 0) + (d['total'] ?? 0);
      }

      return kelompok.entries
          .map(
            (e) => DataGrafikWaktu(
              tanggal: e.key,
              nilai: e.value,
              label: LayananFormat.tanggalPendek(e.key),
            ),
          )
          .toList();
    } catch (e, t) {
      LayananLog.error("Grafik harian gagal", e, t);
      return [];
    }
  }

  Future<List<ItemAnalisis>> ambilProdukTerlaris({int batas = 5}) async {
    try {
      final Map<String, int> hitung = {};
      final sekarang = DateTime.now();
      final awalBulan = DateTime(sekarang.year, sekarang.month, 1);

      final snap = await _db
          .collection('pesanan')
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(awalBulan),
          )
          .where('status', isEqualTo: 'selesai')
          .get();

      for (final doc in snap.docs) {
        final daftar = doc.data()['produk'] as List? ?? [];
        for (final p in daftar) {
          final nama = p['nama']?.toString() ?? 'Lainnya';
          final jum = p['jumlah'] as int? ?? 0;
          hitung[nama] = (hitung[nama] ?? 0) + jum;
        }
      }

      final urut = hitung.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return urut
          .take(batas)
          .map((e) => ItemAnalisis(nama: e.key, nilai: e.value))
          .toList();
    } catch (e, t) {
      LayananLog.error("Produk terlaris gagal", e, t);
      return [];
    }
  }

  Future<List<ItemAnalisis>> ambilRingkasanMetodeBayar() async {
    try {
      final Map<String, int> hitung = {};
      final sekarang = DateTime.now();
      final awalBulan = DateTime(sekarang.year, sekarang.month, 1);

      final snap = await _db
          .collection('pesanan')
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(awalBulan),
          )
          .where('status', isEqualTo: 'selesai')
          .get();

      for (final doc in snap.docs) {
        final mb = doc.data()['metodeBayar']?.toString() ?? 'lainnya';
        hitung[mb] = (hitung[mb] ?? 0) + 1;
      }

      final nama = {
        'tunai': 'Tunai',
        'dompet': 'Dompet Desa',
        'qris': 'QRIS',
        'transfer': 'Transfer',
        'cod': 'COD',
        'lainnya': 'Lainnya',
      };

      return hitung.entries
          .map((e) => ItemAnalisis(nama: nama[e.key] ?? e.key, nilai: e.value))
          .toList();
    } catch (e, t) {
      LayananLog.error("Metode bayar gagal", e, t);
      return [];
    }
  }
}
