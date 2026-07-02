import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

enum StatusTransaksi {
  menungguPembayaran,
  dibayar,
  dikemas,
  dikirim,
  sampai,
  selesai,
  dibatalkan,
}

enum StatusPembayaran { belumBayar, menungguVerifikasi, berhasil, gagal }

class OTPTransaksi {
  final String kodeAsli;
  final String kodeHash;
  final DateTime berlakuHingga;

  const OTPTransaksi({
    required this.kodeAsli,
    required this.kodeHash,
    required this.berlakuHingga,
  });
}

class Transaksi {
  final String id;
  final String noInvoice;
  final String idPembeli;
  final String idToko;
  final String idProduk;
  final String namaProduk;
  final int jumlahBeli;
  final int hargaSatuanSaatBeli;
  final int diskonSaatBeli;
  final int hargaFinalSaatBeli;
  final int totalHarga;
  final int totalDiskon;
  final int ongkir;
  final int totalBayar;
  final String alamatPengiriman;
  final String statusTransaksi;
  final String statusPembayaran;
  final OTPTransaksi? otp;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;

  const Transaksi({
    required this.id,
    required this.noInvoice,
    required this.idPembeli,
    required this.idToko,
    required this.idProduk,
    required this.namaProduk,
    required this.jumlahBeli,
    required this.hargaSatuanSaatBeli,
    required this.diskonSaatBeli,
    required this.hargaFinalSaatBeli,
    required this.totalHarga,
    required this.totalDiskon,
    required this.ongkir,
    required this.totalBayar,
    required this.alamatPengiriman,
    required this.statusTransaksi,
    required this.statusPembayaran,
    this.otp,
    required this.dibuatPada,
    required this.diperbaruiPada,
  });

  /// ✅ Fungsi untuk Pengujian: Hash teks dengan SHA-256
  static String hashTeks(String teks) {
    final bytes = utf8.encode(teks);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// ✅ Fungsi untuk Pengujian: Buat OTP 6 digit berlaku 10 menit
  static OTPTransaksi buatOTP() {
    final rng = Random.secure();
    final kode = List.generate(6, (_) => rng.nextInt(10)).join();
    return OTPTransaksi(
      kodeAsli: kode,
      kodeHash: hashTeks(kode),
      berlakuHingga: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  /// ✅ Fungsi untuk Pengujian: Validasi nomor HP Indonesia
  static bool validasiNoHP(String no) {
    final pola = RegExp(r'^(08|628)[0-9]{9,13}$');
    return pola.hasMatch(no);
  }

  factory Transaksi.fromMap(String id, Map<String, dynamic> data) {
    return Transaksi(
      id: id,
      noInvoice: data[Konstanta.KUNCI_NO_INVOICE] ?? '',
      idPembeli: data[Konstanta.KUNCI_ID_PEMBELI] ?? '',
      idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
      idProduk: data[Konstanta.KUNCI_ID_PRODUK] ?? '',
      namaProduk: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      jumlahBeli: (data['jumlahBeli'] ?? 0).toInt(),
      hargaSatuanSaatBeli: (data['hargaSatuanSaatBeli'] ?? 0).toInt(),
      diskonSaatBeli: (data['diskonSaatBeli'] ?? 0).toInt(),
      hargaFinalSaatBeli: (data['hargaFinalSaatBeli'] ?? 0).toInt(),
      totalHarga: (data[Konstanta.KUNCI_TOTAL_HARGA] ?? 0).toInt(),
      totalDiskon: (data[Konstanta.KUNCI_TOTAL_DISKON] ?? 0).toInt(),
      ongkir: (data[Konstanta.KUNCI_ONGKIR] ?? 0).toInt(),
      totalBayar: (data[Konstanta.KUNCI_TOTAL_BAYAR] ?? 0).toInt(),
      alamatPengiriman: data[Konstanta.KUNCI_ALAMAT_PENGIRIMAN] ?? '',
      statusTransaksi:
          data[Konstanta.KUNCI_STATUS_PENGIRIMAN] ??
          StatusTransaksi.menungguPembayaran.name,
      statusPembayaran:
          data[Konstanta.KUNCI_STATUS_PEMBAYARAN] ??
          StatusPembayaran.belumBayar.name,
      dibuatPada:
          (data[Konstanta.KUNCI_DIBUAT_PADA] as Timestamp?)?.toDate() ??
          DateTime.now(),
      diperbaruiPada:
          (data[Konstanta.KUNCI_DIPERBARUI_PADA] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    Konstanta.KUNCI_NO_INVOICE: noInvoice,
    Konstanta.KUNCI_ID_PEMBELI: idPembeli,
    Konstanta.KUNCI_ID_TOKO: idToko,
    Konstanta.KUNCI_ID_PRODUK: idProduk,
    Konstanta.KUNCI_NAMA_PRODUK: namaProduk,
    'jumlahBeli': jumlahBeli,
    'hargaSatuanSaatBeli': hargaSatuanSaatBeli,
    'diskonSaatBeli': diskonSaatBeli,
    'hargaFinalSaatBeli': hargaFinalSaatBeli,
    Konstanta.KUNCI_TOTAL_HARGA: totalHarga,
    Konstanta.KUNCI_TOTAL_DISKON: totalDiskon,
    Konstanta.KUNCI_ONGKIR: ongkir,
    Konstanta.KUNCI_TOTAL_BAYAR: totalBayar,
    Konstanta.KUNCI_ALAMAT_PENGIRIMAN: alamatPengiriman,
    Konstanta.KUNCI_STATUS_PENGIRIMAN: statusTransaksi,
    Konstanta.KUNCI_STATUS_PEMBAYARAN: statusPembayaran,
    Konstanta.KUNCI_DIBUAT_PADA: FieldValue.serverTimestamp(),
    Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
  };
}
