import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pengguna_model.dart';
import '../services/auth_service.dart';

final layananAuthProvider = Provider<LayananAuth>((ref) => LayananAuth());

// ✅ SUDAH DIDEKLARASIKAN DENGAN JELAS
final penggunaSaatIniProvider = StateProvider<PenggunaModel?>((ref) => null);

final daftarProvider =
    FutureProvider.family<PenggunaModel, Map<String, String>>((
      ref,
      data,
    ) async {
      return ref
          .read(layananAuthProvider)
          .daftarDenganEmail(
            nama: data['nama']!,
            email: data['email']!,
            password: data['sandi']!,
            nomorHP: data['hp']!,
          );
    });

final masukEmailProvider =
    FutureProvider.family<PenggunaModel, Map<String, String>>((
      ref,
      data,
    ) async {
      return ref
          .read(layananAuthProvider)
          .masukDenganEmail(data['email']!, data['sandi']!);
    });

final masukGoogleProvider = FutureProvider<PenggunaModel>((ref) async {
  return ref.read(layananAuthProvider).masukDenganGoogle();
});
