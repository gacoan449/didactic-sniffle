import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
      ),
      body: const Center(
        child: Text(
          "Keranjang Belanja",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
