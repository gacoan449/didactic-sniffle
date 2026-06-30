import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun"),
      ),
      body: const Center(
        child: Text(
          "Profil Pengguna",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
