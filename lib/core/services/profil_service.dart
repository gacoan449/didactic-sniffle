import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_model.dart';
import 'firebase_service.dart';

class ProfilService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;

  Future<AuthModel?> ambilDataProfil() async {
    try {
      if (_auth.currentUser == null) throw 'Pengguna belum masuk';
      final uid = _auth.currentUser!.uid;

      final doc = await _db.collection('pengguna').doc(uid).get();
      if (!doc.exists) return null;

      return AuthModel.dariMap(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> perbaruiProfil(Map<String, dynamic> dataBaru) async {
    try {
      if (_auth.currentUser == null) throw 'Pengguna belum masuk';
      final uid = _auth.currentUser!.uid;

      // Perbarui nama di Firestore
      await _db.collection('pengguna').doc(uid).update(dataBaru);

      // Perbarui nama juga di Firebase Auth agar sama
      if (dataBaru.containsKey('nama')) {
        await _auth.currentUser?.updateDisplayName(dataBaru['nama']);
        await _auth.currentUser?.reload();
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot> streamProfil() {
    if (_auth.currentUser == null) {
      throw Exception('Pengguna belum masuk');
    }
    return _db.collection('pengguna').doc(_auth.currentUser!.uid).snapshots();
  }
}
