import 'package:cloud_firestore/cloud_firestore.dart';
import 'alamat_model.dart';
import 'keranjang_item.dart';

enum StatusPesanan { menunggu, dikonfirmasi, dikirim, selesai, dibatalkan }

class PesananModel {
  final String? id;
  final String noPesanan;
  final String pembeliUid;
  final String namaPembeli;
  final List<KeranjangItem> barang;
  final double totalBarang;
  final double ongkir;
  final double totalBayar;
  final AlamatModel alamat;
  final String metodeBayar;
  final StatusPesanan status;
  final DateTime dibuatPada;

  const PesananModel({
    this.id,
    required this.noPesanan,
    required this.pembeliUid,
    required this.namaPembeli,
    required this.barang,
    required this.totalBarang,
    required this.ongkir,
    required this.totalBayar,
    required this.alamat,
    required this.metodeBayar,
    this.status = StatusPesanan.menunggu,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    if (id != null) 'id': id,
    'noPesanan': noPesanan,
    'pembeliUid': pembeliUid,
    'namaPembeli': namaPembeli,
    'barang': barang.map((b) => b.keMap()).toList(),
    'totalBarang': totalBarang,
    'ongkir': ongkir,
    'totalBayar': totalBayar,
    'alamat': alamat.keMap(),
    'metodeBayar': metodeBayar,
    'status': status.name,
    'dibuatPada': FieldValue.serverTimestamp(),
  };
}
