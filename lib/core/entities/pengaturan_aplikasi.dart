import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../config/timestamp_converter.dart';
import 'firestore_entity.dart';

part 'pengaturan_aplikasi.freezed.dart';
part 'pengaturan_aplikasi.g.dart';

@freezed
class PengaturanAplikasi with _$PengaturanAplikasi implements FirestoreEntity {
  const PengaturanAplikasi._();
  const factory PengaturanAplikasi({
    @override required String id,
    @override @TimestampConverter() required DateTime dibuatPada,
    @override @TimestampConverter() required DateTime diperbaruiPada,
    @override required String dibuatOleh,
    @override required String diubahOleh,
    @override required int versiData,

    required bool modePemeliharaan,
    required String pesanPemeliharaan,
    required double persentasePajak,
    required int biayaAsuransiBawaan,
    required Map<String, int> tarifOngkirDasar,
    required Map<String, dynamic> konfigurasiAI,
    required int batasMaksimalUnggahFile,
  }) = _PengaturanAplikasi;

  factory PengaturanAplikasi.fromJson(Map<String, dynamic> json) =>
      _$PengaturanAplikasiFromJson(json);

  @override
  factory PengaturanAplikasi.fromFirestore(DocumentSnapshot doc) =>
      FirestoreEntity.fromFirestore(doc, PengaturanAplikasi.fromJson);

  @override
  Map<String, dynamic> toFirestore() => toJson();
}
