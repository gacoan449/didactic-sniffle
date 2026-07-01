import 'package:cloud_firestore/cloud_firestore.dart';

class VariasiProdukModel {
  final String nama;
  final String nilai;
  final double hargaTambahan;
  final int stok;

  const VariasiProdukModel({
    required this.nama,
    required this.nilai,
    required this.hargaTambahan,
    required this.stok,
  });

  Map<String, dynamic> keMap() => {
    'nama': nama,
    'nilai': nilai,
    'hargaTambahan': hargaTambahan,
    'stok': stok,
  };

  factory VariasiProdukModel.dariMap(Map<String, dynamic> map) =>
      VariasiProdukModel(
        nama: map['nama']?.toString() ?? '',
        nilai: map['nilai']?.toString() ?? '',
        hargaTambahan: (map['hargaTambahan'] as num?)?.toDouble() ?? 0,
        stok: (map['stok'] as num?)?.toInt() ?? 0,
      );
}

class ProdukModel {
  final String id;
  final String nama;
  final String deskripsi;
  final String spesifikasi;
  final List<String> gambarUrl;
  final String? videoUrl;
  final double berat;
  final String satuan;
  final String kategoriId;
  final String kategoriNama;
  final String penjualId;
  final String namaToko;
  final double harga;
  final double hargaDiskon;
  final int stok;
  final int jumlahTerjual;
  final bool organik;
  final bool tersedia;
  final bool flashSale;
  final bool produkBaru;
  final bool terlaris;
  final List<VariasiProdukModel> variasi;
  final double rating;
  final int jumlahUlasan;
  final DateTime dibuatPada;
  final DateTime? berlakuPromoSampai;

  const ProdukModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.spesifikasi,
    required this.gambarUrl,
    this.videoUrl,
    required this.berat,
    required this.satuan,
    required this.kategoriId,
    required this.kategoriNama,
    required this.penjualId,
    required this.namaToko,
    required this.harga,
    required this.hargaDiskon,
    required this.stok,
    required this.jumlahTerjual,
    required this.organik,
    required this.tersedia,
    required this.flashSale,
    required this.produkBaru,
    required this.terlaris,
    required this.variasi,
    required this.rating,
    required this.jumlahUlasan,
    required this.dibuatPada,
    this.berlakuPromoSampai,
  });

  // ✅ Getter agar kompatibel dengan semua kode lama
  String get gambarUtama => gambarUrl.isNotEmpty ? gambarUrl.first : '';

  Map<String, dynamic> keMap() => {
    'nama': nama,
    'deskripsi': deskripsi,
    'spesifikasi': spesifikasi,
    'gambarUrl': gambarUrl,
    'videoUrl': videoUrl,
    'berat': berat,
    'satuan': satuan,
    'kategoriId': kategoriId,
    'kategoriNama': kategoriNama,
    'penjualId': penjualId,
    'namaToko': namaToko,
    'harga': harga,
    'hargaDiskon': hargaDiskon,
    'stok': stok,
    'jumlahTerjual': jumlahTerjual,
    'organik': organik,
    'tersedia': tersedia,
    'flashSale': flashSale,
    'produkBaru': produkBaru,
    'terlaris': terlaris,
    'variasi': variasi.map((v) => v.keMap()).toList(),
    'rating': rating,
    'jumlahUlasan': jumlahUlasan,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
    'berlakuPromoSampai': berlakuPromoSampai == null
        ? null
        : Timestamp.fromDate(berlakuPromoSampai!),
  };

  factory ProdukModel.dariMap(Map<String, dynamic> map, String docId) =>
      ProdukModel(
        id: docId,
        nama: map['nama']?.toString() ?? '',
        deskripsi: map['deskripsi']?.toString() ?? '',
        spesifikasi: map['spesifikasi']?.toString() ?? '',
        gambarUrl: List<String>.from(map['gambarUrl'] ?? []),
        videoUrl: map['videoUrl']?.toString(),
        berat: (map['berat'] as num?)?.toDouble() ?? 0,
        satuan: map['satuan']?.toString() ?? 'kg',
        kategoriId: map['kategoriId']?.toString() ?? '',
        kategoriNama: map['kategoriNama']?.toString() ?? 'Lainnya',
        penjualId: map['penjualId']?.toString() ?? '',
        namaToko: map['namaToko']?.toString() ?? 'Toko Petani',
        harga: (map['harga'] as num?)?.toDouble() ?? 0,
        hargaDiskon: (map['hargaDiskon'] as num?)?.toDouble() ?? 0,
        stok: (map['stok'] as num?)?.toInt() ?? 0,
        jumlahTerjual: (map['jumlahTerjual'] as num?)?.toInt() ?? 0,
        organik: map['organik'] == true,
        tersedia: map['tersedia'] != false,
        flashSale: map['flashSale'] == true,
        produkBaru: map['produkBaru'] == true,
        terlaris: map['terlaris'] == true,
        variasi: List<VariasiProdukModel>.from(
          (map['variasi'] ?? []).map((v) => VariasiProdukModel.dariMap(v)),
        ),
        rating: (map['rating'] as num?)?.toDouble() ?? 0,
        jumlahUlasan: (map['jumlahUlasan'] as num?)?.toInt() ?? 0,
        dibuatPada:
            (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
        berlakuPromoSampai: (map['berlakuPromoSampai'] as Timestamp?)?.toDate(),
      );
}
