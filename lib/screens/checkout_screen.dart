import 'package:flutter/material.dart';

class HalamanPembayaran extends StatelessWidget {
  const HalamanPembayaran({super.key});

  @override
  Widget build(BuildContext konteks) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Halaman Pembayaran Siap', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
