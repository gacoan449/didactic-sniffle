class DatabaseException implements Exception {
  final String pesan;
  final dynamic errorAsli;

  const DatabaseException(this.pesan, {this.errorAsli});

  @override
  String toString() => 'DatabaseException: $pesan';
}
