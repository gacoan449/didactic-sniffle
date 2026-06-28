import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {

  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => ProductDetailScreen(
          product: product,
        ),

      ),

    );

  },

  child: Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(

        padding: const EdgeInsets.all(10),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Expanded(

              child: Container(

                width: double.infinity,

                decoration: BoxDecoration(

                  color: Colors.green.shade100,

                  borderRadius: BorderRadius.circular(10),

                ),

                child: const Icon(
                  Icons.shopping_basket,
                  size: 60,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height:8),

            Text(
              product.nama,
              maxLines:2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:5),

            Text(
              "Rp ${product.harga}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("Stok : ${product.stok}");

            Text("⭐ ${product.rating}");

          ],
        ),
    ),
    );
  }
}
