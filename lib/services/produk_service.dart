import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produk_model.dart';
import 'firebase_service.dart';

class ProdukService {
  final FirebaseFirestore _db = LayananFirebase.db;

  Stream<List<ProdukModel>> ambilSemua() {
    return _db.collection('produk')
      .orderBy('nama')
      .snapshots()
      .map((snap) => snap.docs.map((doc) => ProdukModel.dariMap(doc.data(), doc.id)).toList());
  }

  Future<List<ProdukModel>> cariProduk(String kataKunci) async {
    final kunci = kataKunci.toLowerCase();
    final snap = await _db.collection('produk')
      .where('namaLower', isGreaterThanOrEqualTo: kunci)
      .where('namaLower', isLessThanOrEqualTo: '$kunci\uf8ff')
      .limit(20)
      .get();
    return snap.docs.map((doc) => ProdukModel.dariMap(doc.data(), doc.id)).toList();
  }
}
