import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengguna_model.dart';
import '../models/shift_kasir_model.dart';

final kasirAktifProvider = StateProvider<PenggunaModel?>((ref) => null);
final shiftAktifProvider = StateProvider<ShiftKasirModel?>((ref) => null);

final loginKasirProvider =
    FutureProvider.family<PenggunaModel, Map<String, String>>((
      ref,
      data,
    ) async {
      final db = FirebaseFirestore.instance;
      final snap = await db
          .collection('pengguna')
          .where('jenis', whereIn: ['kasir', 'admin', 'pemilik'])
          .where('uidAuth', isEqualTo: data['idKasir'])
          .where('pinAkun', isEqualTo: data['pin'])
          .get();

      if (snap.docs.isEmpty) throw 'ID Kasir atau PIN salah';
      final pengguna = PenggunaModel.dariMap(
        snap.docs.first.data(),
        snap.docs.first.id,
      );
      if (pengguna.akunDiblokir) throw 'Akun ini telah diblokir';

      ref.read(kasirAktifProvider.notifier).state = pengguna;
      return pengguna;
    });

final cekShiftAktifProvider = FutureProvider<String?>((ref) async {
  final kasir = ref.watch(kasirAktifProvider);
  if (kasir == null) return null;
  final db = FirebaseFirestore.instance;
  final snap = await db
      .collection('shift_kasir')
      .where('kasirId', isEqualTo: kasir.id)
      .where('status', isEqualTo: 'aktif')
      .limit(1)
      .get();
  return snap.docs.isNotEmpty ? snap.docs.first.id : null;
});
