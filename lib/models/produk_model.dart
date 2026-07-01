import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukModel {
  final String? id;
  final String nama;
  final String deskripsi;
  final String kategori;
  final double harga;
  final int stok;
  final String satuan;
  final String gambarUrl;
  final String penjualUid;
  final String namaPenjual;
  final DateTime dibuatPada;

  const ProdukModel({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.kategori,
    required this.harga,
    required this.stok,
    required this.satuan,
    required this.gambarUrl,
    required this.penjualUid,
    required this.namaPenjual,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    if(id != null) 'id': id,
    'nama': nama,
    'deskripsi': deskripsi,
    'kategori': kategori,
    'harga': harga,
    'stok': stok,
    'satuan': satuan,
    'gambarUrl': gambarUrl,
    'penjualUid': penjualUid,
    'namaPenjual': namaPenjual,
    'dibuatPada': FieldValue.serverTimestamp(),
  };

  factory ProdukModel.dariMap(Map<String, dynamic> map, String docId) {
    try {
      return ProdukModel(
        id: docId,
        nama: map['nama']?.toString() ?? 'Tidak ada nama',
        deskripsi: map['deskripsi']?.toString() ?? '',
        kategori: map['kategori']?.toString() ?? 'Lainnya',
        harga: double.tryParse(map['harga']?.toString() ?? '0') ?? 0,
        stok: int.tryParse(map['stok']?.toString() ?? '0') ?? 0,
        satuan: map['satuan']?.toString() ?? 'Buah',
        gambarUrl: map['gambarUrl']?.toString() ?? '',
        penjualUid: map['penjualUid']?.toString() ?? '',
        namaPenjual: map['namaPenjual']?.toString() ?? 'Penjual',
        dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      return ProdukModel(
        id: docId, nama: 'Data Rusak', deskripsi: '', kategori: '-',
        harga: 0, stok: 0, satuan: '-', gambarUrl: '',
        penjualUid: '', namaPenjual: '-', dibuatPada: DateTime.now()
      );
    }
  }
}
