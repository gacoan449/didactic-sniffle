import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'produk_model.g.dart';

enum SatuanProduk { kg, gram, liter, ml, karung, ikat, butir, papan }

@HiveType(typeId: 6)
class VariasiProduk {
  @HiveField(0)
  final String nama;
  @HiveField(1)
  final String nilai;
  @HiveField(2)
  final double hargaTambahan;
  @HiveField(3)
  final int stok;

  const VariasiProduk({
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
  factory VariasiProduk.dariMap(Map<String, dynamic> m) => VariasiProduk(
    nama: m['nama'] ?? '',
    nilai: m['nilai'] ?? '',
    hargaTambahan: (m['hargaTambahan'] as num?)?.toDouble() ?? 0,
    stok: (m['stok'] as num?)?.toInt() ?? 0,
  );
}

// ✅ MODEL ULASAN SUDAH ADA DI DALAM FILE INI
@HiveType(typeId: 7)
class UlasanProduk {
  @HiveField(0)
  final String penggunaId;
  @HiveField(1)
  final String namaPengguna;
  @HiveField(2)
  final int bintang;
  @HiveField(3)
  final String komentar;
  @HiveField(4)
  final List<String> fotoUlasan;
  @HiveField(5)
  final DateTime dibuatPada;

  const UlasanProduk({
    required this.penggunaId,
    required this.namaPengguna,
    required this.bintang,
    required this.komentar,
    required this.fotoUlasan,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    'penggunaId': penggunaId,
    'namaPengguna': namaPengguna,
    'bintang': bintang,
    'komentar': komentar,
    'fotoUlasan': fotoUlasan,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
  };

  factory UlasanProduk.dariMap(Map<String, dynamic> m) => UlasanProduk(
    penggunaId: m['penggunaId'] ?? '',
    namaPengguna: m['namaPengguna'] ?? '',
    bintang: (m['bintang'] as num?)?.toInt() ?? 0,
    komentar: m['komentar'] ?? '',
    fotoUlasan: List<String>.from(m['fotoUlasan'] ?? []),
    dibuatPada: (m['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

@HiveType(typeId: 8)
class ProdukModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String supplierId;
  @HiveField(2)
  final String namaSupplier;
  @HiveField(3)
  final String namaProduk;
  @HiveField(4)
  final String kodeProduk;
  @HiveField(5)
  final String barcode;
  @HiveField(6)
  final List<String> urlFoto;
  @HiveField(7)
  final String urlVideo;
  @HiveField(8)
  final String deskripsi;
  @HiveField(9)
  final String spesifikasi;
  @HiveField(10)
  final double berat;
  @HiveField(11)
  final SatuanProduk satuan;
  @HiveField(12)
  final int stok;
  @HiveField(13)
  final int stokMinimal;
  @HiveField(14)
  final double hargaBeli;
  @HiveField(15)
  final double hargaJual;
  @HiveField(16)
  final double diskonPersen;
  @HiveField(17)
  final double hargaDiskon;
  @HiveField(18)
  final bool organik;
  @HiveField(19)
  final bool aktif;
  @HiveField(20)
  final bool flashSale;
  @HiveField(21)
  final bool produkBaru;
  @HiveField(22)
  final bool terlaris;
  @HiveField(23)
  final double rating;
  @HiveField(24)
  final int jumlahUlasan;
  @HiveField(25)
  final List<VariasiProduk> variasi;
  @HiveField(26)
  final List<UlasanProduk> daftarUlasan;
  @HiveField(27)
  final DateTime dibuatPada;
  @HiveField(28)
  final DateTime? diperbaruiPada;

  const ProdukModel({
    required this.id,
    required this.supplierId,
    required this.namaSupplier,
    required this.namaProduk,
    required this.kodeProduk,
    required this.barcode,
    required this.urlFoto,
    required this.urlVideo,
    required this.deskripsi,
    required this.spesifikasi,
    required this.berat,
    required this.satuan,
    required this.stok,
    required this.stokMinimal,
    required this.hargaBeli,
    required this.hargaJual,
    required this.diskonPersen,
    required this.hargaDiskon,
    required this.organik,
    required this.aktif,
    required this.flashSale,
    required this.produkBaru,
    required this.terlaris,
    required this.rating,
    required this.jumlahUlasan,
    required this.variasi,
    required this.daftarUlasan,
    required this.dibuatPada,
    this.diperbaruiPada,
  });

  Map<String, dynamic> keMap() => {
    'supplierId': supplierId,
    'namaSupplier': namaSupplier,
    'namaProduk': namaProduk,
    'kodeProduk': kodeProduk,
    'barcode': barcode,
    'urlFoto': urlFoto,
    'urlVideo': urlVideo,
    'deskripsi': deskripsi,
    'spesifikasi': spesifikasi,
    'berat': berat,
    'satuan': satuan.name,
    'stok': stok,
    'stokMinimal': stokMinimal,
    'hargaBeli': hargaBeli,
    'hargaJual': hargaJual,
    'diskonPersen': diskonPersen,
    'hargaDiskon': hargaDiskon,
    'organik': organik,
    'aktif': aktif,
    'flashSale': flashSale,
    'produkBaru': produkBaru,
    'terlaris': terlaris,
    'rating': rating,
    'jumlahUlasan': jumlahUlasan,
    'variasi': variasi.map((v) => v.keMap()).toList(),
    'daftarUlasan': daftarUlasan.map((u) => u.keMap()).toList(),
    'dibuatPada': Timestamp.fromDate(dibuatPada),
    'diperbaruiPada': diperbaruiPada == null
        ? null
        : Timestamp.fromDate(diperbaruiPada!),
  };

  // ✅ SUDAH ADA METODE dariMap DENGAN BENAR
  factory ProdukModel.dariMap(Map<String, dynamic> m, String docId) =>
      ProdukModel(
        id: docId,
        supplierId: m['supplierId'] ?? '',
        namaSupplier: m['namaSupplier'] ?? '',
        namaProduk: m['namaProduk'] ?? '',
        kodeProduk: m['kodeProduk'] ?? '',
        barcode: m['barcode'] ?? '',
        urlFoto: List<String>.from(m['urlFoto'] ?? []),
        urlVideo: m['urlVideo'] ?? '',
        deskripsi: m['deskripsi'] ?? '',
        spesifikasi: m['spesifikasi'] ?? '',
        berat: (m['berat'] as num?)?.toDouble() ?? 0,
        satuan: SatuanProduk.values.firstWhere(
          (e) => e.name == m['satuan'],
          orElse: () => SatuanProduk.kg,
        ),
        stok: (m['stok'] as num?)?.toInt() ?? 0,
        stokMinimal: (m['stokMinimal'] as num?)?.toInt() ?? 5,
        hargaBeli: (m['hargaBeli'] as num?)?.toDouble() ?? 0,
        hargaJual: (m['hargaJual'] as num?)?.toDouble() ?? 0,
        diskonPersen: (m['diskonPersen'] as num?)?.toDouble() ?? 0,
        hargaDiskon: (m['hargaDiskon'] as num?)?.toDouble() ?? 0,
        organik: m['organik'] == true,
        aktif: m['aktif'] == true,
        flashSale: m['flashSale'] == true,
        produkBaru: m['produkBaru'] == true,
        terlaris: m['terlaris'] == true,
        rating: (m['rating'] as num?)?.toDouble() ?? 0,
        jumlahUlasan: (m['jumlahUlasan'] as num?)?.toInt() ?? 0,
        variasi: List<VariasiProduk>.from(
          (m['variasi'] ?? []).map((x) => VariasiProduk.dariMap(x)),
        ),
        daftarUlasan: List<UlasanProduk>.from(
          (m['daftarUlasan'] ?? []).map((x) => UlasanProduk.dariMap(x)),
        ),
        dibuatPada: (m['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
        diperbaruiPada: (m['diperbaruiPada'] as Timestamp?)?.toDate(),
      );
}
