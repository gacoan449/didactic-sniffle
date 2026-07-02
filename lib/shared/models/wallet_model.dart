class WalletModel {
  final String idPengguna;
  final double saldo;
  final List<Map<String, dynamic>> riwayat;

  const WalletModel({
    required this.idPengguna,
    required this.saldo,
    required this.riwayat,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      idPengguna: map['idPengguna'] as String,
      saldo: (map['saldo'] as num).toDouble(),
      riwayat: List<Map<String, dynamic>>.from(map['riwayat'] as List),
    );
  }

  Map<String, dynamic> keMap() => {
    'idPengguna': idPengguna,
    'saldo': saldo,
    'riwayat': riwayat,
  };
}
