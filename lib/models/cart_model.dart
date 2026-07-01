class CartModel {
  final String id;
  final String namaProduk;
  final String gambar;
  final double harga;
  int jumlah;

  CartModel({
    required this.id,
    required this.namaProduk,
    required this.gambar,
    required this.harga,
    required this.jumlah,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      namaProduk: map['namaProduk'] as String,
      gambar: map['gambar'] as String,
      harga: (map['harga'] as num).toDouble(),
      jumlah: map['jumlah'] as int,
    );
  }

  Map<String, dynamic> keMap() => {
    'id': id,
    'namaProduk': namaProduk,
    'gambar': gambar,
    'harga': harga,
    'jumlah': jumlah,
  };

  static void tambahAtauUpdate(List<CartModel> daftar, CartModel barangBaru) {
    final indeks = daftar.indexWhere((b) => b.id == barangBaru.id);
    if (indeks >= 0) {
      daftar[indeks].jumlah += barangBaru.jumlah;
    } else {
      daftar.add(barangBaru);
    }
  }
