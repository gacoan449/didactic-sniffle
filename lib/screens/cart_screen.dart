import 'checkout_screen.dart';

import 'package:flutter/material.dart';
import '../models/cart_model.dart';

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

            trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      onPressed: () {
        setState(() {
          CartService.minus(item);
        });
      },
    ),

    Text(
      "${item.qty}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () {
        setState(() {
          CartService.plus(item);
        });
      },
    ),

    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          CartService.remove(item.product);
        });
      },
    ),

  ],
),
            ),

          );

        },

      ),

      bottomNavigationBar: Container(

  padding: const EdgeInsets.all(15),

  decoration: const BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        blurRadius: 6,
        color: Colors.black12,
      )
    ],
  ),

  child: Column(

    mainAxisSize: MainAxisSize.min,

    children: [

      Row(

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          const Text(
            "Total Belanja",
            style: TextStyle(fontSize: 18),
          ),

          Text(
            "Rp ${CartService.total}",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],

      ),

      const SizedBox(height:15),

      SizedBox(

        width: double.infinity,

        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(0, 50),
          ),

          onPressed: (){

Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>const CheckoutScreen(),

),

);

},

          child: const Text(
            "Checkout",
            style: TextStyle(fontSize: 18),
          ),

        ),

      ),

    ],

  ),

),
