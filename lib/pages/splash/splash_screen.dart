import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: const Center(
        child: Text(
          'Petani Desa Berkah',
          style: TextStyle(
            fontSize: 28,
            color: Color(0xff15803D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
