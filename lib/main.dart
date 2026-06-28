import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PetaniDesaBerkahApp());
}

class PetaniDesaBerkahApp extends StatelessWidget {
  const PetaniDesaBerkahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Petani Desa Berkah",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),

      initialRoute: "/",

      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }
}
