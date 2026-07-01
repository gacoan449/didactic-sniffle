import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengguna_model.dart';
import 'firebase_service.dart';

typedef VerifikasiKode = void Function(String verifikasiId);
typedef ErrorAuth = void Function(String pesan);

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
      'nama': nama, 'email': email, 'noHp': '', 'fotoUrl': '', 'dibuatPada': FieldValue.serverTimestamp(),
    });
    return kredensial.user!;
  }

  Future<User> masuk(String email, String sandi) async {
    return (await _auth.signInWithEmailAndPassword(email: email, password: sandi)).user!;
  }

  Future<User> masukGoogle() async {
    // TIDAK lagi memanggil signOut() agar akun tersimpan
    final akunGoogle = await _googleSignIn.signIn();
    if(akunGoogle == null) throw 'Masuk dibatalkan';
    final authGoogle = await akunGoogle.authentication;
    final kredensial = GoogleAuthProvider.credential(
      accessToken: authGoogle.accessToken, idToken: authGoogle.idToken,
    );
    final hasil = await _auth.signInWithCredential(kredensial);
    final user = hasil.user!;
    final doc = await _db.collection('pengguna').doc(user.uid).get();
    if(!doc.exists) {
      await _db.collection('pengguna').doc(user.uid).set({
        'nama': user.displayName ?? 'Pengguna Baru', 'email': user.email ?? '',
        'noHp': '', 'fotoUrl': user.photoURL ?? '', 'dibuatPada': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  Future<void> kirimOTP(String nomorHp, VerifikasiKode saatKirim, ErrorAuth saatError) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: nomorHp,
      verificationCompleted: (cred) async => await _auth.signInWithCredential(cred),
      verificationFailed: (e) => saatError(e.message ?? 'Terjadi kesalahan'),
      codeSent: (verifikasiId, _) => saatKirim(verifikasiId),
      codeAutoRetrievalTimeout: (verifikasiId) {},
    );
  }

  Future<User> verifikasiOTP(String verifikasiId, String kode, String nomorHp) async {
    final kredensial = PhoneAuthProvider.credential(verificationId: verifikasiId, smsCode: kode);
    final hasil = await _auth.signInWithCredential(kredensial);
    final user = hasil.user!;
    final doc = await _db.collection('pengguna').doc(user.uid).get();
    if(!doc.exists) {
      await _db.collection('pengguna').doc(user.uid).set({
        'nama': 'Pengguna ${nomorHp.replaceAll('+62', '0')}',
        'email': '',
        'noHp': nomorHp,
        'fotoUrl': '',
        'dibuatPada': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  Future<void> ubahSandi(String sandiLama, String sandiBaru) async {
    final user = _auth.currentUser;
    if(user == null) throw 'Harus masuk terlebih dahulu';
    final email = user.email;
    if(email == null) throw 'Akun ini tidak bisa ubah sandi';
    await _auth.signInWithEmailAndPassword(email: email, password: sandiLama);
    await user.updatePassword(sandiBaru);
    await user.reload();
  }

  Future<void> keluar() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> lupaSandi(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
