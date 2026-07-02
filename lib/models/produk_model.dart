import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

enum KualitasProduk { premium, standar, ekonomi }

enum JenisPerubahanStok {
  tambah,
  kurangi,
  sesuaikan,
  terjual,
  retur,
  rusak,
  kadaluarsa,
}

class RiwayatStok {
  final String id;
  final String idProduk;
  final int jumlahSebelum;
  final int jumlahSesudah;
  final int perubahan;
  final JenisPerubahanStok jenis;
  final String alasan;
  final String dilakukanOleh;
  final String dilakukanOlehNama;
  final String? deviceID;
  final String? ipAddress;
  final String versiAplikasi;
  final DateTime waktu;

  const RiwayatStok({
    required this.id,
    required this.idProduk,
    required this.jumlahSebelum,
    required this.jumlahSesudah,
    required this.perubahan,
    required this.jenis,
    required this.alasan,
    required this.dilakukanOleh,
    required this.dilakukanOlehNama,
    this.deviceID,
    this.ipAddress,
    required this.versiAplikasi,
    required this.waktu,
  });

  factory RiwayatStok.fromMap(String id, Map<String, dynamic> data) {
    final idxJenis = data['jenis'] ?? 0;
    return RiwayatStok(
      id: id,
      idProduk: data[Konstanta.KUNCI_ID_PRODUK] ?? '',
      jumlahSebelum: (data[Konstanta.KUNCI_JUMLAH_SEBELUM] ?? 0).toInt(),
      jumlahSesudah: (data[Konstanta.KUNCI_JUMLAH_SESUDAH] ?? 0).toInt(),
      perubahan: (data[Konstanta.KUNCI_PERUBAHAN] ?? 0).toInt(),
      jenis: idxJenis >= 0 && idxJenis < JenisPerubahanStok.values.length
          ? JenisPerubahanStok.values[idxJenis]
          : JenisPerubahanStok.sesuaikan,
      alasan: data[Konstanta.KUNCI_ALASAN] ?? '',
      dilakukanOleh: data[Konstanta.KUNCI_DIBUAT_OLEH] ?? '',
      dilakukanOlehNama: data[Konstanta.KUNCI_DILAKUKAN_OLEH_NAMA] ?? '',
      deviceID: data[Konstanta.KUNCI_DEVICE_ID],
      ipAddress: data[Konstanta.KUNCI_IP_ADDRESS],
      versiAplikasi: data[Konstanta.KUNCI_VERSI_APLIKASI] ?? '1.0.0',
      waktu: (data['waktu'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    Konstanta.KUNCI_ID_PRODUK: idProduk,
    Konstanta.KUNCI_JUMLAH_SEBELUM: jumlahSebelum,
    Konstanta.KUNCI_JUMLAH_SESUDAH: jumlahSesudah,
    Konstanta.KUNCI_PERUBAHAN: perubahan,
    'jenis': jenis.index,
    Konstanta.KUNCI_ALASAN: alasan,
    Konstanta.KUNCI_DIBUAT_OLEH: dilakukanOleh,
    Konstanta.KUNCI_DILAKUKAN_OLEH_NAMA: dilakukanOlehNama,
    Konstanta.KUNCI_DEVICE_ID: deviceID,
    Konstanta.KUNCI_IP_ADDRESS: ipAddress,
    Konstanta.KUNCI_VERSI_APLIKASI: versiAplikasi,
    'waktu': FieldValue.serverTimestamp(),
  };
}

class Produk {
  final String id;
  final String idToko;
  final String idSupplier;
  final String namaSupplier;
  final String idKategori;
  final String namaKategori;
  final String namaProduk;
  final String deskripsi;
  final List<String> daftarGambar;
  final int hargaBeli;
  final int hargaSatuan;
  final int diskonProduk;
  final int berat;
  final String satuan;
  final KualitasProduk kualitas;
  final int stok;
  final int stokMinimum;
  final DateTime? tanggalPanen;
  final DateTime? tanggalKadaluarsa;
  final String asalDesa;
  final String asalKecamatan;
  final String asalKabupaten;
  final bool statusAktif;
  final bool ditampilkan;
  final double rataRataRating;
  final int jumlahUlasan;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
  final String dibuatOleh;
  final String diubahOleh;
  final String? deviceID;
  final String? ipAddress;
  final String versiAplikasi;

  const Produk({
    required this.id,
    required this.idToko,
    required this.idSupplier,
    required this.namaSupplier,
    required this.idKategori,
    required this.namaKategori,
    required this.namaProduk,
    required this.deskripsi,
    required this.daftarGambar,
    required this.hargaBeli,
    required this.hargaSatuan,
    required this.diskonProduk,
    required this.berat,
    required this.satuan,
    required this.kualitas,
    required this.stok,
    required this.stokMinimum,
    this.tanggalPanen,
    this.tanggalKadaluarsa,
    required this.asalDesa,
    required this.asalKecamatan,
    required this.asalKabupaten,
    required this.statusAktif,
    required this.ditampilkan,
    required this.rataRataRating,
    required this.jumlahUlasan,
    required this.dibuatPada,
    required this.diperbaruiPada,
    required this.dibuatOleh,
    required this.diubahOleh,
    this.deviceID,
    this.ipAddress,
    required this.versiAplikasi,
  });

  /// ✅ Dihitung otomatis, tidak disimpan agar tidak tidak sinkron
  int get hargaFinal => hargaSatuan - diskonProduk;

  Produk copyWith({
    String? id,
    String? idToko,
    String? idSupplier,
    String? namaSupplier,
    String? idKategori,
    String? namaKategori,
    String? namaProduk,
    String? deskripsi,
    List<String>? daftarGambar,
    int? hargaBeli,
    int? hargaSatuan,
    int? diskonProduk,
    int? berat,
    String? satuan,
    KualitasProduk? kualitas,
    int? stok,
    int? stokMinimum,
    DateTime? tanggalPanen,
    DateTime? tanggalKadaluarsa,
    String? asalDesa,
    String? asalKecamatan,
    String? asalKabupaten,
    bool? statusAktif,
    bool? ditampilkan,
    double? rataRataRating,
    int? jumlahUlasan,
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
    String? dibuatOleh,
    String? diubahOleh,
    String? deviceID,
    String? ipAddress,
    String? versiAplikasi,
  }) => Produk(
    id: id ?? this.id,
    idToko: idToko ?? this.idToko,
    idSupplier: idSupplier ?? this.idSupplier,
    namaSupplier: namaSupplier ?? this.namaSupplier,
    idKategori: idKategori ?? this.idKategori,
    namaKategori: namaKategori ?? this.namaKategori,
    namaProduk: namaProduk ?? this.namaProduk,
    deskripsi: deskripsi ?? this.deskripsi,
    daftarGambar: daftarGambar ?? this.daftarGambar,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    diskonProduk: diskonProduk ?? this.diskonProduk,
    berat: berat ?? this.berat,
    satuan: satuan ?? this.satuan,
    kualitas: kualitas ?? this.kualitas,
    stok: stok ?? this.stok,
    stokMinimum: stokMinimum ?? this.stokMinimum,
    tanggalPanen: tanggalPanen ?? this.tanggalPanen,
    tanggalKadaluarsa: tanggalKadaluarsa ?? this.tanggalKadaluarsa,
    asalDesa: asalDesa ?? this.asalDesa,
    asalKecamatan: asalKecamatan ?? this.asalKecamatan,
    asalKabupaten: asalKabupaten ?? this.asalKabupaten,
    statusAktif: statusAktif ?? this.statusAktif,
    ditampilkan: ditampilkan ?? this.ditampilkan,
    rataRataRating: rataRataRating ?? this.rataRataRating,
    jumlahUlasan: jumlahUlasan ?? this.jumlahUlasan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
    dibuatOleh: dibuatOleh ?? this.dibuatOleh,
    diubahOleh: diubahOleh ?? this.diubahOleh,
    deviceID: deviceID ?? this.deviceID,
    ipAddress: ipAddress ?? this.ipAddress,
    versiAplikasi: versiAplikasi ?? this.versiAplikasi,
  );

  factory Produk.fromMap(String id, Map<String, dynamic> data) {
    final idxKualitas = data[Konstanta.KUNCI_KUALITAS] ?? 1;
    return Produk(
      id: id,
      idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
      idSupplier: data[Konstanta.KUNCI_ID_SUPPLIER] ?? '',
      namaSupplier: data[Konstanta.KUNCI_NAMA_SUPPLIER] ?? '',
      idKategori: data[Konstanta.KUNCI_ID_KATEGORI] ?? '',
      namaKategori: data[Konstanta.KUNCI_NAMA_KATEGORI] ?? '',
      namaProduk: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      deskripsi: data[Konstanta.KUNCI_DESKRIPSI] ?? '',
      daftarGambar: List<String>.from(
        data[Konstanta.KUNCI_DAFTAR_GAMBAR] ?? [],
      ),
      hargaBeli: (data[Konstanta.KUNCI_HARGA_BELI] ?? 0).toInt(),
      hargaSatuan: (data[Konstanta.KUNCI_HARGA_SATUAN] ?? 0).toInt(),
      diskonProduk: (data[Konstanta.KUNCI_DISKON_PRODUK] ?? 0).toInt(),
      berat: (data[Konstanta.KUNCI_BERAT] ?? 1).toInt(),
      satuan: data[Konstanta.KUNCI_SATUAN] ?? 'kg',
      kualitas: idxKualitas >= 0 && idxKualitas < KualitasProduk.values.length
          ? KualitasProduk.values[idxKualitas]
          : KualitasProduk.standar,
      stok: (data[Konstanta.KUNCI_STOK] ?? 0).toInt(),
      stokMinimum: (data[Konstanta.KUNCI_STOK_MINIMUM] ?? 5).toInt(),
      tanggalPanen: (data[Konstanta.KUNCI_TANGGAL_PANEN] as Timestamp?)
          ?.toDate(),
      tanggalKadaluarsa:
          (data[Konstanta.KUNCI_TANGGAL_KADALUARSA] as Timestamp?)?.toDate(),
      asalDesa: data[Konstanta.KUNCI_ASAL_DESA] ?? '',
      asalKecamatan: data[Konstanta.KUNCI_ASAL_KECAMATAN] ?? '',
      asalKabupaten: data[Konstanta.KUNCI_ASAL_KABUPATEN] ?? '',
      statusAktif: data[Konstanta.KUNCI_STATUS_AKTIF] ?? true,
      ditampilkan: data[Konstanta.KUNCI_DITAMPILKAN] ?? true,
      rataRataRating:
          (data[Konstanta.KUNCI_RATA_RATA_RATING] as num?)?.toDouble() ?? 0.0,
      jumlahUlasan: (data[Konstanta.KUNCI_JUMLAH_ULASAN] ?? 0).toInt(),
      dibuatPada:
          (data[Konstanta.KUNCI_DIBUAT_PADA] as Timestamp?)?.toDate() ??
          DateTime.now(),
      diperbaruiPada:
          (data[Konstanta.KUNCI_DIPERBARUI_PADA] as Timestamp?)?.toDate() ??
          DateTime.now(),
      dibuatOleh: data[Konstanta.KUNCI_DIBUAT_OLEH] ?? '',
      diubahOleh: data[Konstanta.KUNCI_DIUBAH_OLEH] ?? '',
      deviceID: data[Konstanta.KUNCI_DEVICE_ID],
      ipAddress: data[Konstanta.KUNCI_IP_ADDRESS],
      versiAplikasi: data[Konstanta.KUNCI_VERSI_APLIKASI] ?? '1.0.0',
    );
  }

  Map<String, dynamic> toMapBuatBaru() => {
    toMapUmum(),
    Konstanta.KUNCI_DIBUAT_PADA: FieldValue.serverTimestamp(),
  };
  Map<String, dynamic> toMapUpdate() => {
    toMapUmum(),
    Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
  };
  Map<String, dynamic> toMapUmum() => {
    Konstanta.KUNCI_ID_TOKO: idToko,
    Konstanta.KUNCI_ID_SUPPLIER: idSupplier,
    Konstanta.KUNCI_NAMA_SUPPLIER: namaSupplier,
    Konstanta.KUNCI_ID_KATEGORI: idKategori,
    Konstanta.KUNCI_NAMA_KATEGORI: namaKategori,
    Konstanta.KUNCI_NAMA_PRODUK: namaProduk.trim(),
    Konstanta.KUNCI_DESKRIPSI: deskripsi.trim(),
    Konstanta.KUNCI_DAFTAR_GAMBAR: daftarGambar,
    Konstanta.KUNCI_HARGA_BELI: hargaBeli,
    Konstanta.KUNCI_HARGA_SATUAN: hargaSatuan,
    Konstanta.KUNCI_DISKON_PRODUK: diskonProduk,
    Konstanta.KUNCI_BERAT: berat,
    Konstanta.KUNCI_SATUAN: satuan,
    Konstanta.KUNCI_KUALITAS: kualitas.index,
    Konstanta.KUNCI_STOK: stok,
    Konstanta.KUNCI_STOK_MINIMUM: stokMinimum,
    Konstanta.KUNCI_TANGGAL_PANEN: tanggalPanen == null
        ? null
        : Timestamp.fromDate(tanggalPanen!),
    Konstanta.KUNCI_TANGGAL_KADALUARSA: tanggalKadaluarsa == null
        ? null
        : Timestamp.fromDate(tanggalKadaluarsa!),
    Konstanta.KUNCI_ASAL_DESA: asalDesa.trim(),
    Konstanta.KUNCI_ASAL_KECAMATAN: asalKecamatan.trim(),
    Konstanta.KUNCI_ASAL_KABUPATEN: asalKabupaten.trim(),
    Konstanta.KUNCI_STATUS_AKTIF: statusAktif,
    Konstanta.KUNCI_DITAMPILKAN: ditampilkan,
    Konstanta.KUNCI_RATA_RATA_RATING: rataRataRating,
    Konstanta.KUNCI_JUMLAH_ULASAN: jumlahUlasan,
    Konstanta.KUNCI_DIBUAT_OLEH: dibuatOleh,
    Konstanta.KUNCI_DIUBAH_OLEH: diubahOleh,
    Konstanta.KUNCI_DEVICE_ID: deviceID,
    Konstanta.KUNCI_IP_ADDRESS: ipAddress,
    Konstanta.KUNCI_VERSI_APLIKASI: versiAplikasi,
  };

  bool apakahValid() =>
      idToko.isNotEmpty &&
      idSupplier.isNotEmpty &&
      namaProduk.trim().length >= 3 &&
      namaProduk.trim().length <= 100 &&
      hargaSatuan > 0 &&
      diskonProduk >= 0 &&
      hargaFinal > 0 &&
      berat > 0 &&
      stok >= 0 &&
      stokMinimum >= 0 &&
      daftarGambar.isNotEmpty &&
      daftarGambar.every((url) => url.trim().isNotEmpty) &&
      asalDesa.isNotEmpty &&
      asalKabupaten.isNotEmpty;

  bool get stokHampirHabis => stok <= stokMinimum;
  bool get stokKosong => stok == 0;
}
