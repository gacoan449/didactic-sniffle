import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

enum StatusVerifikasi { belumDiajukan, menunggu, disetujui, ditolak }

class RekeningBank {
  final String id;
  final String namaBank;
  final String cabangBank;
  final String noRekening;
  final String atasNama;

  const RekeningBank({
    required this.id,
    required this.namaBank,
    required this.cabangBank,
    required this.noRekening,
    required this.atasNama,
  });

  RekeningBank copyWith({
    String? id,
    String? namaBank,
    String? cabangBank,
    String? noRekening,
    String? atasNama,
  }) {
    return RekeningBank(
      id: id ?? this.id,
      namaBank: namaBank ?? this.namaBank,
      cabangBank: cabangBank ?? this.cabangBank,
      noRekening: noRekening ?? this.noRekening,
      atasNama: atasNama ?? this.atasNama,
    );
  }

  factory RekeningBank.fromMap(String id, Map<String, dynamic> data) {
    return RekeningBank(
      id: id,
      namaBank: data[Konstanta.KUNCI_BANK_NAMA] ?? '',
      cabangBank: data[Konstanta.KUNCI_BANK_CABANG] ?? '',
      noRekening: data[Konstanta.KUNCI_NO_REKENING] ?? '',
      atasNama: data[Konstanta.KUNCI_ATAS_NAMA] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_BANK_NAMA: namaBank.trim(),
      Konstanta.KUNCI_BANK_CABANG: cabangBank.trim(),
      Konstanta.KUNCI_NO_REKENING: noRekening.trim(),
      Konstanta.KUNCI_ATAS_NAMA: atasNama.trim(),
    };
  }

  bool apakahValid() {
    return namaBank.trim().isNotEmpty &&
        cabangBank.trim().isNotEmpty &&
        RegExp(r'^[0-9]{8,20}$').hasMatch(noRekening.trim()) &&
        atasNama.trim().length >= 3;
  }
}

class Toko {
  final String id;
  final String idPemilik;
  final String namaToko;
  final String deskripsiToko;
  final String logo;
  final String sampul;
  final String alamat;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String kodePos;
  final double latitude;
  final double longitude;
  final String noTelpToko;
  final String emailToko;
  final String jamBuka;
  final String jamTutup;
  final List<String> hariBuka;
  final String namaPemilik;
  final String noKtp;
  final String fotoKtp;
  final StatusVerifikasi statusVerifikasi;
  final DateTime bergabungPada;
  final double ratingToko;
  final int jumlahUlasan;
  final int totalTerjual;
  final bool isBuka;
  final bool supplierResmi;
  final List<RekeningBank> rekeningBank;
  final DateTime? diperbaruiPada;

  const Toko({
    required this.id,
    required this.idPemilik,
    required this.namaToko,
    required this.deskripsiToko,
    required this.logo,
    required this.sampul,
    required this.alamat,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.kodePos,
    required this.latitude,
    required this.longitude,
    required this.noTelpToko,
    required this.emailToko,
    required this.jamBuka,
    required this.jamTutup,
    required this.hariBuka,
    required this.namaPemilik,
    required this.noKtp,
    required this.fotoKtp,
    required this.statusVerifikasi,
    required this.bergabungPada,
    required this.ratingToko,
    required this.jumlahUlasan,
    required this.totalTerjual,
    required this.isBuka,
    required this.supplierResmi,
    required this.rekeningBank,
    this.diperbaruiPada,
  });

  Toko copyWith({
    String? id,
    String? idPemilik,
    String? namaToko,
    String? deskripsiToko,
    String? logo,
    String? sampul,
    String? alamat,
    String? provinsi,
    String? kabupaten,
    String? kecamatan,
    String? kodePos,
    double? latitude,
    double? longitude,
    String? noTelpToko,
    String? emailToko,
    String? jamBuka,
    String? jamTutup,
    List<String>? hariBuka,
    String? namaPemilik,
    String? noKtp,
    String? fotoKtp,
    StatusVerifikasi? statusVerifikasi,
    DateTime? bergabungPada,
    double? ratingToko,
    int? jumlahUlasan,
    int? totalTerjual,
    bool? isBuka,
    bool? supplierResmi,
    List<RekeningBank>? rekeningBank,
    DateTime? diperbaruiPada,
  }) {
    return Toko(
      id: id ?? this.id,
      idPemilik: idPemilik ?? this.idPemilik,
      namaToko: namaToko ?? this.namaToko,
      deskripsiToko: deskripsiToko ?? this.deskripsiToko,
      logo: logo ?? this.logo,
      sampul: sampul ?? this.sampul,
      alamat: alamat ?? this.alamat,
      provinsi: provinsi ?? this.provinsi,
      kabupaten: kabupaten ?? this.kabupaten,
      kecamatan: kecamatan ?? this.kecamatan,
      kodePos: kodePos ?? this.kodePos,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      noTelpToko: noTelpToko ?? this.noTelpToko,
      emailToko: emailToko ?? this.emailToko,
      jamBuka: jamBuka ?? this.jamBuka,
      jamTutup: jamTutup ?? this.jamTutup,
      hariBuka: hariBuka ?? this.hariBuka,
      namaPemilik: namaPemilik ?? this.namaPemilik,
      noKtp: noKtp ?? this.noKtp,
      fotoKtp: fotoKtp ?? this.fotoKtp,
      statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
      bergabungPada: bergabungPada ?? this.bergabungPada,
      ratingToko: ratingToko ?? this.ratingToko,
      jumlahUlasan: jumlahUlasan ?? this.jumlahUlasan,
      totalTerjual: totalTerjual ?? this.totalTerjual,
      isBuka: isBuka ?? this.isBuka,
      supplierResmi: supplierResmi ?? this.supplierResmi,
      rekeningBank: rekeningBank ?? this.rekeningBank,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
    );
  }

