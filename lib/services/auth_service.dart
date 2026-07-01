import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengguna_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = LayananFirebase.auth;
  final FirebaseFirestore _db = LayananFirebase.db;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get penggunaSaatIni => _auth.currentUser;
  Stream<User?> get aliranPengguna => _auth.authStateChanges();

  Future<User> daftar(String email, String sandi, String nama) async {
    final kredensial = await _auth.createUserWithEmailAndPassword(email: email, password: sandi);
    final uid = kredensial.user!.uid;

    await kredensial.user!.updateDisplayName(nama);
    await kredensial.user!.reload();

    await _db.collection('pengguna').doc(uid).set({
      'nama': nama,
      'email': email,
      'noHp': '',
      'fotoUrl': '',
      'dibuatPada': FieldValue.serverTimestamp(),
    });

    return kredensial.user!;
  }

  Future<User> masuk(String email, String sandi) async {
    final kredensial = await _auth.signInWithEmailAndPassword(email: email, password: sandi);
    return kredensial.user!;
  }

  Future<User> masukGoogle() async {
    final akunGoogle = await _googleSignIn.signIn();
    if(akunGoogle == null) throw 'Masuk dibatalkan';

    final authGoogle = await akunGoogle.authentication;
    final kredensial = GoogleAuthProvider.credential(
      accessToken: authGoogle.accessToken,
      idToken: authGoogle.idToken,
    );

    final hasil = await _auth.signInWithCredential(kredensial);
    final user = hasil.user!;

    final doc = await _db.collection('pengguna').doc(user.uid).get();
    if(!doc.exists) {
      await _db.collection('pengguna').doc(user.uid).set({
        'nama': user.displayName ?? 'Pengguna Baru',
        'email': user.email ?? '',
        'noHp': '',
        'fotoUrl': user.photoURL ?? '',
        'dibuatPada': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  Future<void> keluar() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> lupaSandi(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
