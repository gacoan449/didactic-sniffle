import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../config/timestamp_converter.dart';
import 'firestore_entity.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
class AuditLog with _$AuditLog implements FirestoreEntity {
  const AuditLog._();
  const factory AuditLog({
    @override required String id,
    @override @TimestampConverter() required DateTime dibuatPada,
    @override @TimestampConverter() required DateTime diperbaruiPada,
    @override required String dibuatOleh,
    @override required String diubahOleh,
    @override required int versiData,

    required String idPengguna,
    required String namaPengguna,
    required String aksi,
    required String koleksiTarget,
    required String idTarget,
    required Map<String, dynamic> dataLama,
    required Map<String, dynamic> dataBaru,
    required String alamatIP,
    required String perangkat,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);

  @override
  factory AuditLog.fromFirestore(DocumentSnapshot doc) =>
      FirestoreEntity.fromFirestore(doc, AuditLog.fromJson);

  @override
  Map<String, dynamic> toFirestore() => toJson();
}
