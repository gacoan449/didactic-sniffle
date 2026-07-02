import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wallet_service.dart';
import '../services/pembayaran_service.dart';
import '../models/wallet_transaksi_model.dart';

final layananDompetProvider = Provider<LayananDompet>((ref) => LayananDompet());
final layananPembayaranProvider = Provider<LayananPembayaran>(
  (ref) => LayananPembayaran(),
);

final saldoDompetProvider = FutureProvider.family<int, String>((
  ref,
  penggunaId,
) async {
  return ref.watch(layananDompetProvider).cekSaldo(penggunaId);
});

final riwayatDompetProvider =
    FutureProvider.family<List<WalletTransaksiModel>, String>((
      ref,
      penggunaId,
    ) async {
      return ref.watch(layananDompetProvider).ambilRiwayat(penggunaId);
    });
