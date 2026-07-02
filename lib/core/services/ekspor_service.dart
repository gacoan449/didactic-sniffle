import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import '../models/laporan_model.dart';
import 'logger_service.dart';

class EksporService {
  final _tgl = DateFormat('dd MMMM yyyy', 'id_ID');
  final _uang = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  Future<Uint8List> buatPdf(
    RingkasanLaporan ringkasan,
    List<ItemLaporanTransaksi> daftar,
  ) async {
    try {
      final font = await PdfGoogleFonts.notoSansRegular();
      final fontBold = await PdfGoogleFonts.notoSansBold();

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  "LAPORAN TRANSAKSI\nPETANI DESA BERKAH",
                  style: pw.TextStyle(font: fontBold, fontSize: 16),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  "Periode: ${_tgl.format(ringkasan.periodeAwal)} s.d ${_tgl.format(ringkasan.periodeAkhir)}",
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 16),

              pw.Text("Ringkasan:", style: pw.TextStyle(font: fontBold)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total Pesanan", style: pw.TextStyle(font: font)),
                  pw.Text(
                    "${ringkasan.totalPesanan} kali",
                    style: pw.TextStyle(font: font),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Pesanan Selesai", style: pw.TextStyle(font: font)),
                  pw.Text(
                    "${ringkasan.totalSelesai} kali",
                    style: pw.TextStyle(font: font),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Pesanan Dibatalkan",
                    style: pw.TextStyle(font: font),
                  ),
                  pw.Text(
                    "${ringkasan.totalDibatalkan} kali",
                    style: pw.TextStyle(font: font),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Total Pendapatan",
                    style: pw.TextStyle(font: fontBold, color: PdfColors.green),
                  ),
                  pw.Text(
                    _uang.format(ringkasan.totalPendapatan),
                    style: pw.TextStyle(font: fontBold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Total Pengeluaran",
                    style: pw.TextStyle(font: fontBold, color: PdfColors.red),
                  ),
                  pw.Text(
                    _uang.format(ringkasan.totalPengeluaran),
                    style: pw.TextStyle(font: fontBold),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Saldo Bersih",
                    style: pw.TextStyle(font: fontBold, fontSize: 13),
                  ),
                  pw.Text(
                    _uang.format(ringkasan.saldoBersih),
                    style: pw.TextStyle(font: fontBold, fontSize: 13),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              pw.Text(
                "Rincian Transaksi:",
                style: pw.TextStyle(font: fontBold),
              ),
              pw.Divider(),
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(
                  font: fontBold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey700,
                ),
                cellStyle: pw.TextStyle(font: font),
                headers: ['Tanggal', 'Keterangan', 'Tipe', 'Jumlah'],
                data: daftar
                    .map(
                      (i) => [
                        _tgl.format(i.tanggal),
                        i.keterangan,
                        i.jenis.isPemasukan ? 'Masuk' : 'Keluar',
                        _uang.format(i.jumlah),
                      ],
                    )
                    .toList(),
              ),
            ];
          },
        ),
      );

      return pdf.save();
    } catch (e, t) {
      LayananLog.error("Buat PDF gagal", e, t);
      throw Exception("Gagal membuat laporan PDF");
    }
  }

  Future<Uint8List> keExcel(
    RingkasanLaporan ringkasan,
    List<ItemLaporanTransaksi> daftar,
  ) async {
    try {
      final excel = Excel.createExcel();
      excel.delete('Sheet1');
      final sheet = excel['Laporan Transaksi'];

      sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue(
        "LAPORAN PETANI DESA BERKAH",
      );
      sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("D1"));
      sheet.cell(CellIndex.indexByString("A2")).value = TextCellValue(
        "Periode",
      );
      sheet.cell(CellIndex.indexByString("B2")).value = TextCellValue(
        "${_tgl.format(ringkasan.periodeAwal)} - ${_tgl.format(ringkasan.periodeAkhir)}",
      );
      sheet.merge(CellIndex.indexByString("B2"), CellIndex.indexByString("D2"));

      sheet.cell(CellIndex.indexByString("A4")).value = TextCellValue(
        "Ringkasan",
      );
      sheet.merge(CellIndex.indexByString("A4"), CellIndex.indexByString("B4"));
      sheet.cell(CellIndex.indexByString("A5")).value = TextCellValue(
        "Total Pesanan",
      );
      sheet.cell(CellIndex.indexByString("B5")).value = IntCellValue(
        ringkasan.totalPesanan,
      );
      sheet.cell(CellIndex.indexByString("A6")).value = TextCellValue(
        "Pesanan Selesai",
      );
      sheet.cell(CellIndex.indexByString("B6")).value = IntCellValue(
        ringkasan.totalSelesai,
      );
      sheet.cell(CellIndex.indexByString("A7")).value = TextCellValue(
        "Pesanan Dibatalkan",
      );
      sheet.cell(CellIndex.indexByString("B7")).value = IntCellValue(
        ringkasan.totalDibatalkan,
      );
      sheet.cell(CellIndex.indexByString("A9")).value = TextCellValue(
        "Total Pendapatan",
      );
      sheet.cell(CellIndex.indexByString("B9")).value = IntCellValue(
        ringkasan.totalPendapatan,
      );
      sheet.cell(CellIndex.indexByString("A10")).value = TextCellValue(
        "Total Pengeluaran",
      );
      sheet.cell(CellIndex.indexByString("B10")).value = IntCellValue(
        ringkasan.totalPengeluaran,
      );
      sheet.cell(CellIndex.indexByString("A11")).value = TextCellValue(
        "Saldo Bersih",
      );
      sheet.cell(CellIndex.indexByString("B11")).value = IntCellValue(
        ringkasan.saldoBersih,
      );

      sheet.cell(CellIndex.indexByString("A13")).value = TextCellValue(
        "Rincian Transaksi",
      );
      sheet.merge(
        CellIndex.indexByString("A13"),
        CellIndex.indexByString("D13"),
      );
      sheet.cell(CellIndex.indexByString("A14")).value = TextCellValue(
        "Tanggal",
      );
      sheet.cell(CellIndex.indexByString("B14")).value = TextCellValue(
        "Keterangan",
      );
      sheet.cell(CellIndex.indexByString("C14")).value = TextCellValue("Tipe");
      sheet.cell(CellIndex.indexByString("D14")).value = TextCellValue(
        "Jumlah",
      );

      int baris = 15;
      for (final item in daftar) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: baris))
            .value = TextCellValue(
          _tgl.format(item.tanggal),
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: baris))
            .value = TextCellValue(
          item.keterangan,
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: baris))
            .value = TextCellValue(
          item.jenis.isPemasukan ? 'Masuk' : 'Keluar',
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: baris))
            .value = IntCellValue(
          item.jumlah,
        );
        baris++;
      }

      return Uint8List.fromList(excel.encode()!);
    } catch (e, t) {
      LayananLog.error("Ekspor Excel gagal", e, t);
      throw Exception("Gagal membuat laporan Excel");
    }
  }

  Future<void> bagikanPdf(
    RingkasanLaporan ringkasan,
    List<ItemLaporanTransaksi> daftar,
  ) async {
    final bytes = await buatPdf(ringkasan, daftar);
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'Laporan_${_tgl.format(DateTime.now()).replaceAll(' ', '_')}.pdf',
    );
  }
}
