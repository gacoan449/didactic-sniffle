import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/pesanan_model.dart';
import '../models/produk_model.dart';
import 'firebase_service.dart';

class PesananService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  String buatNoPesanan() {
    final tanggal = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'PDB-$tanggal-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  }

  Future<void> buatPesanan(PesananModel pesanan, List<ProdukModel> daftarProduk) async {
    if(_auth.currentUser == null) throw 'Silakan masuk terlebih dahulu';
    final uid = _auth.currentUser!.uid;

    await _db.runTransaction((trans) async {
      // 1. Cek & Validasi Stok Terbaru
      for(final barang in pesanan.barang) {
        final docProduk = await trans.get(_db.collection('produk').doc(barang.produkId));
        if(!docProduk.exists) throw 'Produk ${barang.nama} tidak ditemukan';
        
        final data = ProdukModel.dariMap(docProduk.data()!, docProduk.id);
        if(data.stok < barang.jumlah) throw 'Stok ${barang.nama} tinggal ${data.stok}, tidak cukup';

        // 2. Kurangi Stok Produk
        trans.update(docProduk.reference, {'stok': data.stok - barang.jumlah});
      }

      // 3. Simpan Pesanan Utama
      final docPesanan = _db.collection('pesanan').doc();
      trans.set(docPesanan, pesanan.keMap());

      // 4. Simpan Salinan ke Riwayat Pengguna
      trans.set(
        _db.collection('pengguna').doc(uid).collection('pesanan').doc(docPesanan.id),
        pesanan.keMap()
      );
    });
  }
}
