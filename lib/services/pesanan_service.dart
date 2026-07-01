import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pesanan_model.dart';
import '../models/keranjang_model.dart';
import '../models/produk_model.dart';
import 'firebase_service.dart';

class PesananService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  String _buatKodePesanan() {
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}-${uid?.substring(0, 6) ?? "USER"}';
  }

  Future<bool> cekStokDanKunci(List<KeranjangModel> keranjang) async {
    final batch = _db.batch();
    for (final item in keranjang) {
      final doc = await _db.collection('produk').doc(item.produkId).get();
      if (!doc.exists) return false;
      final stokSekarang = doc.data()?['stok'] as int? ?? 0;
      if (stokSekarang < item.jumlah) return false;
      batch.update(doc.reference, {'stok': stokSekarang - item.jumlah});
    }
    await batch.commit();
    return true;
  }

  Future<String> simpanPesanan({
    required String namaPembeli,
    required String nomorHP,
    required String alamat,
    required List<KeranjangModel> keranjang,
    required double totalProduk,
    required double ongkir,
    required String kirim,
    required String bayar,
  }) async {
    if (uid == null) throw 'Silakan masuk terlebih dahulu';
    if (keranjang.isEmpty) throw Exception('Keranjang masih kosong');

    final ok = await cekStokDanKunci(keranjang);
    if (!ok) throw 'Stok produk tidak cukup atau sudah habis';

    final daftarItem = keranjang
        .map(
          (k) => ItemPesanan(
            produkId: k.produkId,
            namaProduk: k.namaProduk,
            gambar: k.gambar,
            harga: k.harga,
            jumlah: k.jumlah,
            namaToko: k.namaToko,
            penjualId: k.penjualId,
          ),
        )
        .toList();

    final pesanan = PesananModel(
      id: '',
      kodePesanan: _buatKodePesanan(),
      pembeliId: uid!,
      namaPembeli: namaPembeli,
      nomorHP: nomorHP,
      alamatLengkap: alamat,
      daftarItem: daftarItem,
      totalProduk: totalProduk,
      ongkir: ongkir,
      totalBayar: totalProduk + ongkir,
      metodePengiriman: kirim,
      metodePembayaran: bayar,
      status: StatusPesanan.menungguDibayar,
      dibuatPada: DateTime.now(),
    );

    final ref = await _db.collection('pesanan').add(pesanan.keMap());

    // Simpan Aktivitas Pengguna
    await _db.collection('pengguna').doc(uid).collection('aktivitas').add({
      'judul': 'Pesanan Baru',
      'keterangan': 'Pesanan berhasil dibuat',
      'waktu': FieldValue.serverTimestamp(),
    });

    // Simpan Notifikasi
    await _db.collection('pengguna').doc(uid).collection('notifikasi').add({
      'judul': 'Pesanan Berhasil',
      'isi': 'Pesanan Anda berhasil dibuat.',
      'tipe': 'pesanan',
      'dibuatPada': FieldValue.serverTimestamp(),
      'sudahDibaca': false,
    });

    return ref.id;
  }

  Stream<List<PesananModel>> riwayatPesanan() {
    if (uid == null) return Stream.value([]);
    return _db
        .collection('pesanan')
        .where('pembeliId', isEqualTo: uid)
        .orderBy('dibuatPada', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => PesananModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Future<void> batalkanPesanan(String pesananId) async {
    if (uid == null) throw 'Silakan masuk terlebih dahulu';

    await _db.runTransaction((transaksi) async {
      final docPesanan = await transaksi.get(
        _db.collection('pesanan').doc(pesananId),
      );
      if (!docPesanan.exists) throw 'Pesanan tidak ditemukan';

      final data = PesananModel.dariMap(docPesanan.data()!, docPesanan.id);
      if (data.status == StatusPesanan.selesai ||
          data.status == StatusPesanan.dikirim) {
        throw 'Pesanan tidak bisa dibatalkan';
      }

      // Kembalikan stok produk
      for (final item in data.daftarItem) {
        final docProduk = await transaksi.get(
          _db.collection('produk').doc(item.produkId),
        );
        if (docProduk.exists) {
          final stokSekarang = docProduk.data()?['stok'] as int? ?? 0;
          transaksi.update(docProduk.reference, {
            'stok': stokSekarang + item.jumlah,
          });
        }
      }

      // Ubah status pesanan
      transaksi.update(docPesanan.reference, {
        'status': StatusPesanan.dibatalkan.name,
        'diperbaruiPada': FieldValue.serverTimestamp(),
      });
    });
  }
}
