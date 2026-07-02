import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusVerifikasi { belumDaftar, menunggu, disetujui, ditolak }

enum JenisTanggungOngkir {
  supplier,
  pembeli,
  gratis,
  berdasarkanBerat,
  berdasarkanJarak,
}

class TokoSupplierModel {
  final String id;
  final String namaToko;
  final String deskripsi;
  final String alamatLengkap;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String kodePos;
  final double latitude;
  final double longitude;
  final double radiusPengirimanKm;
  final double jarakKeGudangUtama;
  final String namaPemilik;
  final String nomorHP;
  final String fotoProfil;
  final List<String> fotoGudang;
  final List<String> fotoLahan;
  final List<String> fotoTimbangan;
  final List<String> fotoProdukContoh;
  final String jadwalPanen;
  final DateTime? tglPanen;
  final DateTime? estimasiSiapAngkut;
  final double estimasiBeratTotal;
  final int minimalOrder;
  final String catatanPanen;
  final JenisTanggungOngkir aturanOngkir;
  final String namaBank;
  final String nomorRekening;
  final String namaPemilikRekening;
  final String urlKtp;
  final String urlSelfieKtp;
  final String? urlNpwp;
  final String urlDokumenRekening;
  final StatusVerifikasi statusVerifikasi;
  final String catatanVerifikasi;
  final double rating;
  final int jumlahUlasan;
  final int jumlahProduk;
  final int jumlahTerjual;
  final int totalPickupBerhasil;
  final double totalBeratDikirim;
  final double totalOmzet;
  final double totalPencairan;
  final double saldo;
  final DateTime dibuatPada;
  final DateTime? diperbaruiPada;

  const TokoSupplierModel({
    required this.id,
    required this.namaToko,
    required this.deskripsi,
    required this.alamatLengkap,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.kodePos,
    required this.latitude,
    required this.longitude,
    required this.radiusPengirimanKm,
    required this.jarakKeGudangUtama,
    required this.namaPemilik,
    required this.nomorHP,
    required this.fotoProfil,
    required this.fotoGudang,
    required this.fotoLahan,
    required this.fotoTimbangan,
    required this.fotoProdukContoh,
    required this.jadwalPanen,
    required this.tglPanen,
    required this.estimasiSiapAngkut,
    required this.estimasiBeratTotal,
    required this.minimalOrder,
    required this.catatanPanen,
    required this.aturanOngkir,
    required this.namaBank,
    required this.nomorRekening,
    required this.namaPemilikRekening,
    required this.urlKtp,
    required this.urlSelfieKtp,
    this.urlNpwp,
    required this.urlDokumenRekening,
    required this.statusVerifikasi,
    required this.catatanVerifikasi,
    required this.rating,
    required this.jumlahUlasan,
    required this.jumlahProduk,
    required this.jumlahTerjual,
    required this.totalPickupBerhasil,
    required this.totalBeratDikirim,
    required this.totalOmzet,
    required this.totalPencairan,
    required this.saldo,
    required this.dibuatPada,
    this.diperbaruiPada,
  });

  Map<String, dynamic> keMap() => {
    'namaToko': namaToko,
    'deskripsi': deskripsi,
    'alamatLengkap': alamatLengkap,
    'provinsi': provinsi,
    'kabupaten': kabupaten,
    'kecamatan': kecamatan,
    'kodePos': kodePos,
    'latitude': latitude,
    'longitude': longitude,
    'radiusPengirimanKm': radiusPengirimanKm,
    'jarakKeGudangUtama': jarakKeGudangUtama,
    'namaPemilik': namaPemilik,
    'nomorHP': nomorHP,
    'fotoProfil': fotoProfil,
    'fotoGudang': fotoGudang,
    'fotoLahan': fotoLahan,
    'fotoTimbangan': fotoTimbangan,
    'fotoProdukContoh': fotoProdukContoh,
    'jadwalPanen': jadwalPanen,
    'tglPanen': tglPanen == null ? null : Timestamp.fromDate(tglPanen!),
    'estimasiSiapAngkut': estimasiSiapAngkut == null
        ? null
        : Timestamp.fromDate(estimasiSiapAngkut!),
    'estimasiBeratTotal': estimasiBeratTotal,
    'minimalOrder': minimalOrder,
    'catatanPanen': catatanPanen,
    'aturanOngkir': aturanOngkir.name,
    'namaBank': namaBank,
    'nomorRekening': nomorRekening,
    'namaPemilikRekening': namaPemilikRekening,
    'urlKtp': urlKtp,
    'urlSelfieKtp': urlSelfieKtp,
    'urlNpwp': urlNpwp,
    'urlDokumenRekening': urlDokumenRekening,
    'statusVerifikasi': statusVerifikasi.name,
    'catatanVerifikasi': catatanVerifikasi,
    'rating': rating,
    'jumlahUlasan': jumlahUlasan,
    'jumlahProduk': jumlahProduk,
    'jumlahTerjual': jumlahTerjual,
    'totalPickupBerhasil': totalPickupBerhasil,
    'totalBeratDikirim': totalBeratDikirim,
    'totalOmzet': totalOmzet,
    'totalPencairan': totalPencairan,
    'saldo': saldo,
    'dibuatPada': Timestamp.fromDate(dibuatPada),
    'diperbaruiPada': diperbaruiPada == null
        ? null
        : Timestamp.fromDate(diperbaruiPada!),
  };

