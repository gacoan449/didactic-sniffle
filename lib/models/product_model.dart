class Product {
  final String id;
  final String nama;
  final String kategori;
  final String deskripsi;
  final int harga;
  final int hargaDiskon;
  final int stok;
  final double rating;
  final int terjual;
  final List<String> gambar;
  final bool flashSale;
  final bool subsidi;

  Product({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.deskripsi,
    required this.harga,
    required this.hargaDiskon,
    required this.stok,
    required this.rating,
    required this.terjual,
    required this.gambar,
    required this.flashSale,
    required this.subsidi,
  });
}
