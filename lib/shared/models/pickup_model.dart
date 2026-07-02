import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusPickup {
  menunggu,
  sopirDitugaskan,
  sopirMenuju,
  barangDiambil,
  sampaiGudang,
  selesai,
  dibatalkan,
}

enum HasilPemeriksaan { diterima, ditolak, potongHarga }

class PickupModel {
  final String id;
  final String kodePickup;
  final String supplierId;
  final String namaSupplier;
  final String alamatSupplier;
  final String? sopirId;
  final String? namaSopir;
  final String gudangTujuanId;
  final String namaGudangTujuan;
  final DateTime tanggalPickup;
  final String jamPickup;
  final String catatanSupplier;
  final List<Map<String, dynamic>> daftarProduk;
  final double estimasiBerat;
  final StatusPickup status;
  final String qrCodePickup;
  final DateTime? waktuSopirDatang;
  final DateTime? waktuDiambil;
  final List<String> fotoBarangDiambil;
  final List<String> fotoTimbanganDiambil;
  final String? tandaTanganSupplier;
  final String? tandaTanganSopir;
  final HasilPemeriksaan? hasilCek;
  final double beratAktual;
  final String catatanPetugasGudang;
  final List<String> fotoPemeriksaan;
  final DateTime? waktuSampaiGudang;
  final DateTime dibuatPada;

  const PickupModel({
    required this.id,
    required this.kodePickup,
    required this.supplierId,
    required this.namaSupplier,
    required this.alamatSupplier,
    this.sopirId,
    this.namaSopir,
    required this.gudangTujuanId,
    required this.namaGudangTujuan,
    required this.tanggalPickup,
    required this.jamPickup,
    required this.catatanSupplier,
    required this.daftarProduk,
    required this.estimasiBerat,
    required this.status,
    required this.qrCodePickup,
    this.waktuSopirDatang,
    this.waktuDiambil,
    required this.fotoBarangDiambil,
    required this.fotoTimbanganDiambil,
    this.tandaTanganSupplier,
    this.tandaTanganSopir,
    this.hasilCek,
    required this.beratAktual,
    required this.catatanPetugasGudang,
    required this.fotoPemeriksaan,
    this.waktuSampaiGudang,
    required this.dibuatPada,
  });

  Map<String, dynamic> keMap() => {
    'kodePickup': kodePickup,
    'supplierId': supplierId,
    'namaSupplier': namaSupplier,
    'alamatSupplier': alamatSupplier,
    'sopirId': sopirId,
    'namaSopir': namaSopir,
    'gudangTujuanId': gudangTujuanId,
    'namaGudangTujuan': namaGudangTujuan,
    'tanggalPickup': Timestamp.fromDate(tanggalPickup),
    'jamPickup': jamPickup,
    'catatanSupplier': catatanSupplier,
    'daftarProduk': daftarProduk,
    'estimasiBerat': estimasiBerat,
    'status': status.name,
    'qrCodePickup': qrCodePickup,
    'waktuSopirDatang': waktuSopirDatang == null
        ? null
        : Timestamp.fromDate(waktuSopirDatang!),
    'waktuDiambil': waktuDiambil == null
        ? null
        : Timestamp.fromDate(waktuDiambil!),
    'fotoBarangDiambil': fotoBarangDiambil,
    'fotoTimbanganDiambil': fotoTimbanganDiambil,
    'tandaTanganSupplier': tandaTanganSupplier,
    'tandaTanganSopir': tandaTanganSopir,
    'hasilCek': hasilCek?.name,
    'beratAktual': beratAktual,
    'catatanPetugasGudang': catatanPetugasGudang,
    'fotoPemeriksaan': fotoPemeriksaan,
    'waktuSampaiGudang': waktuSampaiGudang == null
        ? null
        : Timestamp.fromDate(waktuSampaiGudang!),
    'dibuatPada': Timestamp.fromDate(dibuatPada),
  };

  factory PickupModel.dariMap(
    Map<String, dynamic> map,
    String docId,
  ) => PickupModel(
    id: docId,
    kodePickup: map['kodePickup']?.toString() ?? '',
    supplierId: map['supplierId']?.toString() ?? '',
    namaSupplier: map['namaSupplier']?.toString() ?? '',
    alamatSupplier: map['alamatSupplier']?.toString() ?? '',
    sopirId: map['sopirId']?.toString(),
    namaSopir: map['namaSopir']?.toString(),
    gudangTujuanId: map['gudangTujuanId']?.toString() ?? '',
    namaGudangTujuan: map['namaGudangTujuan']?.toString() ?? '',
    tanggalPickup:
        (map['tanggalPickup'] as Timestamp?)?.toDate() ?? DateTime.now(),
    jamPickup: map['jamPickup']?.toString() ?? '08:00 - 12:00',
    catatanSupplier: map['catatanSupplier']?.toString() ?? '',
    daftarProduk: List<Map<String, dynamic>>.from(map['daftarProduk'] ?? []),
    estimasiBerat: (map['estimasiBerat'] as num?)?.toDouble() ?? 0,
    status: StatusPickup.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => StatusPickup.menunggu,
    ),
    qrCodePickup: map['qrCodePickup']?.toString() ?? '',
    waktuSopirDatang: (map['waktuSopirDatang'] as Timestamp?)?.toDate(),
    waktuDiambil: (map['waktuDiambil'] as Timestamp?)?.toDate(),
    fotoBarangDiambil: List<String>.from(map['fotoBarangDiambil'] ?? []),
    fotoTimbanganDiambil: List<String>.from(map['fotoTimbanganDiambil'] ?? []),
    tandaTanganSupplier: map['tandaTanganSupplier']?.toString(),
    tandaTanganSopir: map['tandaTanganSopir']?.toString(),
    hasilCek: map['hasilCek'] == null
        ? null
        : HasilPemeriksaan.values.firstWhere((e) => e.name == map['hasilCek']),
    beratAktual: (map['beratAktual'] as num?)?.toDouble() ?? 0,
    catatanPetugasGudang: map['catatanPetugasGudang']?.toString() ?? '',
    fotoPemeriksaan: List<String>.from(map['fotoPemeriksaan'] ?? []),
    waktuSampaiGudang: (map['waktuSampaiGudang'] as Timestamp?)?.toDate(),
    dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
