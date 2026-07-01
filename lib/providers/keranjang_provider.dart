import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/keranjang_item.dart';
import '../services/keranjang_service.dart';

final keranjangServiceProvider = Provider<KeranjangService>(
  (ref) => KeranjangService(),
);

final keranjangProvider =
    StateNotifierProvider<KeranjangNotifier, List<KeranjangItem>>((ref) {
      return KeranjangNotifier(ref.watch(keranjangServiceProvider));
    });

class KeranjangNotifier extends StateNotifier<List<KeranjangItem>> {
  final KeranjangService _lay;
  KeranjangNotifier(this._lay) : super([]) {
    muatDariDb();
  }

  Future<void> muatDariDb() async {
    state = await _lay.ambilSemua();
  }

  Future<void> tambah(KeranjangItem barang) async {
    final ada = state.indexWhere((b) => b.produkId == barang.produkId);
    KeranjangItem barangBaru;

    if (ada >= 0) {
      final lama = state[ada];
      barangBaru = lama.ubahJumlah(
        lama.jumlah + 1 <= lama.stokTersedia
            ? lama.jumlah + 1
            : lama.stokTersedia,
      );
      state = [...state]..[ada] = barangBaru;
    } else {
      barangBaru = barang.ubahJumlah(1);
      state = [...state, barangBaru];
    }
    await _lay.simpan(barangBaru);
  }

  Future<void> kurangi(String produkId) async {
    final ada = state.indexWhere((b) => b.produkId == produkId);
    if (ada < 0) return;
    final lama = state[ada];

    if (lama.jumlah <= 1) {
      await hapus(produkId);
      return;
    }

    final baru = lama.ubahJumlah(lama.jumlah - 1);
    state = [...state]..[ada] = baru;
    await _lay.simpan(baru);
  }

  Future<void> hapus(String produkId) async {
    state = state.where((b) => b.produkId != produkId).toList();
    await _lay.hapus(produkId);
  }

  Future<void> kosongkan() async {
    state = [];
    await _lay.kosongkan();
  }

  double get totalSemua => state.fold(0, (total, b) => total + b.totalHarga);
  int get totalItem => state.fold(0, (j, b) => j + b.jumlah);
}
