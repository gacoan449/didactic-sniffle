import 'package:flutter/material.dart';

class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key});

  @override
  Widget build(BuildContext konteks) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Keranjang Kosong', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
