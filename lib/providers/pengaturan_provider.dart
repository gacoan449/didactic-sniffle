import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/pengaturan_model.dart';
import '../services/enkripsi_service.dart';

final kotakPengaturanProvider = FutureProvider<Box<PengaturanModel>>((
  ref,
) async {
  if (!Hive.isBoxOpen('pengaturan')) {
    await Hive.openBox<PengaturanModel>('pengaturan');
  }
  return Hive.box<PengaturanModel>('pengaturan');
});

final pengaturanProvider =
    AsyncNotifierProvider<PengaturanNotifier, PengaturanModel>(
      PengaturanNotifier.new,
    );

class PengaturanNotifier extends AsyncNotifier<PengaturanModel> {
  late Box<PengaturanModel> _kotak;

  @override
  Future<PengaturanModel> build() async {
    _kotak = await ref.watch(kotakPengaturanProvider.future);
    if (_kotak.isEmpty) {
      final awal = PengaturanModel.awal();
      await _kotak.put(0, awal);
      return awal;
    }
    return _kotak.getAt(0)!;
  }

  Future<void> simpan(PengaturanModel data) async {
    state = AsyncData(data);
    await _kotak.putAt(0, data);
  }

  Future<bool> aturPIN(String pinLama, String pinBaru) async {
    final sekarang = state.value;
    if (sekarang == null) return false;

    if (sekarang.pinEnkripsi != null) {
      if (!LayananEnkripsi.cekPIN(pinLama, sekarang.pinEnkripsi!)) {
        return false;
      }
    }

    final baru = PengaturanModel(
      izinNotifikasi: sekarang.izinNotifikasi,
      izinLokasi: sekarang.izinLokasi,
      kunciAplikasi: true,
      pakaiSidikJari: sekarang.pakaiSidikJari,
      pinEnkripsi: LayananEnkripsi.hashPIN(pinBaru),
      versiAplikasi: sekarang.versiAplikasi,
      terakhirSinkronisasi: DateTime.now(),
    );
    await simpan(baru);
    return true;
  }

  Future<void> ubahPengaturan({
    bool? izinNotifikasi,
    bool? izinLokasi,
    bool? kunciAplikasi,
    bool? pakaiSidikJari,
  }) async {
    final sekarang = state.value;
    if (sekarang == null) return;

    final baru = PengaturanModel(
      izinNotifikasi: izinNotifikasi ?? sekarang.izinNotifikasi,
      izinLokasi: izinLokasi ?? sekarang.izinLokasi,
      kunciAplikasi: kunciAplikasi ?? sekarang.kunciAplikasi,
      pakaiSidikJari: pakaiSidikJari ?? sekarang.pakaiSidikJari,
      pinEnkripsi: sekarang.pinEnkripsi,
      versiAplikasi: sekarang.versiAplikasi,
      terakhirSinkronisasi: DateTime.now(),
    );
    await simpan(baru);
  }
}
