import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';

final layananDashboardProvider = Provider<LayananDashboard>(
  (ref) => LayananDashboard(),
);

final ringkasanDashboardProvider = FutureProvider<RingkasanDashboard>((
  ref,
) async {
  return ref.watch(layananDashboardProvider).ambilRingkasanUtama();
});

final grafikPenjualanProvider = FutureProvider<List<DataGrafikWaktu>>((
  ref,
) async {
  return ref.watch(layananDashboardProvider).ambilPenjualanHarian();
});

final produkTerlarisProvider = FutureProvider<List<ItemAnalisis>>((ref) async {
  return ref.watch(layananDashboardProvider).ambilProdukTerlaris();
});

final metodeBayarProvider = FutureProvider<List<ItemAnalisis>>((ref) async {
  return ref.watch(layananDashboardProvider).ambilRingkasanMetodeBayar();
});

// ✅ Stream trigger yang lebih stabil: urut terbaru dulu
final pembaruanPesananStream = StreamProvider.autoDispose((ref) {
  final sekarang = DateTime.now();
  return FirebaseFirestore.instance
      .collection('pesanan')
      .where(
        'tanggal',
        isGreaterThanOrEqualTo: Timestamp.fromDate(
          DateTime(sekarang.year, sekarang.month, 1),
        ),
      )
      .orderBy('tanggal', descending: true)
      .limit(1)
      .snapshots();
});
