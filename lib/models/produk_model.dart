import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/konstanta.dart';

class VariasiProduk {
  final String id;
  final String nama;
  final int stok;
  final int harga;
  final String? foto;

  const VariasiProduk({
    required this.id,
    required this.nama,
    required this.stok,
    required this.harga,
    this.foto,
  });

  VariasiProduk copyWith({
    String? id,
    String? nama,
    int? stok,
    int? harga,
    String? foto,
  }) {
    return VariasiProduk(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      stok: stok ?? this.stok,
      harga: harga ?? this.harga,
      foto: foto ?? this.foto,
    );
  }

  factory VariasiProduk.fromMap(String id, Map<String, dynamic> data) {
    return VariasiProduk(
      id: id,
      nama: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      stok: data[Konstanta.KUNCI_STOK] ?? 0,
      harga: data[Konstanta.KUNCI_HARGA] ?? 0,
      foto: data[Konstanta.KUNCI_FOTO],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_NAMA_PRODUK: nama.trim(),
      Konstanta.KUNCI_STOK: stok,
      Konstanta.KUNCI_HARGA: harga,
      Konstanta.KUNCI_FOTO: foto,
    };
  }
}

class ReviewProduk {
  final String id;
  final String idPembeli;
  final String namaPembeli;
  final int bintang;
  final String ulasan;
  final List<String> foto;
  final List<String> video;
  final DateTime dibuatPada;

  const ReviewProduk({
    required this.id,
    required this.idPembeli,
    required this.namaPembeli,
    required this.bintang,
    required this.ulasan,
    required this.foto,
    required this.video,
    required this.dibuatPada,
  });

