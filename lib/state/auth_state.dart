import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthStateNotifier() : super(const AsyncValue.data(null));

  void setUser(UserModel? user) {
    state = AsyncValue.data(user);
  }

  void setLoading() {
    state = const AsyncValue.loading();
  }

  void setError(Object e, StackTrace s) {
    state = AsyncValue.error(e, s);
  }
}
