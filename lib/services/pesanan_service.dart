import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/pesanan_model.dart';
import '../models/produk_model.dart';
import 'firebase_service.dart';

class PesananService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  String buatNoPesanan(String docId) {
    final tanggal = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'PDB-$tanggal-${docId.substring(0, 6).toUpperCase()}';
  }

  Future<void> buatPesanan(
    PesananModel pesanan,
    List<ProdukModel> daftarProduk,
  ) async {
    if (_auth.currentUser == null) throw 'Silakan masuk terlebih dahulu';
    final uid = _auth.currentUser!.uid;

    await _db.runTransaction((trans) async {
      // 1. Cek & Validasi Stok Terbaru
      for (final barang in pesanan.barang) {
        final docProduk = await trans.get(
          _db.collection('produk').doc(barang.produkId),
        );
        if (!docProduk.exists) throw 'Produk ${barang.nama} tidak ditemukan';

        final data = ProdukModel.dariMap(docProduk.data()!, docProduk.id);
        if (data.stok < barang.jumlah)
          throw 'Stok ${barang.nama} tinggal ${data.stok}, tidak cukup';

        // 2. Kurangi Stok Produk
        trans.update(docProduk.reference, {'stok': data.stok - barang.jumlah});
      }

      // 3. Simpan Pesanan Utama di collection 'pesanan'
      final docPesanan = _db.collection('pesanan').doc();
      final noPesanan = buatNoPesanan(docPesanan.id);

      trans.set(docPesanan, {...pesanan.keMap(), 'noPesanan': noPesanan});
    });
  }

  Stream<List<PesananModel>> ambilPesananPengguna(String uid) {
    return _db
        .collection('pesanan')
        .where('pembeliUid', isEqualTo: uid)
        .orderBy('dibuatPada', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => PesananModel.dariMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }
}