  factory TokoSupplierModel.dariMap(
    Map<String, dynamic> map,
    String docId,
  ) => TokoSupplierModel(
    id: docId,
    namaToko: map['namaToko']?.toString() ?? '',
    deskripsi: map['deskripsi']?.toString() ?? '',
    alamatLengkap: map['alamatLengkap']?.toString() ?? '',
    provinsi: map['provinsi']?.toString() ?? '',
    kabupaten: map['kabupaten']?.toString() ?? '',
    kecamatan: map['kecamatan']?.toString() ?? '',
    kodePos: map['kodePos']?.toString() ?? '',
    latitude: (map['latitude'] as num?)?.toDouble() ?? -6.966667,
    longitude: (map['longitude'] as num?)?.toDouble() ?? 110.416664,
    radiusPengirimanKm: (map['radiusPengirimanKm'] as num?)?.toDouble() ?? 10,
    jarakKeGudangUtama: (map['jarakKeGudangUtama'] as num?)?.toDouble() ?? 0,
    namaPemilik: map['namaPemilik']?.toString() ?? '',
    nomorHP: map['nomorHP']?.toString() ?? '',
    fotoProfil: map['fotoProfil']?.toString() ?? '',
    fotoGudang: List<String>.from(map['fotoGudang'] ?? []),
    fotoLahan: List<String>.from(map['fotoLahan'] ?? []),
    fotoTimbangan: List<String>.from(map['fotoTimbangan'] ?? []),
    fotoProdukContoh: List<String>.from(map['fotoProdukContoh'] ?? []),
    jadwalPanen: map['jadwalPanen']?.toString() ?? 'Belum diatur',
    tglPanen: (map['tglPanen'] as Timestamp?)?.toDate(),
    estimasiSiapAngkut: (map['estimasiSiapAngkut'] as Timestamp?)?.toDate(),
    estimasiBeratTotal: (map['estimasiBeratTotal'] as num?)?.toDouble() ?? 0,
    minimalOrder: (map['minimalOrder'] as num?)?.toInt() ?? 1,
    catatanPanen: map['catatanPanen']?.toString() ?? '',
    aturanOngkir: JenisTanggungOngkir.values.firstWhere(
      (e) => e.name == map['aturanOngkir'],
      orElse: () => JenisTanggungOngkir.pembeli,
    ),
    namaBank: map['namaBank']?.toString() ?? '',
    nomorRekening: map['nomorRekening']?.toString() ?? '',
    namaPemilikRekening: map['namaPemilikRekening']?.toString() ?? '',
    urlKtp: map['urlKtp']?.toString() ?? '',
    urlSelfieKtp: map['urlSelfieKtp']?.toString() ?? '',
    urlNpwp: map['urlNpwp']?.toString(),
    urlDokumenRekening: map['urlDokumenRekening']?.toString() ?? '',
    statusVerifikasi: StatusVerifikasi.values.firstWhere(
      (e) => e.name == map['statusVerifikasi'],
      orElse: () => StatusVerifikasi.belumDaftar,
    ),
    catatanVerifikasi: map['catatanVerifikasi']?.toString() ?? '',
    rating: (map['rating'] as num?)?.toDouble() ?? 0,
    jumlahUlasan: (map['jumlahUlasan'] as num?)?.toInt() ?? 0,
    jumlahProduk: (map['jumlahProduk'] as num?)?.toInt() ?? 0,
    jumlahTerjual: (map['jumlahTerjual'] as num?)?.toInt() ?? 0,
    totalPickupBerhasil: (map['totalPickupBerhasil'] as num?)?.toInt() ?? 0,
    totalBeratDikirim: (map['totalBeratDikirim'] as num?)?.toDouble() ?? 0,
    totalOmzet: (map['totalOmzet'] as num?)?.toDouble() ?? 0,
    totalPencairan: (map['totalPencairan'] as num?)?.toDouble() ?? 0,
    saldo: (map['saldo'] as num?)?.toDouble() ?? 0,
    dibuatPada: (map['dibuatPada'] as Timestamp?)?.toDate() ?? DateTime.now(),
    diperbaruiPada: (map['diperbaruiPada'] as Timestamp?)?.toDate(),
  );
}
