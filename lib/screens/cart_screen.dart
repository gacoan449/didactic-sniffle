import 'package:flutter/material.dart';

import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Keranjang"),
      ),

      body: ListView.builder(

        itemCount: CartService.items.length,

        itemBuilder: (context,index){

          var item = CartService.items[index];

          return ListTile(

            leading: const Icon(Icons.shopping_basket),

            title: Text(item.product.nama),

            subtitle: Text(
              "Rp ${item.product.harga}"
            ),

            trailing: Text(
              "x${item.qty}"
            ),

          );

        },

      ),

      bottomNavigationBar: Container(

        padding: const EdgeInsets.all(15),

        child: Text(

          "Total : Rp ${CartService.total}",

          style: const TextStyle(

            fontSize:20,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

    );

  }

}
