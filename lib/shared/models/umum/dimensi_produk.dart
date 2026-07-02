import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimensi_produk.freezed.dart';
part 'dimensi_produk.g.dart';

@freezed
class DimensiProduk with _$DimensiProduk {
  const factory DimensiProduk({
    required double beratKg,
    required double panjangCm,
    required double lebarCm,
    required double tinggiCm,
  }) = _DimensiProduk;
  factory DimensiProduk.fromJson(Map<String, dynamic> json) =>
      _$DimensiProdukFromJson(json);
}
