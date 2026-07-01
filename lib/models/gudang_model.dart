import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusGudang { aktif, tutup, perawatan }

class GudangModel {
  final String id;
  final String namaGudang;
  final String alamat;
  final double latitude;
  final double longitude;
  final double kapasitasMaksimalKg;
  final double terpakaiKg;
  final List<String> idPetugas;
  final StatusGudang status;
  final DateTime dibuatPada;

  const GudangModel({
    required this.id,
    required this.namaGudang,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.kapasitasMaksimalKg,
    required this.terpakaiKg,
    required this.idPetugas,
    required this.status,
    required this.dibuatPada,
  });

  factory GudangModel.dariMap(
    Map<String, dynamic> map,
    String docId,
  ) => GudangModel(
    id: docId,
    namaGudang: map['namaGudang']?.toString() ?? '',
    alamat: map['alamat']?.toString() ?? '',
    latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
    longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    kapasitasMaksimalKg: (map['kapasitasMaksimalKg'] as num?)?.toDouble() ?? 0,
    terpakaiKg: (map['terpakaiKg'] as num?)?.toDouble() ?? 0,
    idPetugas: List<String>.from(map['idPetugas'] ?? []),
    status: StatusGudang.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => StatusGudang.aktif,
    ),
    dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