  factory Toko.fromMap(String id, Map<String, dynamic> data) {
    final tsGabung = data[Konstanta.KUNCI_BERGABUNG_PADA] as Timestamp?;
    final tsUbah = data[Konstanta.KUNCI_DIPERBARUI_PADA] as Timestamp?;
    final listRek = data[Konstanta.KOLEKSI_BANK] as List? ?? [];

    final indexStatus = data[Konstanta.KUNCI_STATUS_VERIFIKASI] ?? 0;
    final status =
        indexStatus >= 0 && indexStatus < StatusVerifikasi.values.length
        ? StatusVerifikasi.values[indexStatus]
        : StatusVerifikasi.belumDiajukan;

    return Toko(
      id: id,
      idPemilik: data[Konstanta.KUNCI_ID_PEMILIK] ?? '',
      namaToko: data[Konstanta.KUNCI_NAMA_TOKO] ?? '',
      deskripsiToko: data[Konstanta.KUNCI_DESKRIPSI_TOKO] ?? '',
      logo: data[Konstanta.KUNCI_LOGO] ?? '',
      sampul: data[Konstanta.KUNCI_SAMPUL] ?? '',
      alamat: data[Konstanta.KUNCI_ALAMAT] ?? '',
      provinsi: data[Konstanta.KUNCI_PROVINSI] ?? '',
      kabupaten: data[Konstanta.KUNCI_KABUPATEN] ?? '',
      kecamatan: data[Konstanta.KUNCI_KECAMATAN] ?? '',
      kodePos: data[Konstanta.KUNCI_KODE_POS] ?? '',
      latitude: (data[Konstanta.KUNCI_LAT] ?? -6.9667).toDouble(),
      longitude: (data[Konstanta.KUNCI_LNG] ?? 110.4167).toDouble(),
      noTelpToko: data[Konstanta.KUNCI_NO_TELP_TOKO] ?? '',
      emailToko: data[Konstanta.KUNCI_EMAIL_TOKO] ?? '',
      jamBuka: data[Konstanta.KUNCI_JAM_BUKA] ?? '08:00',
      jamTutup: data[Konstanta.KUNCI_JAM_TUTUP] ?? '17:00',
      hariBuka: List<String>.from(
        data[Konstanta.KUNCI_HARI_BUKA] ??
            ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
      ),
      namaPemilik: data[Konstanta.KUNCI_PEMILIK_NAMA] ?? '',
      noKtp: data[Konstanta.KUNCI_NO_KTP] ?? '',
      fotoKtp: data[Konstanta.KUNCI_FOTO_KTP] ?? '',
      statusVerifikasi: status,
      bergabungPada: tsGabung?.toDate() ?? DateTime.now(),
      ratingToko: (data[Konstanta.KUNCI_RATING_TOKO] ?? 0).toDouble(),
      jumlahUlasan: data[Konstanta.KUNCI_JUMLAH_ULASAN_TOKO] ?? 0,
      totalTerjual: data[Konstanta.KUNCI_TERJUAL_TOKO] ?? 0,
      isBuka: data[Konstanta.KUNCI_IS_BUKA] ?? true,
      supplierResmi: data[Konstanta.KUNCI_IS_SUPPLIER_RESMI] ?? false,
      rekeningBank: listRek
          .asMap()
          .entries
          .map((e) => RekeningBank.fromMap(e.key.toString(), e.value))
          .toList(),
      diperbaruiPada: tsUbah?.toDate(),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      Konstanta.KUNCI_ID: id,
      Konstanta.KUNCI_ID_PEMILIK: idPemilik,
      Konstanta.KUNCI_NAMA_TOKO: namaToko.trim(),
      Konstanta.KUNCI_DESKRIPSI_TOKO: deskripsiToko.trim(),
      Konstanta.KUNCI_LOGO: logo,
      Konstanta.KUNCI_SAMPUL: sampul,
      Konstanta.KUNCI_ALAMAT: alamat.trim(),
      Konstanta.KUNCI_PROVINSI: provinsi,
      Konstanta.KUNCI_KABUPATEN: kabupaten,
      Konstanta.KUNCI_KECAMATAN: kecamatan,
      Konstanta.KUNCI_KODE_POS: kodePos.trim(),
      Konstanta.KUNCI_LAT: latitude,
      Konstanta.KUNCI_LNG: longitude,
      Konstanta.KUNCI_NO_TELP_TOKO: noTelpToko.trim(),
      Konstanta.KUNCI_EMAIL_TOKO: emailToko.trim().toLowerCase(),
      Konstanta.KUNCI_JAM_BUKA: jamBuka,
      Konstanta.KUNCI_JAM_TUTUP: jamTutup,
      Konstanta.KUNCI_HARI_BUKA: hariBuka,
      Konstanta.KUNCI_PEMILIK_NAMA: namaPemilik.trim(),
      Konstanta.KUNCI_NO_KTP: noKtp.trim(),
      Konstanta.KUNCI_FOTO_KTP: fotoKtp,
      Konstanta.KUNCI_STATUS_VERIFIKASI: statusVerifikasi.index,
      Konstanta.KUNCI_BERGABUNG_PADA: FieldValue.serverTimestamp(),
      Konstanta.KUNCI_RATING_TOKO: ratingToko,
      Konstanta.KUNCI_JUMLAH_ULASAN_TOKO: jumlahUlasan,
      Konstanta.KUNCI_TERJUAL_TOKO: totalTerjual,
      Konstanta.KUNCI_IS_BUKA: isBuka,
      Konstanta.KUNCI_IS_SUPPLIER_RESMI: supplierResmi,
      Konstanta.KOLEKSI_BANK: rekeningBank.map((r) => r.toMap()).toList(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      Konstanta.KUNCI_NAMA_TOKO: namaToko.trim(),
      Konstanta.KUNCI_DESKRIPSI_TOKO: deskripsiToko.trim(),
      Konstanta.KUNCI_LOGO: logo,
      Konstanta.KUNCI_SAMPUL: sampul,
      Konstanta.KUNCI_ALAMAT: alamat.trim(),
      Konstanta.KUNCI_PROVINSI: provinsi,
      Konstanta.KUNCI_KABUPATEN: kabupaten,
      Konstanta.KUNCI_KECAMATAN: kecamatan,
      Konstanta.KUNCI_KODE_POS: kodePos.trim(),
      Konstanta.KUNCI_LAT: latitude,
      Konstanta.KUNCI_LNG: longitude,
      Konstanta.KUNCI_NO_TELP_TOKO: noTelpToko.trim(),
      Konstanta.KUNCI_EMAIL_TOKO: emailToko.trim().toLowerCase(),
      Konstanta.KUNCI_JAM_BUKA: jamBuka,
      Konstanta.KUNCI_JAM_TUTUP: jamTutup,
      Konstanta.KUNCI_HARI_BUKA: hariBuka,
      Konstanta.KUNCI_IS_BUKA: isBuka,
      Konstanta.KOLEKSI_BANK: rekeningBank.map((r) => r.toMap()).toList(),
      Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
    };
  }

  bool apakahValid() {
    final regexTelp = RegExp(r'^[0-9]{10,15}$');
    final regexEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final regexKtp = RegExp(r'^[0-9]{16}$');
    final regexKodePos = RegExp(r'^[0-9]{5}$');

    return namaToko.trim().length >= 5 &&
        namaToko.trim().length <= 50 &&
        deskripsiToko.trim().length >= 20 &&
        logo.isNotEmpty &&
        alamat.trim().length >= 10 &&
        provinsi.isNotEmpty &&
        kabupaten.isNotEmpty &&
        kecamatan.isNotEmpty &&
        regexKodePos.hasMatch(kodePos.trim()) &&
        regexTelp.hasMatch(noTelpToko.trim()) &&
        regexEmail.hasMatch(emailToko.trim()) &&
        namaPemilik.trim().length >= 3 &&
        regexKtp.hasMatch(noKtp.trim()) &&
        fotoKtp.isNotEmpty &&
        rekeningBank.isNotEmpty &&
        rekeningBank.every((r) => r.apakahValid());
  }

  bool get sedangBuka {
    if (!isBuka) return false;

    final daftarHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final hariIni = daftarHari[DateTime.now().weekday - 1];
    if (!hariBuka.contains(hariIni)) return false;

    final jamMulai = _ubahKeMenit(jamBuka);
    final jamSelesai = _ubahKeMenit(jamTutup);
    final sekarang = DateTime.now();
    final sekarangMenit = sekarang.hour * 60 + sekarang.minute;

    if (jamMulai == null || jamSelesai == null) return true;
    return sekarangMenit >= jamMulai && sekarangMenit <= jamSelesai;
  }

  int? _ubahKeMenit(String teksJam) {
    try {
      final bagian = teksJam.trim().split(':');
      if (bagian.length != 2) return null;
      final jam = int.parse(bagian[0]);
      final menit = int.parse(bagian[1]);
      if (jam < 0 || jam > 23 || menit < 0 || menit > 59) return null;
      return jam * 60 + menit;
    } catch (_) {
      return null;
    }
  }
}
