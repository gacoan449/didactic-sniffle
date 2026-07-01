import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<User?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  StreamSubscription<User?>? _langgananAuth;

  @override
  AsyncValue<User?> build() {
    state = const AsyncValue.loading();
    _langgananAuth = AuthService().aliranPengguna.listen(
      (user) {
        state = AsyncValue.data(user);
      },
      onError: (e, s) {
        state = AsyncValue.error(e, s);
      },
    );

    // Batalkan langganan otomatis saat provider dibuang
    ref.onDispose(() {
      _langgananAuth?.cancel();
    });

    return const AsyncValue.data(null);
  }
}
