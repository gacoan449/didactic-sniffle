enum JenisTransaksi {
  terimaPembayaran,
  bayarPesanan,
  topup,
  tarikSaldo,
  biayaAdmin,
  refund,
  saldoDilepas,
  lainLain,
}

extension JenisTransaksiExt on JenisTransaksi {
  bool get isPemasukan {
    switch (this) {
      case JenisTransaksi.terimaPembayaran:
      case JenisTransaksi.topup:
      case JenisTransaksi.refund:
        return true;
      default:
        return false;
    }
  }
}

class RingkasanLaporan {
  final int totalPesanan;
  final int totalSelesai;
  final int totalDibatalkan;
  final int totalPendapatan;
  final int totalPengeluaran;
  final DateTime periodeAwal;
  final DateTime periodeAkhir;

  const RingkasanLaporan({
    required this.totalPesanan,
    required this.totalSelesai,
    required this.totalDibatalkan,
    required this.totalPendapatan,
    required this.totalPengeluaran,
    required this.periodeAwal,
    required this.periodeAkhir,
  });

  int get saldoBersih => totalPendapatan - totalPengeluaran;
}

class ItemLaporanTransaksi {
  final String id;
  final String keterangan;
  final int jumlah;
  final DateTime tanggal;
  final JenisTransaksi jenis;

  const ItemLaporanTransaksi({
    required this.id,
    required this.keterangan,
    required this.jumlah,
    required this.tanggal,
    required this.jenis,
  });
}

class HasilPaginationLaporan {
  final List<ItemLaporanTransaksi> data;
  final dynamic dokumenTerakhir;
  final bool adaLagi;

  const HasilPaginationLaporan({
    required this.data,
    required this.dokumenTerakhir,
    required this.adaLagi,
  });
}
