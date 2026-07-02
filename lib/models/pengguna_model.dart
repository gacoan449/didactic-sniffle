import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

class WishlistItem {
  final String id;
  final String idProduk;
  final DateTime ditambahkanPada;

  const WishlistItem({
    required this.id,
    required this.idProduk,
    required this.ditambahkanPada,
  });

  factory WishlistItem.fromMap(String id, Map<String, dynamic> data) {
    final ts = data[Konstanta.KUNCI_DITAMBAHKAN] as Timestamp?;
    return WishlistItem(
      id: id,
      idProduk: data[Konstanta.KUNCI_ID_PRODUK] ?? '',
      ditambahkanPada: ts?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_ID_PRODUK: idProduk,
      Konstanta.KUNCI_DITAMBAHKAN: FieldValue.serverTimestamp(),
    };
  }
}

class AlamatPengguna {
  final String id;
  final String namaPenerima;
  final String noHp;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String detail;
  final String kodePos;
  final bool utama;

  const AlamatPengguna({
    required this.id,
    required this.namaPenerima,
    required this.noHp,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.desa,
    required this.detail,
    required this.kodePos,
    required this.utama,
  });

  factory AlamatPengguna.fromMap(String id, Map<String, dynamic> data) {
    return AlamatPengguna(
      id: id,
      namaPenerima: data[Konstanta.KUNCI_NAMA_PENERIMA] ?? '',
      noHp: data[Konstanta.KUNCI_NO_HP] ?? '',
      provinsi: data[Konstanta.KUNCI_PROVINSI] ?? '',
      kabupaten: data[Konstanta.KUNCI_KABUPATEN] ?? '',
      kecamatan: data[Konstanta.KUNCI_KECAMATAN] ?? '',
      desa: data[Konstanta.KUNCI_DESA] ?? '',
      detail: data[Konstanta.KUNCI_DETAIL_ALAMAT] ?? '',
      kodePos: data[Konstanta.KUNCI_KODE_POS] ?? '',
      utama: data[Konstanta.KUNCI_ALAMAT_UTAMA] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_NAMA_PENERIMA: namaPenerima.trim(),
      Konstanta.KUNCI_NO_HP: noHp.trim().replaceAll(RegExp(r'[^0-9]'), ''),
      Konstanta.KUNCI_PROVINSI: provinsi.trim(),
      Konstanta.KUNCI_KABUPATEN: kabupaten.trim(),
      Konstanta.KUNCI_KECAMATAN: kecamatan.trim(),
      Konstanta.KUNCI_DESA: desa.trim(),
      Konstanta.KUNCI_DETAIL_ALAMAT: detail.trim(),
      Konstanta.KUNCI_KODE_POS: kodePos.trim(),
      Konstanta.KUNCI_ALAMAT_UTAMA: utama,
    };
  }

  /// Validasi lengkap sesuai standar alamat Indonesia
  bool apakahValid() {
    final nomorHpBersih = noHp.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final kodePosBersih = kodePos.trim().replaceAll(RegExp(r'[^0-9]'), '');

    return namaPenerima.trim().length >= 3 &&
        nomorHpBersih.isNotEmpty &&
        RegExp(r'^[0-9]{10,15}$').hasMatch(nomorHpBersih) &&
        provinsi.trim().isNotEmpty &&
        kabupaten.trim().isNotEmpty &&
        kecamatan.trim().isNotEmpty &&
        desa.trim().isNotEmpty &&
        kodePosBersih.isNotEmpty &&
        RegExp(r'^[0-9]{5}$').hasMatch(kodePosBersih);
  }
}

class VoucherPengguna {
  final String id;
  final String kode;
  final int potongan;
  final int minimalBelanja;
  final DateTime berlakuMulai;
  final DateTime berlakuSampai;
  final bool terpakai;

  const VoucherPengguna({
    required this.id,
    required this.kode,
    required this.potongan,
    required this.minimalBelanja,
    required this.berlakuMulai,
    required this.berlakuSampai,
    required this.terpakai,
  });

  factory VoucherPengguna.fromMap(String id, Map<String, dynamic> data) {
    final mulai = data[Konstanta.KUNCI_MULAI_BERLAKU] as Timestamp?;
    final selesai = data[Konstanta.KUNCI_SELESAI_BERLAKU] as Timestamp?;
    return VoucherPengguna(
      id: id,
      kode: data[Konstanta.KUNCI_KODE_VOUCHER] ?? '',
      potongan: data[Konstanta.KUNCI_POTONGAN] ?? 0,
      minimalBelanja: data[Konstanta.KUNCI_MINIMAL_BELANJA] ?? 0,
      berlakuMulai: mulai?.toDate() ?? DateTime.now(),
      berlakuSampai:
          selesai?.toDate() ?? DateTime.now().add(const Duration(days: 7)),
      terpakai: data[Konstanta.KUNCI_TERPAKAI] ?? false,
    );
  }
}
