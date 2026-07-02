import 'package:freezed_annotation/freezed_annotation.dart';
import '../../config/konstanta.dart';
import '../../config/enum.dart';
import '../base_model.dart';

part 'dompet_model.freezed.dart';
part 'dompet_model.g.dart';

@freezed
class Dompet with _$Dompet implements BaseModel {
  const factory Dompet({
    @override required String id,
    @override required DateTime dibuatPada,
    @override required DateTime diperbaruiPada,
    @override required String dibuatOleh,
    @override required String diubahOleh,

    required String idPengguna,
    required int saldoTersedia,
    required int saldoDitahan,
    required int saldoPending,
    required String pinHash,
    required StatusDompet status,
  }) = _Dompet;

  factory Dompet.fromJson(Map<String, dynamic> json) => _$DompetFromJson(json);
}
