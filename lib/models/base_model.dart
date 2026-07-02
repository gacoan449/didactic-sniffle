import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_model.freezed.dart';

@freezed
class BaseModel with _$BaseModel {
  const factory BaseModel({
    required String id,
    required DateTime dibuatPada,
    required DateTime diperbaruiPada,
    required String dibuatOleh,
    required String diubahOleh,
  }) = _BaseModel;
}

// Fungsi bantuan konversi Timestamp
DateTime timestampToDate(dynamic value) =>
    (value as Timestamp?)?.toDate() ?? DateTime.now();

Timestamp dateToTimestamp(DateTime date) => Timestamp.fromDate(date);
