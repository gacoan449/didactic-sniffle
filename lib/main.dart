import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const PetaniDesaApp());
}

class PetaniDesaApp extends StatelessWidget {
  const PetaniDesaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Petani Desa Berkah",
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
