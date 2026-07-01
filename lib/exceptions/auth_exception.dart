class AuthException implements Exception {
  final String pesan;
  final String? kodeError;

  const AuthException(this.pesan, {this.kodeError});

  @override
  String toString() => 'AuthException: $pesan';
}
