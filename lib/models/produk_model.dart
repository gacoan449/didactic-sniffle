class ProdukModel {
  final String id;
  final String nama;
  final String kategori;
  final double harga;
  final int stok;
  final String satuan;
  final String deskripsi;
  final String gambarUrl;
  final String namaLower;

  const ProdukModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.stok,
    required this.satuan,
    required this.deskripsi,
    required this.gambarUrl,
    required this.namaLower,
  });

  Map<String, dynamic> keMap() => {
    'nama': nama,
    'namaLower': nama.toLowerCase(),
    'kategori': kategori,
    'harga': harga,
    'stok': stok,
    'satuan': satuan,
    'deskripsi': deskripsi,
    'gambarUrl': gambarUrl,
  };

  factory ProdukModel.dariMap(Map<String,dynamic> map, String docId) {
    return ProdukModel(
      id: docId,
      nama: map['nama']?.toString() ?? '',
      namaLower: map['namaLower']?.toString() ?? map['nama']?.toString().toLowerCase() ?? '',
      kategori: map['kategori']?.toString() ?? '',
      harga: double.tryParse(map['harga']?.toString() ?? '0') ?? 0,
      stok: int.tryParse(map['stok']?.toString() ?? '0') ?? 0,
      satuan: map['satuan']?.toString() ?? 'Kg',
      deskripsi: map['deskripsi']?.toString() ?? '',
      gambarUrl: map['gambarUrl']?.toString() ?? '',
    );
  }
}
