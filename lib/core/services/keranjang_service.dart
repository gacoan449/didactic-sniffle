import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/keranjang_item.dart';
import 'firebase_service.dart';

class KeranjangService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  String? get uid => _auth.currentUser?.uid;

  CollectionReference _col() {
    if (uid == null) throw 'Pengguna belum masuk';
    return _db.collection('pengguna').doc(uid).collection('keranjang');
  }

  Future<List<KeranjangItem>> ambilSemua() async {
    if (uid == null) return [];
    final snap = await _col().get();
    return snap.docs
        .map((doc) => KeranjangItem.dariMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> simpan(KeranjangItem barang) async {
    await _col().doc(barang.produkId).set(barang.keMap());
  }

  Future<void> hapus(String produkId) async {
    await _col().doc(produkId).delete();
  }

  Future<void> kosongkan() async {
    if (uid == null) return;
    final snap = await _col().get();
    for (final doc in snap.docs) {
      doc.reference.delete();
    }
  }
}
