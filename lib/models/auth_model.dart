class AuthModel {
  final String? uid;
  final String nama;
  final String email;
  final String noHp;
  final String peran;
  final DateTime dibuatPada;

  const AuthModel({
    this.uid,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.peran,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    'uid': uid,
    'nama': nama,
    'email': email,
    'noHp': noHp,
    'peran': peran,
    'dibuatPada': dibuatPada.toIso8601String(),
  };

  factory AuthModel.dariMap(Map<String, dynamic> map) {
    return AuthModel(
      uid: map['uid'],
      nama: map['nama'],
      email: map['email'],
      noHp: map['noHp'],
      peran: map['peran'] ?? 'pembeli',
      dibuatPada: DateTime.parse(map['dibuatPada']),
    );
  }
}
