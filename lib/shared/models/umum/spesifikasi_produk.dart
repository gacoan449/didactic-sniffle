import 'package:freezed_annotation/freezed_annotation.dart';

part 'spesifikasi_produk.freezed.dart';
part 'spesifikasi_produk.g.dart';

@freezed
class SpesifikasiProduk with _$SpesifikasiProduk {
  const factory SpesifikasiProduk({
    required String nama,
    required String nilai,
  }) = _SpesifikasiProduk;
  factory SpesifikasiProduk.fromJson(Map<String, dynamic> json) =>
      _$SpesifikasiProdukFromJson(json);
}
