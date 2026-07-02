import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is Map)
      return Timestamp(json['_seconds'], json['_nanoseconds']).toDate();
    throw const FormatException("Format tanggal tidak valid");
  }

  @override
  Object? toJson(DateTime? waktu) {
    if (waktu == null) return null;
    return Timestamp.fromDate(waktu);
  }
}
