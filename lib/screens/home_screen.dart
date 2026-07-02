import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext konteks) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Petani Desa Berkah',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Sistem Siap Terhubung Firebase ✅',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
