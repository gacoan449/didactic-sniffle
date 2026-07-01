import 'package:cloud_firestore/cloud_firestore.dart';

class PenggunaModel {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final String fotoUrl;
  final DateTime dibuatPada;

  const PenggunaModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.fotoUrl,
    required this.dibuatPada,
  });

  factory PenggunaModel.kosong() => PenggunaModel(
    id: '',
    nama: '',
    email: '',
    noHp: '',
    fotoUrl: '',
    dibuatPada: DateTime.now(),
  );

  Map<String, dynamic> keMap() => {
    'nama': nama,
    'email': email,
    'noHp': noHp,
    'fotoUrl': fotoUrl,
    'dibuatPada': dibuatPada,
  };

  factory PenggunaModel.dariMap(Map<String, dynamic> map, String docId) {
    return PenggunaModel(
      id: docId,
      nama: map['nama']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      noHp: map['noHp']?.toString() ?? '',
      fotoUrl: map['fotoUrl']?.toString() ?? '',
      dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
