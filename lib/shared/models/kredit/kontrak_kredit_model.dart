import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../config/enum.dart';
import '../../config/timestamp_converter.dart';
import '../../entities/firestore_entity.dart';
import '../kredit/pembayaran_kredit.dart';

part 'kontrak_kredit_model.freezed.dart';
part 'kontrak_kredit_model.g.dart';

@freezed
class KontrakKredit with _$KontrakKredit implements FirestoreEntity {
  const KontrakKredit._();
  const factory KontrakKredit({
    @override required String id,
    @override @TimestampConverter() required DateTime dibuatPada,
    @override @TimestampConverter() required DateTime diperbaruiPada,
    @override required String dibuatOleh,
    @override required String diubahOleh,
    @override required int versiData,

    required String idPengguna,
    required String idPengajuan,
    required int limitDisetujui,
    required int tenorBulan,
    required double sukuBungaPerBulan,
    required List<JadwalAngsuran> jadwalAngsuran,
    required List<PersetujuanAdmin> riwayatPersetujuan,
    required List<PembayaranKredit> riwayatPembayaran,
    required StatusKontrakKredit status,
  }) = _KontrakKredit;

  factory KontrakKredit.fromJson(Map<String, dynamic> json) =>
      _$KontrakKreditFromJson(json);

  @override
  factory KontrakKredit.fromFirestore(DocumentSnapshot doc) =>
      KontrakKredit.fromJson(
        doc.data() as Map<String, dynamic>,
      ).copyWith(id: doc.id);

  @override
  Map<String, dynamic> toFirestore() => toJson();
}
