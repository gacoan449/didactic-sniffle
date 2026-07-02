import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'transaksi_kasir_model.g.dart';

enum StatusTransaksi { selesai, refund, retur, dibatalkan, batal }

enum MetodeBayar { tunai, qris, transfer, eWallet, debit, kredit, terpisah }

@HiveType(typeId: 1)
class ItemTransaksi {
  @HiveField(0)
  final String produkId;
  @HiveField(1)
  final String namaProduk;
  @HiveField(2)
  final String barcode;
  @HiveField(3)
  final double jumlah;
  @HiveField(4)
  final String satuan;
  @HiveField(5)
  final double hargaSatuan;
  @HiveField(6)
  final double diskonItem;
  @HiveField(7)
  final double pajakItem;
  @HiveField(8)
  final double subtotal;

  const ItemTransaksi({
    required this.produkId,
    required this.namaProduk,
    required this.barcode,
    required this.jumlah,
    required this.satuan,
    required this.hargaSatuan,
    required this.diskonItem,
    required this.pajakItem,
    required this.subtotal,
  });

  Map<String, dynamic> keMap() => {
    'produkId': produkId,
    'namaProduk': namaProduk,
    'barcode': barcode,
    'jumlah': jumlah,
    'satuan': satuan,
    'hargaSatuan': hargaSatuan,
    'diskonItem': diskonItem,
    'pajakItem': pajakItem,
    'subtotal': subtotal,
  };

  factory ItemTransaksi.dariMap(Map<String, dynamic> m) => ItemTransaksi(
    produkId: m['produkId']?.toString() ?? '',
    namaProduk: m['namaProduk']?.toString() ?? '',
    barcode: m['barcode']?.toString() ?? '',
    jumlah: (m['jumlah'] as num?)?.toDouble() ?? 0,
    satuan: m['satuan']?.toString() ?? 'kg',
    hargaSatuan: (m['hargaSatuan'] as num?)?.toDouble() ?? 0,
    diskonItem: (m['diskonItem'] as num?)?.toDouble() ?? 0,
    pajakItem: (m['pajakItem'] as num?)?.toDouble() ?? 0,
    subtotal: (m['subtotal'] as num?)?.toDouble() ?? 0,
  );
}

