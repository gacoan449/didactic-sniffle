import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final String id;
  final String produkId;
  final String namaProduk;
  final String gambar;
  final double harga;
  final DateTime ditambahkanPada;

  const WishlistModel({
    required this.id,
    required this.produkId,
    required this.namaProduk,
    required this.gambar,
    required this.harga,
    required this.ditambahkanPada,
  });

  Map<String, dynamic> keMap() => {
    'produkId': produkId,
    'namaProduk': namaProduk,
    'gambar': gambar,
    'harga': harga,
    'ditambahkanPada': Timestamp.fromDate(ditambahkanPada),
  };

  factory WishlistModel.dariMap(Map<String,dynamic> map, String docId) {
    return WishlistModel(
      id: docId,
      produkId: map['produkId']?.toString() ?? '',
      namaProduk: map['namaProduk']?.toString() ?? '',
      gambar: map['gambar']?.toString() ?? '',
      harga: (map['harga'] as num?)?.toDouble() ?? 0,
      ditambahkanPada: (map['ditambahkanPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
