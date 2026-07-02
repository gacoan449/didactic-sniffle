import 'package:flutter/material.dart';

class AppTheme {
  static const Color warnaUtama = Colors.green;
  static const Color warnaAksen = Colors.orange;
  static const Color warnaSukses = Colors.green;
  static const Color warnaPeringatan = Colors.orange;
  static const Color warnaError = Colors.red;
  static const Color warnaLatar = Color(0xFFF5F5F5);
  static const Color warnaTeks = Colors.black87;

  static ThemeData terang = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: warnaUtama,
      primary: warnaUtama,
      secondary: warnaAksen,
      error: warnaError,
      background: warnaLatar,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: warnaTeks,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: warnaTeks,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: warnaTeks),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: warnaTeks),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: warnaUtama,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );

  static ThemeData gelap = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: warnaUtama,
      brightness: Brightness.dark,
      primary: warnaUtama,
      secondary: warnaAksen,
    ),
  );
}
