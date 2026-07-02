import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

enum StatusPembayaran {
  belumBayar,
  menungguVerifikasi,
  berhasil,
  gagal,
  refund,
}

enum StatusPengiriman {
  belumDikirim,
  sedangDikemas,
  menungguKurir,
  dijemput,
  diperjalanan,
  sampaiGudang,
  sampaiTujuan,
  gagalKirim,
}

enum MetodeBayar { transferBank, cod, eWallet }

enum StatusKomplain { tidakAda, diajukan, diproses, diselesaikan, ditolak }

class RiwayatStatus {
  final String status;
  final DateTime waktu;
  final String keterangan;

  const RiwayatStatus({
    required this.status,
    required this.waktu,
    required this.keterangan,
  });

  factory RiwayatStatus.fromMap(Map<String, dynamic> data) {
    return RiwayatStatus(
      status: data['status'] ?? '',
      waktu: (data['waktu'] as Timestamp?)?.toDate() ?? DateTime.now(),
      keterangan: data['keterangan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'waktu': Timestamp.fromDate(waktu),
      'keterangan': keterangan,
    };
  }
}

class SnapshotProduk {
  final String idProduk;
  final String namaProduk;
  final String kategori;
  final String gambarUtama;
  final int berat;
  final String satuan;
  final int hargaSatuan;
  final int diskonProduk;
  final int voucherProduk;
  final int hargaFinal;

  const SnapshotProduk({
    required this.idProduk,
    required this.namaProduk,
    required this.kategori,
    required this.gambarUtama,
    required this.berat,
    required this.satuan,
    required this.hargaSatuan,
    required this.diskonProduk,
    required this.voucherProduk,
    required this.hargaFinal,
  });

  factory SnapshotProduk.fromMap(Map<String, dynamic> data) {
    return SnapshotProduk(
      idProduk: data[Konstanta.KUNCI_ID_PRODUK] ?? '',
      namaProduk: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      kategori: data[Konstanta.KUNCI_KATEGORI] ?? '',
      gambarUtama: data['gambarUtama'] ?? '',
      berat: (data[Konstanta.KUNCI_BERAT] ?? 0).toInt(),
      satuan: data[Konstanta.KUNCI_SATUAN] ?? 'kg',
      hargaSatuan: (data[Konstanta.KUNCI_HARGA_SATUAN] ?? 0).toInt(),
      diskonProduk: (data[Konstanta.KUNCI_DISKON_PRODUK] ?? 0).toInt(),
      voucherProduk: (data[Konstanta.KUNCI_VOUCHER] ?? 0).toInt(),
      hargaFinal: (data[Konstanta.KUNCI_HARGA_FINAL] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_ID_PRODUK: idProduk,
      Konstanta.KUNCI_NAMA_PRODUK: namaProduk,
      Konstanta.KUNCI_KATEGORI: kategori,
      'gambarUtama': gambarUtama,
      Konstanta.KUNCI_BERAT: berat,
      Konstanta.KUNCI_SATUAN: satuan,
      Konstanta.KUNCI_HARGA_SATUAN: hargaSatuan,
      Konstanta.KUNCI_DISKON_PRODUK: diskonProduk,
      Konstanta.KUNCI_VOUCHER: voucherProduk,
      Konstanta.KUNCI_HARGA_FINAL: hargaFinal,
    };
  }
}

class ItemKeranjang {
  final String id;
  final String idToko;
  final String idSupplier;
  final String namaSupplier;
  final String idProduk;
  final String namaProduk;
  final String kategori;
  final String gambarUtama;
  final int hargaSatuan;
  final int diskonProduk;
  final int hargaFinal;
  final int berat;
  final String satuan;
  int jumlah;
  final int stokTersedia;

  ItemKeranjang({
    required this.id,
    required this.idToko,
    required this.idSupplier,
    required this.namaSupplier,
    required this.idProduk,
    required this.namaProduk,
    required this.kategori,
    required this.gambarUtama,
    required this.hargaSatuan,
    required this.diskonProduk,
    required this.hargaFinal,
    required this.berat,
    required this.satuan,
    required this.jumlah,
    required this.stokTersedia,
  });

  int get subtotal => hargaFinal * jumlah;
  int get totalBerat => berat * jumlah;