@HiveType(typeId: 2)
class TransaksiKasirModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nomorInvoice;
  @HiveField(2)
  final String kasirId;
  @HiveField(3)
  final String namaKasir;
  @HiveField(4)
  final String supervisorId;
  @HiveField(5)
  final String namaSupervisor;
  @HiveField(6)
  final String tokoId;
  @HiveField(7)
  final String namaToko;
  @HiveField(8)
  final String supplierId;
  @HiveField(9)
  final String namaSupplier;
  @HiveField(10)
  final List<ItemTransaksi> daftarProduk;
  @HiveField(11)
  final double subtotal;
  @HiveField(12)
  final double diskonGlobal;
  @HiveField(13)
  final double pajakPpn;
  @HiveField(14)
  final double biayaLain;
  @HiveField(15)
  final double totalHarga;
  @HiveField(16)
  final double jumlahBayar;
  @HiveField(17)
  final double kembalian;
  @HiveField(18)
  final MetodeBayar metodePembayaran;
  @HiveField(19)
  final String kodeVoucher;
  @HiveField(20)
  final StatusTransaksi status;
  @HiveField(21)
  final String alasanPerubahan;
  @HiveField(22)
  final String disetujuiOleh;
  @HiveField(23)
  final String catatan;
  @HiveField(24)
  final String qrTransaksi;
  @HiveField(25)
  final DateTime dibuatPada;
  @HiveField(26)
  final DateTime? diperbaruiPada;

  const TransaksiKasirModel({
    required this.id,
    required this.nomorInvoice,
    required this.kasirId,
    required this.namaKasir,
    required this.supervisorId,
    required this.namaSupervisor,
    required this.tokoId,
    required this.namaToko,
    required this.supplierId,
    required this.namaSupplier,
    required this.daftarProduk,
    required this.subtotal,
    required this.diskonGlobal,
    required this.pajakPpn,
    required this.biayaLain,
    required this.totalHarga,
    required this.jumlahBayar,
    required this.kembalian,
    required this.metodePembayaran,
    required this.kodeVoucher,
    required this.status,
    required this.alasanPerubahan,
    required this.disetujuiOleh,
    required this.catatan,
    required this.qrTransaksi,
    required this.dibuatPada,
    this.diperbaruiPada,
  });

  Map<String, dynamic> keMap() => {
    'nomorInvoice': nomorInvoice,
    'kasirId': kasirId,
    'namaKasir': namaKasir,
    'supervisorId': supervisorId,
    'namaSupervisor': namaSupervisor,
    'tokoId': tokoId,
    'namaToko': namaToko,
    'supplierId': supplierId,
    'namaSupplier': namaSupplier,
    'daftarProduk': daftarProduk.map((i) => i.keMap()).toList(),
    'subtotal': subtotal,
    'diskonGlobal': diskonGlobal,
    'pajakPpn': pajakPpn,
    'biayaLain': biayaLain,
    'totalHarga': totalHarga,
    'jumlahBayar': jumlahBayar,
    'kembalian': kembalian,
    'metodePembayaran': metodePembayaran.name,
    'kodeVoucher': kodeVoucher,
    'status': status.name,
    'alasanPerubahan': alasanPerubahan,
    'disetujuiOleh': disetujuiOleh,
    'catatan': catatan,
    'qrTransaksi': qrTransaksi,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
    'diperbaruiPada': diperbaruiPada == null
        ? null
        : Timestamp.fromDate(diperbaruiPada!),
  };

  factory TransaksiKasirModel.dariMap(Map<String, dynamic> map, String docId) =>
      TransaksiKasirModel(
        id: docId,
        nomorInvoice: map['nomorInvoice']?.toString() ?? '',
        kasirId: map['kasirId']?.toString() ?? '',
        namaKasir: map['namaKasir']?.toString() ?? '',
        supervisorId: map['supervisorId']?.toString() ?? '',
        namaSupervisor: map['namaSupervisor']?.toString() ?? '',
        tokoId: map['tokoId']?.toString() ?? '',
        namaToko: map['namaToko']?.toString() ?? '',
        supplierId: map['supplierId']?.toString() ?? '',
        namaSupplier: map['namaSupplier']?.toString() ?? '',
        daftarProduk: List<ItemTransaksi>.from(
          (map['daftarProduk'] ?? []).map((x) => ItemTransaksi.dariMap(x)),
        ),
        subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
        diskonGlobal: (map['diskonGlobal'] as num?)?.toDouble() ?? 0,
        pajakPpn: (map['pajakPpn'] as num?)?.toDouble() ?? 0,
        biayaLain: (map['biayaLain'] as num?)?.toDouble() ?? 0,
        totalHarga: (map['totalHarga'] as num?)?.toDouble() ?? 0,
        jumlahBayar: (map['jumlahBayar'] as num?)?.toDouble() ?? 0,
        kembalian: (map['kembalian'] as num?)?.toDouble() ?? 0,
        metodePembayaran: MetodeBayar.values.firstWhere(
          (e) => e.name == map['metodePembayaran'],
          orElse: () => MetodeBayar.tunai,
        ),
        kodeVoucher: map['kodeVoucher']?.toString() ?? '',
        status: StatusTransaksi.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => StatusTransaksi.selesai,
        ),
        alasanPerubahan: map['alasanPerubahan']?.toString() ?? '',
        disetujuiOleh: map['disetujuiOleh']?.toString() ?? '',
        catatan: map['catatan']?.toString() ?? '',
        qrTransaksi: map['qrTransaksi']?.toString() ?? '',
        dibuatPada:
            (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
        diperbaruiPada: (map['diperbaruiPada'] as Timestamp?)?.toDate(),
      );

  // 🔢 NOMOR INVOICE AMAN DARI DUPLIKAT PAKAI FIRESTORE TRANSACTION & COUNTER
  static Future<String> buatNomorInvoice(String tokoId) async {
    final now = DateTime.now();
    final tanggal =
        '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final db = FirebaseFirestore.instance;
    final refCounter = db.collection('counter_invoice').doc('$tokoId-$tanggal');

    return await db.runTransaction((tx) async {
      final snap = await tx.get(refCounter);
      int urut = 1;
      if (snap.exists) {
        urut = (snap.data()?['nilai'] as int? ?? 0) + 1;
        tx.update(refCounter, {
          'nilai': urut,
          'diperbaruiPada': FieldValue.serverTimestamp(),
        });
      } else {
        tx.set(refCounter, {
          'nilai': 1,
          'dibuatPada': FieldValue.serverTimestamp(),
        });
      }
      return 'PB-$tanggal-${urut.toString().padLeft(5, '0')}';
    });
  }
}
