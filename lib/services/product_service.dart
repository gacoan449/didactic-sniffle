import '../models/product_model.dart';

class ProductService {
  static List<ProductModel> products = [

    ProductModel(
      id: "1",
      nama: "Bayam Segar",
      gambar: "",
      harga: 4000,
      stok: 120,
      rating: 4.9,
      diskon: 10,
    ),

    ProductModel(
      id: "2",
      nama: "Wortel",
      gambar: "",
      harga: 7000,
      stok: 60,
      rating: 4.8,
      diskon: 5,
    ),

    ProductModel(
      id: "3",
      nama: "Tomat",
      gambar: "",
      harga: 8000,
      stok: 80,
      rating: 4.7,
      diskon: 15,
    ),

    ProductModel(
      id: "4",
      nama: "Kentang",
      gambar: "",
      harga: 12000,
      stok: 50,
      rating: 4.8,
      diskon: 20,
    ),

  ];
}
