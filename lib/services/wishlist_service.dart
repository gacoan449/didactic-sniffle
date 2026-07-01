import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_model.dart';
import 'firebase_service.dart';

class WishlistService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  CollectionReference<Map<String, dynamic>>? get _ref {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('pengguna').doc(uid).collection('wishlist');
  }

  Stream<List<WishlistModel>> daftarWishlist() {
    final ref = _ref;
    if (ref == null) return Stream.value([]);
    return ref
        .orderBy('ditambahkanPada', descending: true)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => WishlistModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Future<bool> cekSudahDisukai(String produkId) async {
    final ref = _ref;
    if (ref == null) return false;
    final doc = await ref.doc(produkId).get();
    return doc.exists;
  }

  Future<void> tambah(WishlistModel data) async {
    final ref = _ref;
    if (ref == null) throw 'Silakan masuk terlebih dahulu';
    await ref.doc(data.produkId).set(data.keMap(), SetOptions(merge: true));
  }

  Future<void> hapus(String produkId) async {
    final ref = _ref;
    if (ref == null) throw 'Silakan masuk terlebih dahulu';
    await ref.doc(produkId).delete();
  }

  Future<void> ubahStatus(WishlistModel data) async {
    final ada = await cekSudahDisukai(data.produkId);
    if (ada) {
      await hapus(data.produkId);
    } else {
      await tambah(data);
    }
  }
}
