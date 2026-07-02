import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) {
      try { return DateTime.parse(json); }
      catch (_) => throw FormatException("Format tanggal tidak valid: $json");
    }
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    throw ArgumentError("Tipe data tanggal tidak didukung: ${json.runtimeType}");
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}
