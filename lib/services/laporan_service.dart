import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../models/laporan_model.dart';

class LayananAudit {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> catatAktivitas(
    String idAdmin,
    JenisAudit jenis,
    String keterangan,
  ) async {
    try {
      await _db.collection('audit_log').add({
        'idAdmin': idAdmin,
        'jenis': jenis.name,
        'keterangan': keterangan,
        'waktu': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Gagal catat audit: $e");
    }
  }
}

class PengaturanAplikasi {
  final String namaToko;
  final String alamat;
  final String kontak;

  const PengaturanAplikasi({
    required this.namaToko,
    required this.alamat,
    required this.kontak,
  });

  factory PengaturanAplikasi.defaultnya() => const PengaturanAplikasi(
    namaToko: "Petani Desa Berkah",
    alamat: "Semarang, Jawa Tengah",
    kontak: "+62 812-xxxx-xxxx",
  );
}

class LayananPengaturan {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PengaturanAplikasi> ambilPengaturan() async {
    try {
      final snap = await _db.collection('pengaturan').doc('umum').get();
      if (!snap.exists) return PengaturanAplikasi.defaultnya();
      final d = snap.data()!;
      return PengaturanAplikasi(
        namaToko: d['namaToko'] ?? "Petani Desa Berkah",
        alamat: d['alamat'] ?? "Semarang, Jawa Tengah",
        kontak: d['kontak'] ?? "+62 812-xxxx-xxxx",
      );
    } catch (e) {
      return PengaturanAplikasi.defaultnya();
    }
  }
}

class LayananLaporan {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uang = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final Map<String, String> _cacheNama = {};

  Future<String> ambilNamaPengguna(String id) async {
    if (_cacheNama.containsKey(id)) return _cacheNama[id]!;
    try {
      final snap = await _db.collection('pengguna').doc(id).get();
      final nama = snap.data()?['nama'] ?? '-';
      _cacheNama[id] = nama;
      return nama;
    } catch (e) {
      return '-';
    }
  }

  Future<List<PesananLaporan>> ambilPesananLaporan(
    FilterLaporan filter, {
    int batas = 50,
    DocumentSnapshot? mulaiDari,
  }) async {
    try {
      Query query = _db
          .collection('pesanan')
          .where('tanggal', isGreaterThanOrEqualTo: filter.awal)
          .where(
            'tanggal',
            isLessThanOrEqualTo: filter.akhir.add(const Duration(days: 1)),
          )
          .where('status', whereIn: filter.status)
          .orderBy('tanggal', descending: true)
          .limit(batas);

      if (mulaiDari != null) query = query.startAfterDocument(mulaiDari);

      final snap = await query.get();
      return snap.docs
          .map(
            (d) =>
                PesananLaporan.dariMap(d.data() as Map<String, dynamic>, d.id),
          )
          .toList();
    } catch (e) {
      print("Gagal ambil laporan: $e");
      return [];
    }
  }

  RingkasanLaporan hitungRingkasan(List<PesananLaporan> daftar) {
    int totalPendapatan = 0;
    int totalLaba = 0;
    Map<String, int> hitungProduk = {};
    Map<MetodeBayar, int> hitungBayar = {};

    for (final p in daftar) {
      totalPendapatan += p.totalBayar;
      totalLaba += p.hitungTotalLaba();
      hitungBayar[p.metodeBayar] = (hitungBayar[p.metodeBayar] ?? 0) + 1;
      for (final item in p.daftarProduk) {
        hitungProduk[item.namaProduk] =
            (hitungProduk[item.namaProduk] ?? 0) + item.jumlah;
      }
    }

    final urutProduk = hitungProduk.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return RingkasanLaporan(
      totalPesanan: daftar.length,
      totalPendapatan: totalPendapatan,
      totalLabaBersih: totalLaba,
      rataRataTransaksi: daftar.isEmpty ? 0 : totalPendapatan ~/ daftar.length,
      top5Produk: urutProduk.take(5).toList(),
      ringkasanMetodeBayar: hitungBayar,
    );
  }

  Future<File?> buatLaporanPDF(
    List<PesananLaporan> daftar,
    RingkasanLaporan ringkasan,
    FilterLaporan filter,
    PengaturanAplikasi pengaturan,
  ) async {
    try {
      final pdf = pw.Document();
      final namaBayar = {
        MetodeBayar.tunai: "Tunai",
        MetodeBayar.dompetDesa: "Dompet Desa",
        MetodeBayar.qris: "QRIS",
        MetodeBayar.transferBank: "Transfer",
        MetodeBayar.cod: "COD",
        MetodeBayar.lainLain: "Lain-lain",
      };

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context konteks) => [
            pw.Header(
              level: 0,
              child: pw.Column(
                children: [
                  pw.Center(
                    child: pw.Text(
                      "LAPORAN PENJUALAN",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Center(
                    child: pw.Text(
                      pengaturan.namaToko,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      "${pengaturan.alamat} | ${pengaturan.kontak}",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Periode: ${DateFormat('dd/MM/yyyy').format(filter.awal)} s.d ${DateFormat('dd/MM/yyyy').format(filter.akhir)}",
                  ),
                  pw.Divider(),
                ],
              ),
            ),
            pw.Header(
              child: pw.Text(
                "📊 RINGKASAN",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Pesanan:"),
                pw.Text("${ringkasan.totalPesanan} transaksi"),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Pendapatan:"),
                pw.Text(_uang.format(ringkasan.totalPendapatan)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Laba Bersih:"),
                pw.Text(_uang.format(ringkasan.totalLabaBersih)),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text("Metode Pembayaran:"),
            ...ringkasan.ringkasanMetodeBayar.entries.map(
              (e) => pw.Text("- ${namaBayar[e.key]}: ${e.value} transaksi"),
            ),
            pw.SizedBox(height: 8),
            pw.Text("Top 5 Produk Terlaris:"),
            ...ringkasan.top5Produk.map(
              (e) => pw.Text("- ${e.key}: ${e.value} unit"),
            ),
            pw.SizedBox(height: 16),
            pw.Header(
              child: pw.Text(
                "📋 DETAIL TRANSAKSI",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Table.fromTextArray(
              headers: ['Tanggal', 'No Pesanan', 'Total'],
              data: daftar.map((d) {
                final noPesanan = d.id.length > 8 ? d.id.substring(0, 8) : d.id;
                return [
                  DateFormat('dd/MM/yyyy').format(d.tanggal),
                  noPesanan,
                  _uang.format(d.totalBayar),
                ];
              }).toList(),
            ),
            pw.Spacer(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Dicetak: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
                ),
                pw.Text(
                  "Halaman ${konteks.pageNumber} dari ${konteks.pagesCount}",
                ),
              ],
            ),
          ],
        ),
      );

      final direktori = await getTemporaryDirectory();
      final jalur =
          "${direktori.path}/Laporan_Penjualan_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf";
      final berkas = File(jalur);
      await berkas.writeAsBytes(await pdf.save());
      return berkas;
    } catch (e) {
      print("Gagal buat PDF: $e");
      return null;
    }
  }

  Future<File?> buatLaporanCSV(List<PesananLaporan> daftar) async {
    try {
      List<List<dynamic>> baris = [
        [
          'Tanggal',
          'No Pesanan',
          'Status',
          'Nama Pembeli',
          'Kasir',
          'Metode Bayar',
          'Produk',
          'Jml Produk',
          'Total Bayar',
          'Ongkir',
          'Laba',
        ],
      ];
      for (final d in daftar) {
        final daftarNamaProduk = d.daftarProduk
            .map((p) => "\"${p.namaProduk} x${p.jumlah}\"")
            .join(", ");
        baris.add([
          DateFormat('yyyy-MM-dd').format(d.tanggal),
          d.id,
          d.status,
          await ambilNamaPengguna(d.idPembeli),
          await ambilNamaPengguna(d.idKasir),
          d.metodeBayar.name,
          daftarNamaProduk,
          d.hitungTotalProduk(),
          d.totalBayar,
          d.ongkir,
          d.hitungTotalLaba(),
        ]);
      }
      final csv = const ListToCsvConverter().convert(baris);
      final direktori = await getTemporaryDirectory();
      final jalur =
          "${direktori.path}/Laporan_Penjualan_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv";
      final berkas = File(jalur);
      await berkas.writeAsString(csv);
      return berkas;
    } catch (e) {
      print("Gagal buat CSV: $e");
      return null;
    }
  }

  Future<bool> bagikanBerkas(File? berkas) async {
    if (berkas == null || !await berkas.exists()) return false;
    try {
      await Share.shareXFiles([
        XFile(berkas.path),
      ], text: 'Laporan Penjualan Petani Desa Berkah');
      return true;
    } catch (e) {
      print("Gagal bagikan: $e");
      return false;
    }
  }
}
