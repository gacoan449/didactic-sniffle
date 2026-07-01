class KeranjangItem {
  final String produkId;
  final String nama;
  final double harga;
  final int jumlah;
  final String satuan;
  final String gambarUrl;
  final int stokTersedia;

  const KeranjangItem({
    required this.produkId,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.satuan,
    required this.gambarUrl,
    required this.stokTersedia,
  });

  KeranjangItem ubahJumlah(int baru) {
    return KeranjangItem(
      produkId: produkId, nama: nama, harga: harga,
      jumlah: baru, satuan: satuan, gambarUrl: gambarUrl, stokTersedia: stokTersedia
    );
  }

  Map<String, dynamic> keMap() => {
    'produkId': produkId,
    'nama': nama,
    'harga': harga,
    'jumlah': jumlah,
    'satuan': satuan,
    'gambarUrl': gambarUrl,
    'stokTersedia': stokTersedia,
  };

  factory KeranjangItem.dariMap(Map<String,dynamic> map) {
    return KeranjangItem(
      produkId: map['produkId']?.toString() ?? '',
      nama: map['nama']?.toString() ?? '',
      harga: double.tryParse(map['harga']?.toString() ?? '0') ?? 0,
      jumlah: int.tryParse(map['jumlah']?.toString() ?? '0') ?? 0,
      satuan: map['satuan']?.toString() ?? 'Buah',
      gambarUrl: map['gambarUrl']?.toString() ?? '',
      stokTersedia: int.tryParse(map['stokTersedia']?.toString() ?? '0') ?? 0,
    );
  }

  double get totalHarga => harga * jumlah;
}
