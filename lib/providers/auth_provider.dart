import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  final _layanan = AuthService();
  StreamSubscription<User?>? _langganan;

  @override
  AsyncValue<User?> build() {
    _langganan = _layanan.aliranPengguna.listen((user) {
      state = AsyncValue.data(user);
    });
    ref.onDispose(() => _langganan?.cancel());
    return const AsyncValue.loading();
  }

  Future<void> daftar(String email, String sandi, String nama) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _layanan.daftar(email, sandi, nama));
  }

  Future<void> masuk(String email, String sandi) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _layanan.masuk(email, sandi));
  }

  Future<void> masukGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _layanan.masukGoogle());
  }

  Future<void> keluar() async {
    await _layanan.keluar();
    state = const AsyncValue.data(null);
  }
}
