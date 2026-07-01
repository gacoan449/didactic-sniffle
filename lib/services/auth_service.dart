import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = LayananFirebase.auth;
  final FirebaseFirestore _db = LayananFirebase.db;

  Future<User?> daftar(AuthModel data, String sandi) async {
    try {
      final akun = await _auth.createUserWithEmailAndPassword(
        email: data.email,
        password: sandi,
      );
      
      // Kirim email verifikasi
      await akun.user!.sendEmailVerification();

      await _db.collection('pengguna').doc(akun.user!.uid).set(
        data.keMap()..['uid'] = akun.user!.uid,
      );
      return akun.user;
    } catch (e) { debugPrint('Error Daftar: $e'); rethrow; }
  }

  Future<User?> masuk(String email, String sandi) async {
    try {
      final akun = await _auth.signInWithEmailAndPassword(
        email: email, password: sandi,
      );
      // Cek apakah email sudah diverifikasi
      if (!akun.user!.emailVerified) {
        await _auth.signOut();
        throw 'Silakan cek email Anda untuk verifikasi akun terlebih dahulu';
      }
      return akun.user;
    } catch (e) { debugPrint('Error Masuk: $e'); rethrow; }
  }

  Future<void> keluar() async => await _auth.signOut();
  Stream<User?> get status => _auth.authStateChanges();
}
