import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaksi_model.dart';
import '../services/wallet_service.dart';
import 'auth_provider.dart';

final layananDompetProvider = Provider<LayananDompet>((ref) => LayananDompet());

final dompetSayaProvider = FutureProvider<DompetModel>((ref) async {
  final pengguna = ref.watch(penggunaSaatIniProvider);
  if (pengguna == null || pengguna.id.isEmpty)
    throw 'Silakan masuk akun terlebih dahulu';
  return ref.read(layananDompetProvider).ambilAtauBuat(pengguna.id);
});

final riwayatDompetProvider = FutureProvider<List<WalletTransaksiModel>>((
  ref,
) async {
  final pengguna = ref.watch(penggunaSaatIniProvider);
  if (pengguna == null || pengguna.id.isEmpty) return [];
  return ref.read(layananDompetProvider).ambilRiwayat(pengguna.id);
});
