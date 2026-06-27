import 'package:flutter/material.dart';

void main() {
  runApp(const PetaniDesaBerkah());
}

class PetaniDesaBerkah extends StatelessWidget {
  const PetaniDesaBerkah({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petani Desa Berkah',
      theme: ThemeData(
        primaryColor: const Color(0xff15803D),
        scaffoldBackgroundColor: Colors.grey.shade100,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff15803D),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "🌾",
              style: TextStyle(fontSize: 90),
            ),

            const SizedBox(height: 20),

            const Text(
              "PETANI DESA BERKAH",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Belanja Murah Untuk Semua",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.white,
            ),

          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xff15803D),
        foregroundColor: Colors.white,
        title: const Text("Masuk"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              decoration: InputDecoration(
                labelText: "Nomor HP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height:20),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              height:55,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff15803D),
                ),

                onPressed: (){

                },

                child: const Text(
                  "MASUK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:18,
                  ),
                ),

              ),
            ),

            const SizedBox(height:15),

            TextButton(
              onPressed: (){

              },
              child: const Text(
                "Daftar Akun Baru",
              ),
            ),

          ],
        ),
      ),
    );
  }
}