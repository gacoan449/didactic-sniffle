import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusPesanan {
  menungguDibayar,
  dibayar,
  diproses,
  dikirim,
  selesai,
  dibatalkan,
}

class ItemPesanan {
  final String produkId;
  final String namaProduk;
  final String gambar;
  final double harga;
  final int jumlah;
  final String namaToko;
  final String penjualId;

  const ItemPesanan({
    required this.produkId,
    required this.namaProduk,
    required this.gambar,
    required this.harga,
    required this.jumlah,
    required this.namaToko,
    required this.penjualId,
  });

  Map<String, dynamic> keMap() => {
    'produkId': produkId,
    'namaProduk': namaProduk,
    'gambar': gambar,
    'harga': harga,
    'jumlah': jumlah,
    'namaToko': namaToko,
    'penjualId': penjualId,
  };

  factory ItemPesanan.dariMap(Map<String, dynamic> map) => ItemPesanan(
    produkId: map['produkId']?.toString() ?? '',
    namaProduk: map['namaProduk']?.toString() ?? '',
    gambar: map['gambar']?.toString() ?? '',
    harga: (map['harga'] as num?)?.toDouble() ?? 0,
    jumlah: (map['jumlah'] as num?)?.toInt() ?? 1,
    namaToko: map['namaToko']?.toString() ?? '',
    penjualId: map['penjualId']?.toString() ?? '',
  );
}

class PesananModel {
  final String id;
  final String kodePesanan;
  final String pembeliId;
  final String namaPembeli;
  final String nomorHP;
  final String alamatLengkap;
  final List<ItemPesanan> daftarItem;
  final double totalProduk;
  final double ongkir;
  final double totalBayar;
  final String metodePengiriman;
  final String metodePembayaran;
  final StatusPesanan status;
  final DateTime dibuatPada;
  final DateTime? diperbaruiPada;

  const PesananModel({
    required this.id,
    required this.kodePesanan,
    required this.pembeliId,
    required this.namaPembeli,
    required this.nomorHP,
    required this.alamatLengkap,
    required this.daftarItem,
    required this.totalProduk,
    required this.ongkir,
    required this.totalBayar,
    required this.metodePengiriman,
    required this.metodePembayaran,
    required this.status,
    required this.dibuatPada,
    this.diperbaruiPada,
  });

  Map<String, dynamic> keMap() => {
    'kodePesanan': kodePesanan,
    'pembeliId': pembeliId,
    'namaPembeli': namaPembeli,
    'nomorHP': nomorHP,
    'alamatLengkap': alamatLengkap,
    'daftarItem': daftarItem.map((i) => i.keMap()).toList(),
    'totalProduk': totalProduk,
    'ongkir': ongkir,
    'totalBayar': totalBayar,
    'metodePengiriman': metodePengiriman,
    'metodePembayaran': metodePembayaran,
    'status': status.name,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
    'diperbaruiPada': diperbaruiPada == null
        ? null
        : Timestamp.fromDate(diperbaruiPada!),
  };

  factory PesananModel.dariMap(Map<String, dynamic> map, String docId) =>
      PesananModel(
        id: docId,
        kodePesanan: map['kodePesanan']?.toString() ?? '',
        pembeliId: map['pembeliId']?.toString() ?? '',
        namaPembeli: map['namaPembeli']?.toString() ?? '',
        nomorHP: map['nomorHP']?.toString() ?? '',
        alamatLengkap: map['alamatLengkap']?.toString() ?? '',
        daftarItem: List<ItemPesanan>.from(
          (map['daftarItem'] ?? []).map((i) => ItemPesanan.dariMap(i)),
        ),
        totalProduk: (map['totalProduk'] as num?)?.toDouble() ?? 0,
        ongkir: (map['ongkir'] as num?)?.toDouble() ?? 0,
        totalBayar: (map['totalBayar'] as num?)?.toDouble() ?? 0,
        metodePengiriman: map['metodePengiriman']?.toString() ?? '',
        metodePembayaran: map['metodePembayaran']?.toString() ?? '',
        status: StatusPesanan.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => StatusPesanan.menungguDibayar,
        ),
        dibuatPada:
            (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
        diperbaruiPada: (map['diperbaruiPada'] as Timestamp?)?.toDate(),
      );
}
