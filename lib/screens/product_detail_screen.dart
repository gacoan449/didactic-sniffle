import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.nama), backgroundColor: Colors.green),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.green.shade100,
              child: const Icon(
                Icons.shopping_basket,
                size: 120,
                color: Colors.green,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Rp ${product.harga}",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("Stok : ${product.stok}"),

                  Text("Rating : ⭐ ${product.rating}"),

                  Text("Diskon : ${product.diskon}%"),

                  const SizedBox(height: 20),

                  const Text(
                    "Deskripsi Produk",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Produk segar langsung dari Petani Desa Berkah. "
                    "Dipanen setiap hari sehingga kualitas tetap terjaga.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  CartService.add(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Produk masuk ke keranjang")),
                  );
                },

                child: const Text("Tambah Keranjang"),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),

                onPressed: () {},

                child: const Text("Beli Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