  ReviewProduk copyWith({
    String? id,
    String? idPembeli,
    String? namaPembeli,
    int? bintang,
    String? ulasan,
    List<String>? foto,
    List<String>? video,
    DateTime? dibuatPada,
  }) {
    return ReviewProduk(
      id: id ?? this.id,
      idPembeli: idPembeli ?? this.idPembeli,
      namaPembeli: namaPembeli ?? this.namaPembeli,
      bintang: bintang ?? this.bintang,
      ulasan: ulasan ?? this.ulasan,
      foto: foto ?? this.foto,
      video: video ?? this.video,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  factory ReviewProduk.fromMap(String id, Map<String, dynamic> data) {
    final ts = data[Konstanta.KUNCI_DIBUAT_ULASAN] as Timestamp?;
    return ReviewProduk(
      id: id,
      idPembeli: data[Konstanta.KUNCI_ID_PEMBELI] ?? '',
      namaPembeli: data[Konstanta.KUNCI_NAMA_PEMBELI] ?? '',
      bintang: data[Konstanta.KUNCI_BINTANG] ?? 0,
      ulasan: data[Konstanta.KUNCI_ULASAN] ?? '',
      foto: List<String>.from(data[Konstanta.KUNCI_FOTO] ?? []),
      video: List<String>.from(data[Konstanta.KUNCI_VIDEO] ?? []),
      dibuatPada: ts?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Konstanta.KUNCI_ID_PEMBELI: idPembeli,
      Konstanta.KUNCI_NAMA_PEMBELI: namaPembeli,
      Konstanta.KUNCI_BINTANG: bintang,
      Konstanta.KUNCI_ULASAN: ulasan.trim(),
      Konstanta.KUNCI_FOTO: foto,
      Konstanta.KUNCI_VIDEO: video,
      Konstanta.KUNCI_DIBUAT_ULASAN: FieldValue.serverTimestamp(),
    };
  }

  bool apakahValid() {
    return bintang >= 1 && bintang <= 5 && ulasan.trim().length >= 5;
  }
}

class TanyaJawab {
  final String id;
  final String pertanyaan;
  final String namaPenanya;
  final DateTime tglTanya;
  final String? jawaban;
  final String? namaPenjawab;
  final DateTime? tglJawab;

  const TanyaJawab({
    required this.id,
    required this.pertanyaan,
    required this.namaPenanya,
    required this.tglTanya,
    this.jawaban,
    this.namaPenjawab,
    this.tglJawab,
  });

  TanyaJawab copyWith({
    String? id,
    String? pertanyaan,
    String? namaPenanya,
    DateTime? tglTanya,
    String? jawaban,
    String? namaPenjawab,
    DateTime? tglJawab,
  }) {
    return TanyaJawab(
      id: id ?? this.id,
      pertanyaan: pertanyaan ?? this.pertanyaan,
      namaPenanya: namaPenanya ?? this.namaPenanya,
      tglTanya: tglTanya ?? this.tglTanya,
      jawaban: jawaban ?? this.jawaban,
      namaPenjawab: namaPenjawab ?? this.namaPenjawab,
      tglJawab: tglJawab ?? this.tglJawab,
    );
  }

  factory TanyaJawab.fromMap(String id, Map<String, dynamic> data) {
    final tanyaTs = data[Konstanta.KUNCI_TGL_TANYA] as Timestamp?;
    final jawabTs = data[Konstanta.KUNCI_TGL_JAWAB] as Timestamp?;
    return TanyaJawab(
      id: id,
      pertanyaan: data[Konstanta.KUNCI_PERTANYAAN] ?? '',
      namaPenanya: data[Konstanta.KUNCI_NAMA_PENANYA] ?? '',
      tglTanya: tanyaTs?.toDate() ?? DateTime.now(),
      jawaban: data[Konstanta.KUNCI_JAWABAN],
      namaPenjawab: data[Konstanta.KUNCI_NAMA_PENJAWAB],
      tglJawab: jawabTs?.toDate(),
    );
  }

  Map<String, dynamic> toMapTanya() {
    return {
      Konstanta.KUNCI_PERTANYAAN: pertanyaan.trim(),
      Konstanta.KUNCI_NAMA_PENANYA: namaPenanya,
      Konstanta.KUNCI_TGL_TANYA: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapJawab() {
    return {
      Konstanta.KUNCI_JAWABAN: jawaban?.trim(),
      Konstanta.KUNCI_NAMA_PENJAWAB: namaPenjawab,
      Konstanta.KUNCI_TGL_JAWAB: FieldValue.serverTimestamp(),
    };
  }
}

class Produk {
  final String id;
  final String idToko;
  final String nama;
  final String deskripsi;
  final Map<String, String> spesifikasi;
  final List<String> foto;
  final List<String> video;
  final double berat;
  final String satuan;
  final int stok;
  final int harga;
  final int hargaDiskon;
  final bool organik;
  final bool promo;
  final bool flashSale;
  final bool produkBaru;
  final int terjual;
  final double rating;
  final int jumlahRating;
  final List<VariasiProduk> variasi;
  final bool dipublikasikan;
  final DateTime dibuatPada;
  final DateTime? diperbaruiPada;
  final DateTime? dihapusPada;
  final String? dihapusOleh;

  const Produk({
    required this.id,
    required this.idToko,
    required this.nama,
    required this.deskripsi,
    required this.spesifikasi,
    required this.foto,
    required this.video,
    required this.berat,
    required this.satuan,
    required this.stok,
    required this.harga,
    required this.hargaDiskon,
    required this.organik,
    required this.promo,
    required this.flashSale,
    required this.produkBaru,
    required this.terjual,
    required this.rating,
    required this.jumlahRating,
    required this.variasi,
    required this.dipublikasikan,
    required this.dibuatPada,
    this.diperbaruiPada,
    this.dihapusPada,
    this.dihapusOleh,
  });

  /// Map aman untuk penghapusan lunak (statis agar tidak perlu buat objek kosong)
  static Map<String, dynamic> softDeleteMap(String uidPenghapus) {
    return {
      Konstanta.KUNCI_DIPUBLIKASIKAN: false,
      Konstanta.KUNCI_DIHAPUS_PADA: FieldValue.serverTimestamp(),
      Konstanta.KUNCI_DIHAPUS_OLEH: uidPenghapus,
    };
  }

  Produk copyWith({
    String? id,
    String? idToko,
    String? nama,
    String? deskripsi,
    Map<String, String>? spesifikasi,
    List<String>? foto,
    List<String>? video,
    double? berat,
    String? satuan,
    int? stok,
    int? harga,
    int? hargaDiskon,
    bool? organik,
    bool? promo,
    bool? flashSale,
    bool? produkBaru,
    int? terjual,
    double? rating,
    int? jumlahRating,
    List<VariasiProduk>? variasi,
    bool? dipublikasikan,
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
    DateTime? dihapusPada,
    String? dihapusOleh,
  }) {
    return Produk(
      id: id ?? this.id,
      idToko: idToko ?? this.idToko,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      spesifikasi: spesifikasi ?? this.spesifikasi,
      foto: foto ?? this.foto,
      video: video ?? this.video,
      berat: berat ?? this.berat,
      satuan: satuan ?? this.satuan,
      stok: stok ?? this.stok,
      harga: harga ?? this.harga,
      hargaDiskon: hargaDiskon ?? this.hargaDiskon,
      organik: organik ?? this.organik,
      promo: promo ?? this.promo,
      flashSale: flashSale ?? this.flashSale,
      produkBaru: produkBaru ?? this.produkBaru,
      terjual: terjual ?? this.terjual,
      rating: rating ?? this.rating,
      jumlahRating: jumlahRating ?? this.jumlahRating,
      variasi: variasi ?? this.variasi,
      dipublikasikan: dipublikasikan ?? this.dipublikasikan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      dihapusPada: dihapusPada ?? this.dihapusPada,
      dihapusOleh: dihapusOleh ?? this.dihapusOleh,
    );
  }

  factory Produk.fromMap(String id, Map<String, dynamic> data) {
    final tsBuat = data[Konstanta.KUNCI_DIBUAT_PADA] as Timestamp?;
    final tsUbah = data[Konstanta.KUNCI_DIPERBARUI_PADA] as Timestamp?;
    final tsHapus = data[Konstanta.KUNCI_DIHAPUS_PADA] as Timestamp?;
    final listVariasi = data[Konstanta.KOLEKSI_VARIASI] as List? ?? [];

    return Produk(
      id: id,
      idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
      nama: data[Konstanta.KUNCI_NAMA_PRODUK] ?? '',
      deskripsi: data[Konstanta.KUNCI_DESKRIPSI] ?? '',
      spesifikasi: Map<String, String>.from(
        data[Konstanta.KUNCI_SPESIFIKASI] ?? {},
      ),
      foto: List<String>.from(data[Konstanta.KUNCI_FOTO] ?? []),
      video: List<String>.from(data[Konstanta.KUNCI_VIDEO] ?? []),
      berat: (data[Konstanta.KUNCI_BERAT] ?? 0).toDouble(),
      satuan: data[Konstanta.KUNCI_SATUAN] ?? 'kg',
      stok: data[Konstanta.KUNCI_STOK] ?? 0,
      harga: data[Konstanta.KUNCI_HARGA] ?? 0,
      hargaDiskon: data[Konstanta.KUNCI_HARGA_DISKON] ?? 0,
      organik: data[Konstanta.KUNCI_IS_ORGANIK] ?? false,
      promo: data[Konstanta.KUNCI_IS_PROMO] ?? false,
      flashSale: data[Konstanta.KUNCI_IS_FLASH_SALE] ?? false,
      produkBaru: data[Konstanta.KUNCI_IS_PRODUK_BARU] ?? false,
      terjual: data[Konstanta.KUNCI_TERJUAL] ?? 0,
      rating: (data[Konstanta.KUNCI_RATING] ?? 0).toDouble(),
      jumlahRating: data[Konstanta.KUNCI_JUMLAH_RATING] ?? 0,
      variasi: listVariasi
          .asMap()
          .entries
          .map((e) => VariasiProduk.fromMap(e.key.toString(), e.value))
          .toList(),
      dipublikasikan: data[Konstanta.KUNCI_DIPUBLIKASIKAN] ?? true,
      dibuatPada: tsBuat?.toDate() ?? DateTime.now(),
      diperbaruiPada: tsUbah?.toDate(),
      dihapusPada: tsHapus?.toDate(),
      dihapusOleh: data[Konstanta.KUNCI_DIHAPUS_OLEH],
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      Konstanta.KUNCI_ID: id,
      Konstanta.KUNCI_ID_TOKO: idToko,
      Konstanta.KUNCI_NAMA_PRODUK: nama.trim(),
      Konstanta.KUNCI_DESKRIPSI: deskripsi.trim(),
      Konstanta.KUNCI_SPESIFIKASI: spesifikasi,
      Konstanta.KUNCI_FOTO: foto,
      Konstanta.KUNCI_VIDEO: video,
      Konstanta.KUNCI_BERAT: berat,
      Konstanta.KUNCI_SATUAN: satuan,
      Konstanta.KUNCI_STOK: stok,
      Konstanta.KUNCI_HARGA: harga,
      Konstanta.KUNCI_HARGA_DISKON: hargaDiskon,
      Konstanta.KUNCI_IS_ORGANIK: organik,
      Konstanta.KUNCI_IS_PROMO: promo,
      Konstanta.KUNCI_IS_FLASH_SALE: flashSale,
      Konstanta.KUNCI_IS_PRODUK_BARU: produkBaru,
      Konstanta.KUNCI_TERJUAL: terjual,
      Konstanta.KUNCI_RATING: rating,
      Konstanta.KUNCI_JUMLAH_RATING: jumlahRating,
      Konstanta.KOLEKSI_VARIASI: variasi.map((v) => v.toMap()).toList(),
      Konstanta.KUNCI_DIPUBLIKASIKAN: dipublikasikan,
      Konstanta.KUNCI_DIBUAT_PADA: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      Konstanta.KUNCI_NAMA_PRODUK: nama.trim(),
      Konstanta.KUNCI_DESKRIPSI: deskripsi.trim(),
      Konstanta.KUNCI_SPESIFIKASI: spesifikasi,
      Konstanta.KUNCI_FOTO: foto,
      Konstanta.KUNCI_VIDEO: video,
      Konstanta.KUNCI_BERAT: berat,
      Konstanta.KUNCI_SATUAN: satuan,
      Konstanta.KUNCI_STOK: stok,
      Konstanta.KUNCI_HARGA: harga,
      Konstanta.KUNCI_HARGA_DISKON: hargaDiskon,
      Konstanta.KUNCI_IS_ORGANIK: organik,
      Konstanta.KUNCI_IS_PROMO: promo,
      Konstanta.KUNCI_IS_FLASH_SALE: flashSale,
      Konstanta.KUNCI_IS_PRODUK_BARU: produkBaru,
      Konstanta.KOLEKSI_VARIASI: variasi.map((v) => v.toMap()).toList(),
      Konstanta.KUNCI_DIPUBLIKASIKAN: dipublikasikan,
      Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
    };
  }

  /// Validasi data produk lengkap
  bool apakahValid() {
    return nama.trim().length >= 5 &&
        nama.trim().length <= 100 &&
        deskripsi.trim().length >= 20 &&
        foto.isNotEmpty &&
        foto.length <= 10 &&
        video.length <= 3 &&
        harga > 0 &&
        (hargaDiskon == 0 || hargaDiskon <= harga) &&
        stok >= 0 &&
        berat > 0;
  }

  /// Harga yang ditampilkan (diskon jika ada)
  int get hargaTampil => promo && hargaDiskon > 0 ? hargaDiskon : harga;
}
