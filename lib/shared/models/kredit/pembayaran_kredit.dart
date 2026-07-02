import 'package:freezed_annotation/freezed_annotation.dart';
import '../../config/timestamp_converter.dart';

part 'pembayaran_kredit.freezed.dart';
part 'pembayaran_kredit.g.dart';

@freezed
class PembayaranKredit with _$PembayaranKredit {
  const factory PembayaranKredit({
    required String idPembayaran,
    required int jumlahBayar,
    @TimestampConverter() required DateTime tanggalBayar,
    required String noReferensi,
  }) = _PembayaranKredit;
  factory PembayaranKredit.fromJson(Map<String, dynamic> json) =>
      _$PembayaranKreditFromJson(json);
}