  SnapshotProduk buatSnapshot() {
    return SnapshotProduk(
      idProduk: idProduk,
      namaProduk: namaProduk,
      kategori: kategori,
      gambarUtama: gambarUtama,
      berat: berat,
      satuan: satuan,
      hargaSatuan: hargaSatuan,
      diskonProduk: diskonProduk,
      voucherProduk: 0,
      hargaFinal: hargaFinal,
    );
  }

  factory ItemKeranjang.fromMap(String id, Map<String, dynamic> data) {
    return ItemKeranjang(
      id: id,
      idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
      idSupplier: data[Konstanta.KUNCI_ID_SUPPLIER] ?? '',
      namaSupplier: data[Konstanta.KUNCI_NAMA_SUPPLIER] ?? '',
      idProduk: data[Konstanta.KUNCI_ID_PRODUK] ?? '',
      namaProduk: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      kategori: data[Konstanta.KUNCI_KATEGORI] ?? '',
      gambarUtama: data['gambarUtama'] ?? '',
      hargaSatuan: (data[Konstanta.KUNCI_HARGA_SATUAN] ?? 0).toInt(),
      diskonProduk: (data[Konstanta.KUNCI_DISKON_PRODUK] ?? 0).toInt(),
      hargaFinal: (data[Konstanta.KUNCI_HARGA_FINAL] ?? 0).toInt(),
      berat: (data[Konstanta.KUNCI_BERAT] ?? 1).toInt(),
      satuan: data[Konstanta.KUNCI_SATUAN] ?? 'kg',
      jumlah: (data[Konstanta.KUNCI_JUMLAH] ?? 1).toInt(),
      stokTersedia: (data['stokTersedia'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_ID_TOKO: idToko,
      Konstanta.KUNCI_ID_SUPPLIER: idSupplier,
      Konstanta.KUNCI_NAMA_SUPPLIER: namaSupplier,
      Konstanta.KUNCI_ID_PRODUK: idProduk,
      Konstanta.KUNCI_NAMA_PRODUK: namaProduk,
      Konstanta.KUNCI_KATEGORI: kategori,
      'gambarUtama': gambarUtama,
      Konstanta.KUNCI_HARGA_SATUAN: hargaSatuan,
      Konstanta.KUNCI_DISKON_PRODUK: diskonProduk,
      Konstanta.KUNCI_HARGA_FINAL: hargaFinal,
      Konstanta.KUNCI_BERAT: berat,
      Konstanta.KUNCI_SATUAN: satuan,
      Konstanta.KUNCI_JUMLAH: jumlah,
      'stokTersedia': stokTersedia,
    };
  }

  bool apakahValid() {
    return idToko.isNotEmpty &&
        idSupplier.isNotEmpty &&
        idProduk.isNotEmpty &&
        hargaSatuan > 0 &&
        hargaFinal > 0 &&
        jumlah > 0 &&
        jumlah <= stokTersedia;
  }
}

class Transaksi {
  final String id;
  final String noInvoice;
  final String idPembeli;
  final String idToko;
  final String idSupplier;
  final String namaSupplier;
  final String idGudang;
  final String namaGudang;
  final List<SnapshotProduk> daftarSnapshot;
  final List<RiwayatStatus> riwayatStatus;
  final int totalHarga;
  final int totalDiskon;
  final int ongkir;
  final int ppn;
  final int biayaAdmin;
  final int totalBayar;
  final int beratTotal;
  final StatusPembayaran statusPembayaran;
  final StatusPengiriman statusPengiriman;
  final MetodeBayar metodeBayar;
  final StatusKomplain statusKomplain;
  final String alasanKomplain;
  final String namaPenerima;
  final String noTelpPenerima;
  final String alamatPengiriman;
  final double? latTujuan;
  final double? lngTujuan;
  final String catatan;
  final String? nomorResi;
  final String idKurir;
  final String namaKurir;
  final String platKendaraan;
  final String idSopir;
  final String namaSopir;
  final String platTruk;
  final double? gpsTerakhirLat;
  final double? gpsTerakhirLng;
  final DateTime? estimasiSampai;
  final String fotoBarang;
  final String fotoPengiriman;
  final String fotoDiterima;
  final String hashOTP;
  final DateTime otpBerlakuHingga;
  final int percobaanOTPGagal;
  final bool otpTerverifikasi;
  final double ratingProduk;
  final double ratingKurir;
  final double ratingSupplier;
  final DateTime dipesanPada;
  final DateTime? dibayarPada;
  final DateTime? dikirimPada;
  final DateTime? diterimaPada;
  final DateTime? dibatalkanPada;
  final String dibuatOleh;
  final String diubahOleh;
  final String? deviceID;
  final String? ipAddress;
  final String versiAplikasi;

  const Transaksi({
    required this.id,
    required this.noInvoice,
    required this.idPembeli,
    required this.idToko,
    required this.idSupplier,
    required this.namaSupplier,
    required this.idGudang,
    required this.namaGudang,
    required this.daftarSnapshot,
    required this.riwayatStatus,
    required this.totalHarga,
    required this.totalDiskon,
    required this.ongkir,
    required this.ppn,
    required this.biayaAdmin,
    required this.totalBayar,
    required this.beratTotal,
    required this.statusPembayaran,
    required this.statusPengiriman,
    required this.metodeBayar,
    required this.statusKomplain,
    required this.alasanKomplain,
    required this.namaPenerima,
    required this.noTelpPenerima,
    required this.alamatPengiriman,
    this.latTujuan,
    this.lngTujuan,
    required this.catatan,
    this.nomorResi,
    required this.idKurir,
    required this.namaKurir,
    required this.platKendaraan,
    required this.idSopir,
    required this.namaSopir,
    required this.platTruk,
    this.gpsTerakhirLat,
    this.gpsTerakhirLng,
    this.estimasiSampai,
    required this.fotoBarang,
    required this.fotoPengiriman,
    required this.fotoDiterima,
    required this.hashOTP,
    required this.otpBerlakuHingga,
    required this.percobaanOTPGagal,
    required this.otpTerverifikasi,
    required this.ratingProduk,
    required this.ratingKurir,
    required this.ratingSupplier,
    required this.dipesanPada,
    this.dibayarPada,
    this.dikirimPada,
    this.diterimaPada,
    this.dibatalkanPada,
    required this.dibuatOleh,
    required this.diubahOleh,
    this.deviceID,
    this.ipAddress,
    required this.versiAplikasi,
  });

  Transaksi copyWith({
    String? id,
    String? noInvoice,
    String? idPembeli,
    String? idToko,
    String? idSupplier,
    String? namaSupplier,
    String? idGudang,
    String? namaGudang,
    List<SnapshotProduk>? daftarSnapshot,
    List<RiwayatStatus>? riwayatStatus,
    int? totalHarga,
    int? totalDiskon,
    int? ongkir,
    int? ppn,
    int? biayaAdmin,
    int? totalBayar,
    int? beratTotal,
    StatusPembayaran? statusPembayaran,
    StatusPengiriman? statusPengiriman,
    MetodeBayar? metodeBayar,
    StatusKomplain? statusKomplain,
    String? alasanKomplain,
    String? namaPenerima,
    String? noTelpPenerima,
    String? alamatPengiriman,
    double? latTujuan,
    double? lngTujuan,
    String? catatan,
    String? nomorResi,
    String? idKurir,
    String? namaKurir,
    String? platKendaraan,
    String? idSopir,
    String? namaSopir,
    String? platTruk,
    double? gpsTerakhirLat,
    double? gpsTerakhirLng,
    DateTime? estimasiSampai,
    String? fotoBarang,
    String? fotoPengiriman,
    String? fotoDiterima,
    String? hashOTP,
    DateTime? otpBerlakuHingga,
    int? percobaanOTPGagal,
    bool? otpTerverifikasi,
    double? ratingProduk,
    double? ratingKurir,
    double? ratingSupplier,
    DateTime? dipesanPada,
    DateTime? dibayarPada,
    DateTime? dikirimPada,
    DateTime? diterimaPada,
    DateTime? dibatalkanPada,
    String? dibuatOleh,
    String? diubahOleh,
    String? deviceID,
    String? ipAddress,
    String? versiAplikasi,
  }) {
    return Transaksi(
      id: id ?? this.id,
      noInvoice: noInvoice ?? this.noInvoice,
      idPembeli: idPembeli ?? this.idPembeli,
      idToko: idToko ?? this.idToko,
      idSupplier: idSupplier ?? this.idSupplier,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      idGudang: idGudang ?? this.idGudang,
      namaGudang: namaGudang ?? this.namaGudang,
      daftarSnapshot: daftarSnapshot ?? this.daftarSnapshot,
      riwayatStatus: riwayatStatus ?? this.riwayatStatus,
      totalHarga: totalHarga ?? this.totalHarga,
      totalDiskon: totalDiskon ?? this.totalDiskon,
      ongkir: ongkir ?? this.ongkir,
      ppn: ppn ?? this.ppn,
      biayaAdmin: biayaAdmin ?? this.biayaAdmin,
      totalBayar: totalBayar ?? this.totalBayar,
      beratTotal: beratTotal ?? this.beratTotal,
      statusPembayaran: statusPembayaran ?? this.statusPembayaran,
      statusPengiriman: statusPengiriman ?? this.statusPengiriman,
      metodeBayar: metodeBayar ?? this.metodeBayar,
      statusKomplain: statusKomplain ?? this.statusKomplain,
      alasanKomplain: alasanKomplain ?? this.alasanKomplain,
      namaPenerima: namaPenerima ?? this.namaPenerima,
      noTelpPenerima: noTelpPenerima ?? this.noTelpPenerima,
      alamatPengiriman: alamatPengiriman ?? this.alamatPengiriman,
      latTujuan: latTujuan ?? this.latTujuan,
      lngTujuan: lngTujuan ?? this.lngTujuan,
      catatan: catatan ?? this.catatan,
      nomorResi: nomorResi ?? this.nomorResi,
      idKurir: idKurir ?? this.idKurir,
      namaKurir: namaKurir ?? this.namaKurir,
      platKendaraan: platKendaraan ?? this.platKendaraan,
      idSopir: idSopir ?? this.idSopir,
      namaSopir: namaSopir ?? this.namaSopir,
      platTruk: platTruk ?? this.platTruk,
      gpsTerakhirLat: gpsTerakhirLat ?? this.gpsTerakhirLat,
      gpsTerakhirLng: gpsTerakhirLng ?? this.gpsTerakhirLng,
      estimasiSampai: estimasiSampai ?? this.estimasiSampai,
      fotoBarang: fotoBarang ?? this.fotoBarang,
      fotoPengiriman: fotoPengiriman ?? this.fotoPengiriman,
      fotoDiterima: fotoDiterima ?? this.fotoDiterima,
      hashOTP: hashOTP ?? this.hashOTP,
      otpBerlakuHingga: otpBerlakuHingga ?? this.otpBerlakuHingga,
      percobaanOTPGagal: percobaanOTPGagal ?? this.percobaanOTPGagal,
      otpTerverifikasi: otpTerverifikasi ?? this.otpTerverifikasi,
      ratingProduk: ratingProduk ?? this.ratingProduk,
      ratingKurir: ratingKurir ?? this.ratingKurir,
      ratingSupplier: ratingSupplier ?? this.ratingSupplier,
      dipesanPada: dipesanPada ?? this.dipesanPada,
      dibayarPada: dibayarPada ?? this.dibayarPada,
      dikirimPada: dikirimPada ?? this.dikirimPada,
      diterimaPada: diterimaPada ?? this.diterimaPada,
      dibatalkanPada: dibatalkanPada ?? this.dibatalkanPada,
      dibuatOleh: dibuatOleh ?? this.dibuatOleh,
      diubahOleh: diubahOleh ?? this.diubahOleh,
      deviceID: deviceID ?? this.deviceID,
      ipAddress: ipAddress ?? this.ipAddress,
      versiAplikasi: versiAplikasi ?? this.versiAplikasi,
    );
  }

  /// ✅ Hash OTP pakai SHA-256 (tidak simpan teks asli)
  static String hashTeks(String teks) {
    final bytes = utf8.encode(teks);
    return sha256.convert(bytes).toString();
  }

  /// ✅ Buat OTP aman + masa berlaku 10 menit
  static ({String kodeAsli, String kodeHash, DateTime berlakuHingga})
  buatOTP() {
    final acakAman = Random.secure();
    final kode = List.generate(6, (_) => acakAman.nextInt(10)).join();
    final berlaku = DateTime.now().add(const Duration(minutes: 10));
    return (kodeAsli: kode, kodeHash: hashTeks(kode), berlakuHingga: berlaku);
  }

  /// ✅ Validasi nomor HP Indonesia standar
  static bool validasiNoHP(String no) {
    final bersih = no.replaceAll(RegExp(r'[^0-9]'), '');
    final format = bersih.startsWith('0') ? bersih : '0$bersih';
    return RegExp(r'^08[1-9][0-9]{8,12}$').hasMatch(format);
  }

  /// ✅ Nomor Invoice berurutan + unik (dibuat saat simpan pertama kali)
  static String buatNomorInvoice(String idDokumen, int urutHarian) {
    final sekarang = DateTime.now();
    final tanggal =
        "${sekarang.year}${sekarang.month.toString().padLeft(2, '0')}${sekarang.day.toString().padLeft(2, '0')}";
    return "PDB-$tanggal-${urutHarian.toString().padLeft(6, '0')}";
  }

  factory Transaksi.fromMap(String id, Map<String, dynamic> data) {
    final listSnap = data['daftarSnapshot'] as List? ?? [];
    final listRiwayat = data[Konstanta.KUNCI_RIWAYAT_STATUS] as List? ?? [];

    final idxBayar = data[Konstanta.KUNCI_STATUS_PEMBAYARAN] ?? 0;
    final statusBayar =
        idxBayar >= 0 && idxBayar < StatusPembayaran.values.length
        ? StatusPembayaran.values[idxBayar]
        : StatusPembayaran.belumBayar;

    final idxKirim = data[Konstanta.KUNCI_STATUS_PENGIRIMAN] ?? 0;
    final statusKirim =
        idxKirim >= 0 && idxKirim < StatusPengiriman.values.length
        ? StatusPengiriman.values[idxKirim]
        : StatusPengiriman.belumDikirim;

    final idxMetode = data[Konstanta.KUNCI_METODE_BAYAR] ?? 0;
    final metode = idxMetode >= 0 && idxMetode < MetodeBayar.values.length
        ? MetodeBayar.values[idxMetode]
        : MetodeBayar.transferBank;

    final idxKomplain = data[Konstanta.KUNCI_STATUS_KOMPLAIN] ?? 0;
    final komplain =
        idxKomplain >= 0 && idxKomplain < StatusKomplain.values.length
        ? StatusKomplain.values[idxKomplain]
        : StatusKomplain.tidakAda;

    return Transaksi(
      id: id,
      noInvoice: data[Konstanta.KUNCI_NO_INVOICE] ?? '',
      idPembeli: data[Konstanta.KUNCI_ID_PEMBELI] ?? '',
      idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
      idSupplier: data[Konstanta.KUNCI_ID_SUPPLIER] ?? '',
      namaSupplier: data[Konstanta.KUNCI_NAMA_SUPPLIER] ?? '',
      idGudang: data[Konstanta.KUNCI_ID_GUDANG] ?? '',
      namaGudang: data[Konstanta.KUNCI_NAMA_GUDANG] ?? '',
      daftarSnapshot: listSnap.map((s) => SnapshotProduk.fromMap(s)).toList(),
      riwayatStatus: listRiwayat.map((r) => RiwayatStatus.fromMap(r)).toList(),
      totalHarga: (data['totalHarga'] ?? 0).toInt(),
      totalDiskon: (data['totalDiskon'] ?? 0).toInt(),
      ongkir: (data[Konstanta.KUNCI_ONGKIR] ?? 0).toInt(),
      ppn: (data[Konstanta.KUNCI_PPN] ?? 0).toInt(),
      biayaAdmin: (data[Konstanta.KUNCI_BIAYA_ADMIN] ?? 0).toInt(),
      totalBayar: (data[Konstanta.KUNCI_TOTAL_BAYAR] ?? 0).toInt(),
      beratTotal: (data[Konstanta.KUNCI_BERAT_TOTAL] ?? 0).toInt(),
      statusPembayaran: statusBayar,
      statusPengiriman: statusKirim,
      metodeBayar: metode,
      statusKomplain: komplain,
      alasanKomplain: data[Konstanta.KUNCI_ALASAN_KOMPLAIN] ?? '',
      namaPenerima: data[Konstanta.KUNCI_NAMA_PENERIMA] ?? '',
      noTelpPenerima: data[Konstanta.KUNCI_NO_TELP_PENERIMA] ?? '',
      alamatPengiriman: data[Konstanta.KUNCI_ALAMAT_PENGIRIMAN] ?? '',
      latTujuan: (data['latTujuan'] as num?)?.toDouble(),
      lngTujuan: (data['lngTujuan'] as num?)?.toDouble(),
      catatan: data[Konstanta.KUNCI_CATATAN] ?? '',
      nomorResi: data[Konstanta.KUNCI_NOMOR_RESI],
      idKurir: data[Konstanta.KUNCI_ID_KURIR] ?? '',
      namaKurir: data[Konstanta.KUNCI_NAMA_KURIR] ?? '',
      platKendaraan: data[Konstanta.KUNCI_PLAT_KENDARAAN] ?? '',
      idSopir: data[Konstanta.KUNCI_ID_SOPIR] ?? '',
      namaSopir: data[Konstanta.KUNCI_NAMA_SOPIR] ?? '',
      platTruk: data[Konstanta.KUNCI_PLAT_TRUK] ?? '',
      gpsTerakhirLat: (data[Konstanta.KUNCI_GPS_LAT] as num?)?.toDouble(),
      gpsTerakhirLng: (data[Konstanta.KUNCI_GPS_LNG] as num?)?.toDouble(),
      estimasiSampai: (data[Konstanta.KUNCI_ESTIMASI_SAMPAI] as Timestamp?)
          ?.toDate(),
      fotoBarang: data[Konstanta.KUNCI_FOTO_BARANG] ?? '',
      fotoPengiriman: data[Konstanta.KUNCI_FOTO_PENGIRIMAN] ?? '',
      fotoDiterima: data[Konstanta.KUNCI_FOTO_DITERIMA] ?? '',
      hashOTP: data['hashOTP'] ?? '',
      otpBerlakuHingga:
          (data['otpBerlakuHingga'] as Timestamp?)?.toDate() ?? DateTime.now(),
      percobaanOTPGagal: (data['percobaanOTPGagal'] ?? 0).toInt(),
      otpTerverifikasi: data[Konstanta.KUNCI_OTP_TERVERIFIKASI] ?? false,
      ratingProduk:
          (data[Konstanta.KUNCI_RATING_PRODUK] as num?)?.toDouble() ?? 0.0,
      ratingKurir:
          (data[Konstanta.KUNCI_RATING_KURIR] as num?)?.toDouble() ?? 0.0,
      ratingSupplier:
          (data[Konstanta.KUNCI_RATING_SUPPLIER] as num?)?.toDouble() ?? 0.0,
      dipesanPada:
          (data[Konstanta.KUNCI_DIPESAN_PADA] as Timestamp?)?.toDate() ??
          DateTime.now(),
      dibayarPada: (data[Konstanta.KUNCI_DIBAYAR_PADA] as Timestamp?)?.toDate(),
      dikirimPada: (data[Konstanta.KUNCI_DIKIRIM_PADA] as Timestamp?)?.toDate(),
      diterimaPada: (data[Konstanta.KUNCI_DITERIMA_PADA] as Timestamp?)
          ?.toDate(),
      dibatalkanPada: (data[Konstanta.KUNCI_DIBATALKAN_PADA] as Timestamp?)
          ?.toDate(),
      dibuatOleh: data[Konstanta.KUNCI_DIBUAT_OLEH] ?? '',
      diubahOleh: data[Konstanta.KUNCI_DIUBAH_OLEH] ?? '',
      deviceID: data[Konstanta.KUNCI_DEVICE_ID],
      ipAddress: data[Konstanta.KUNCI_IP_ADDRESS],
      versiAplikasi: data[Konstanta.KUNCI_VERSI_APLIKASI] ?? '1.0.0',
    );
  }

  /// ✅ Khusus untuk UPDATE: tidak mengubah waktu pemesanan
  Map<String, dynamic> toMapUntukUpdate() {
    return {
      Konstanta.KUNCI_NO_INVOICE: noInvoice,
      'daftarSnapshot': daftarSnapshot.map((s) => s.toMap()).toList(),
      Konstanta.KUNCI_RIWAYAT_STATUS: riwayatStatus
          .map((r) => r.toMap())
          .toList(),
      'totalHarga': totalHarga,
      'totalDiskon': totalDiskon,
      Konstanta.KUNCI_ONGKIR: ongkir,
      Konstanta.KUNCI_PPN: ppn,
      Konstanta.KUNCI_BIAYA_ADMIN: biayaAdmin,
      Konstanta.KUNCI_TOTAL_BAYAR: totalBayar,
      Konstanta.KUNCI_BERAT_TOTAL: beratTotal,
      Konstanta.KUNCI_STATUS_PEMBAYARAN: statusPembayaran.index,
      Konstanta.KUNCI_STATUS_PENGIRIMAN: statusPengiriman.index,
      Konstanta.KUNCI_METODE_BAYAR: metodeBayar.index,
      Konstanta.KUNCI_STATUS_KOMPLAIN: statusKomplain.index,
      Konstanta.KUNCI_ALASAN_KOMPLAIN: alasanKomplain,
      Konstanta.KUNCI_NAMA_PENERIMA: namaPenerima.trim(),
      Konstanta.KUNCI_NO_TELP_PENERIMA: noTelpPenerima.trim(),
      Konstanta.KUNCI_ALAMAT_PENGIRIMAN: alamatPengiriman.trim(),
      'latTujuan': latTujuan,
      'lngTujuan': lngTujuan,
      Konstanta.KUNCI_CATATAN: catatan.trim(),
      Konstanta.KUNCI_NOMOR_RESI: nomorResi,
      Konstanta.KUNCI_ID_KURIR: idKurir,
      Konstanta.KUNCI_NAMA_KURIR: namaKurir,
      Konstanta.KUNCI_PLAT_KENDARAAN: platKendaraan,
      Konstanta.KUNCI_ID_SOPIR: idSopir,
      Konstanta.KUNCI_NAMA_SOPIR: namaSopir,
      Konstanta.KUNCI_PLAT_TRUK: platTruk,
      Konstanta.KUNCI_GPS_LAT: gpsTerakhirLat,
      Konstanta.KUNCI_GPS_LNG: gpsTerakhirLng,
      Konstanta.KUNCI_ESTIMASI_SAMPAI: estimasiSampai == null
          ? null
          : Timestamp.fromDate(estimasiSampai!),
      Konstanta.KUNCI_FOTO_BARANG: fotoBarang,
      Konstanta.KUNCI_FOTO_PENGIRIMAN: fotoPengiriman,
      Konstanta.KUNCI_FOTO_DITERIMA: fotoDiterima,
      'hashOTP': hashOTP,
      'otpBerlakuHingga': Timestamp.fromDate(otpBerlakuHingga),
      'percobaanOTPGagal': percobaanOTPGagal,
      Konstanta.KUNCI_OTP_TERVERIFIKASI: otpTerverifikasi,
      Konstanta.KUNCI_RATING_PRODUK: ratingProduk,
      Konstanta.KUNCI_RATING_KURIR: ratingKurir,
      Konstanta.KUNCI_RATING_SUPPLIER: ratingSupplier,
      Konstanta.KUNCI_DIBUAT_OLEH: dibuatOleh,
      Konstanta.KUNCI_DIUBAH_OLEH: diubahOleh,
      Konstanta.KUNCI_DEVICE_ID: deviceID,
      Konstanta.KUNCI_IP_ADDRESS: ipAddress,
      Konstanta.KUNCI_VERSI_APLIKASI: versiAplikasi,
    };
  }

  /// ✅ Khusus untuk BUAT BARU: pakai waktu server hanya sekali
  Map<String, dynamic> toMapUntukBuatBaru() {
    return {
      ...toMapUntukUpdate(),
      Konstanta.KUNCI_DIPESAN_PADA: FieldValue.serverTimestamp(),
    };
  }

  bool apakahValid() {
    return noInvoice.isNotEmpty &&
        idPembeli.isNotEmpty &&
        idToko.isNotEmpty &&
        idSupplier.isNotEmpty &&
        daftarSnapshot.isNotEmpty &&
        totalHarga > 0 &&
        totalBayar >= totalHarga &&
        beratTotal > 0 &&
        namaPenerima.trim().length >= 3 &&
        Transaksi.validasiNoHP(noTelpPenerima) &&
        alamatPengiriman.trim().length >= 15;
  }
}
