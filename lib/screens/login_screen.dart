import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [

                const Icon(
                  Icons.shopping_basket,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height:20),

                const Text(
                  "PETANI DESA BERKAH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height:40),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Nomor HP",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height:15),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height:25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: const Text("MASUK"),
                  ),
                ),

                const SizedBox(height:10),

                TextButton(
                  onPressed: (){},
                  child: const Text(
                    "Daftar Akun Baru",
                    style: TextStyle(color: Colors.white),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
