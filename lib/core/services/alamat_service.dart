import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/alamat_model.dart';
import 'firebase_service.dart';

class AlamatService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  CollectionReference<Map<String, dynamic>> get _ref {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw 'Silakan masuk terlebih dahulu';
    return _db.collection('pengguna').doc(uid).collection('alamat');
  }

  Stream<List<AlamatModel>> ambilSemua() {
    return _ref
        .orderBy('utama', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AlamatModel.dariMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> simpan(AlamatModel alamat) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw 'Silakan masuk terlebih dahulu';

    await _db.runTransaction((trx) async {
      if (alamat.utama) {
        final daftarUtama = await trx.get(_ref.where('utama', isEqualTo: true));
        for (final d in daftarUtama.docs) {
          trx.update(d.reference, {'utama': false});
        }
      }

      if (alamat.id == null) {
        trx.set(_ref.doc(), alamat.keMap());
      } else {
        trx.update(_ref.doc(alamat.id), alamat.keMap());
      }
    });
  }

  Future<void> hapus(String id) async {
    await _db.runTransaction((trx) async {
      final docHapus = _ref.doc(id);
      final dataHapus = await trx.get(docHapus);
      final adalahUtama = (dataHapus.data()?['utama'] ?? false) == true;

      trx.delete(docHapus);

      if (adalahUtama) {
        final sisa = await trx.get(_ref.limit(1));
        if (sisa.docs.isNotEmpty) {
          trx.update(sisa.docs.first.reference, {'utama': true});
        }
      }
    });
  }
}
