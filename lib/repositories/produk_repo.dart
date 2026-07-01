import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produk_model.dart';
import '../services/firebase_service.dart';

class ProdukRepository {
  final FirebaseFirestore _db = LayananFirebase.db;
  final CollectionReference _col;

  ProdukRepository() : _col = LayananFirebase.db.collection('produk');

  Stream<List<ProdukModel>> ambilSemua() {
    return _col.orderBy('dibuatPada', descending: true).snapshots().map((snap) {
      return snap.docs.map((doc) => ProdukModel.dariMap(doc.data() as Map<String,dynamic>, doc.id)).toList();
    });
  }

  Future<List<ProdukModel>> cari(String kataKunci) async {
    final snap = await _col.get();
    return snap.docs
      .map((doc) => ProdukModel.dariMap(doc.data() as Map<String,dynamic>, doc.id))
      .where((p) => p.nama.toLowerCase().contains(kataKunci.toLowerCase()))
      .toList();
  }

  Future<List<ProdukModel>> ambilKategori(String kategori) async {
    final snap = await _col.where('kategori', isEqualTo: kategori).get();
    return snap.docs
      .map((doc) => ProdukModel.dariMap(doc.data() as Map<String,dynamic>, doc.id))
      .toList();
  }
}
