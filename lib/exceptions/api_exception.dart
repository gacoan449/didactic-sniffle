class ApiException implements Exception {
  final String pesan;
  final int? kode;
  final dynamic data;

  const ApiException(this.pesan, {this.kode, this.data});

  @override
  String toString() => 'ApiException ($kode): $pesan';
}
