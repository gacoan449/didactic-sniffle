import 'package:freezed_annotation/freezed_annotation.dart';
import '../../config/konstanta.dart';
import '../../config/enum.dart';
import '../base_model.dart';

part 'kas_model.freezed.dart';
part 'kas_model.g.dart';

@freezed
class Kas with _$Kas implements BaseModel {
  const factory Kas({
    @override required String id,
    @override required DateTime dibuatPada,
    @override required DateTime diperbaruiPada,
    @override required String dibuatOleh,
    @override required String diubahOleh,

    required String idToko,
    required String namaToko,
    required DateTime tanggalBuka,
    DateTime? tanggalTutup,
    required String idKasirBuka,
    required String namaKasirBuka,
    String? idKasirTutup,
    String? namaKasirTutup,
    required int saldoAwal,
    required int totalMasuk,
    required int totalKeluar,
    required int saldoAkhir,
    required int selisih,
    required String catatan,
    required List<String> daftarIdTransaksi,
    required StatusKas status,
  }) = _Kas;

  factory Kas.fromJson(Map<String, dynamic> json) => _$KasFromJson(json);
  factory Kas.fromMap(String id, Map<String, dynamic> data) => Kas(
    id: id,
    dibuatPada: timestampToDate(data[Konstanta.KUNCI_DIBUAT_PADA]),
    diperbaruiPada: timestampToDate(data[Konstanta.KUNCI_DIPERBARUI_PADA]),
    dibuatOleh: data[Konstanta.KUNCI_DIBUAT_OLEH] ?? '',
    diubahOleh: data[Konstanta.KUNCI_DIUBAH_OLEH] ?? '',
    idToko: data[Konstanta.KUNCI_ID_TOKO] ?? '',
    namaToko: data[Konstanta.KUNCI_NAMA_TOKO] ?? '',
    tanggalBuka: timestampToDate(data['tanggalBuka']),
    tanggalTutup: data['tanggalTutup'] != null
        ? timestampToDate(data['tanggalTutup'])
        : null,
    idKasirBuka: data['idKasirBuka'] ?? '',
    namaKasirBuka: data['namaKasirBuka'] ?? '',
    idKasirTutup: data['idKasirTutup'],
    namaKasirTutup: data['namaKasirTutup'],
    saldoAwal: (data['saldoAwal'] ?? 0).toInt(),
    totalMasuk: (data['totalMasuk'] ?? 0).toInt(),
    totalKeluar: (data['totalKeluar'] ?? 0).toInt(),
    saldoAkhir: (data['saldoAkhir'] ?? 0).toInt(),
    selisih: (data['selisih'] ?? 0).toInt(),
    catatan: data[Konstanta.KUNCI_KETERANGAN] ?? '',
    daftarIdTransaksi: List<String>.from(data['daftarIdTransaksi'] ?? []),
    status: StatusKas.values.firstWhere(
      (e) => e.name == data[Konstanta.KUNCI_STATUS],
      orElse: () => StatusKas.buka,
    ),
  );
}
