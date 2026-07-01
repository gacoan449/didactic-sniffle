import 'peran_pengguna.dart';

class UserModel {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final PeranPengguna peran;
  final DateTime dibuatPada;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.peran,
    required this.dibuatPada,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      nama: map['nama'] as String,
      email: map['email'] as String,
      noHp: map['noHp'] as String,
      peran: PeranPengguna.values.byName(map['peran']),
      dibuatPada: DateTime.parse(map['dibuatPada'] as String),
    );
  }

  Map<String, dynamic> keMap() => {
    'id': id,
    'nama': nama,
    'email': email,
    'noHp': noHp,
    'peran': peran.name,
    'dibuatPada': dibuatPada.toIso8601String(),
  };
}
