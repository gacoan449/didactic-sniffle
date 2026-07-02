import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/laporan_service.dart';
import '../models/laporan_model.dart';

final layananLaporanProvider = Provider<LayananLaporan>(
  (ref) => LayananLaporan(),
);
final layananAuditProvider = Provider<LayananAudit>((ref) => LayananAudit());
final layananPengaturanProvider = Provider<LayananPengaturan>(
  (ref) => LayananPengaturan(),
);

final filterLaporanProvider = StateProvider<FilterLaporan>(
  (ref) => FilterLaporan(
    awal: DateTime.now().subtract(const Duration(days: 30)),
    akhir: DateTime.now(),
    status: ['selesai'],
  ),
);

final dokumenTerakhirProvider = StateProvider<DocumentSnapshot?>((ref) => null);
final daftarPesananProvider = StateProvider<List<PesananLaporan>>((ref) => []);
final sedangMemuatProvider = StateProvider<bool>((ref) => false);

final ringkasanLaporanProvider = Provider<RingkasanLaporan>((ref) {
  final daftar = ref.watch(daftarPesananProvider);
  return ref.watch(layananLaporanProvider).hitungRingkasan(daftar);
});

Future<void> muatLaporanLebih(WidgetRef ref) async {
  if (ref.read(sedangMemuatProvider)) return;
  ref.read(sedangMemuatProvider.notifier).state = true;

  final filter = ref.read(filterLaporanProvider);
  final terakhir = ref.read(dokumenTerakhirProvider);
  final layanan = ref.read(layananLaporanProvider);

  final dataBaru = await layanan.ambilPesananLaporan(
    filter,
    mulaiDari: terakhir,
  );

  if (dataBaru.isNotEmpty) {
    ref.read(daftarPesananProvider.notifier).state = [
      ...ref.read(daftarPesananProvider),
      ...dataBaru,
    ];
    ref.read(dokumenTerakhirProvider.notifier).state =
        dataBaru.last.docSnapshot;
  }

  ref.read(sedangMemuatProvider.notifier).state = false;
}
