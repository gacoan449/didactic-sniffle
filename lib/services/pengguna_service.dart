import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/pengguna_model.dart';
import 'firebase_service.dart';

class PenggunaService {
  final FirebaseFirestore _db = LayananFirebase.db;
  final FirebaseAuth _auth = LayananFirebase.auth;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  DocumentReference<Map<String,dynamic>> get _ref {
    final uid = _auth.currentUser?.uid;
    if(uid == null) throw 'Silakan masuk terlebih dahulu';
    return _db.collection('pengguna').doc(uid);
  }

  Stream<PenggunaModel> ambilData() {
    return _ref.snapshots().map((snap) {
      if(!snap.exists) return PenggunaModel.kosong();
      return PenggunaModel.dariMap(snap.data()!, snap.id);
    });
  }

  Future<void> simpanData(PenggunaModel data) async {
    await _ref.set(data.keMap(), SetOptions(merge: true));
  }

  Future<String> unggahFoto(XFile file) async {
    final uid = _auth.currentUser?.uid;
    if(uid == null) throw 'Silakan masuk terlebih dahulu';

    // Validasi ukuran maksimal 2 MB
    final fileBytes = await file.readAsBytes();
    if(fileBytes.length > 2 * 1024 * 1024) throw 'Ukuran foto maksimal 2 MB';

    // Validasi format
    final ekstensi = file.name.toLowerCase().split('.').last;
    if(!['jpg','jpeg','png'].contains(ekstensi)) throw 'Format harus JPG atau PNG';

    // Pakai nama tetap agar foto lama otomatis terganti
    final ref = _storage.ref('profil/$uid.jpg');
    await ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }
}
