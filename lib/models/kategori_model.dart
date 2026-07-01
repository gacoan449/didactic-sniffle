import 'package:flutter/material.dart';

class KategoriModel {
  final String id;
  final String nama;
  final IconData ikon;
  final Color warna;

  const KategoriModel({
    required this.id,
    required this.nama,
    required this.ikon,
    required this.warna,
  });

  static List<KategoriModel> daftarDefault() => [
    KategoriModel(
      id: 'semua',
      nama: 'Semua',
      ikon: Icons.apps,
      warna: const Color(0xFF4CAF50),
    ),
    KategoriModel(
      id: 'sayuran',
      nama: 'Sayuran Segar',
      ikon: Icons.grass,
      warna: const Color(0xFF8BC34A),
    ),
    KategoriModel(
      id: 'buah',
      nama: 'Buah-buahan',
      ikon: Icons.apple,
      warna: const Color(0xFFFF9800),
    ),
    KategoriModel(
      id: 'beras',
      nama: 'Beras & Padi',
      ikon: Icons.grain,
      warna: const Color(0xFF795548),
    ),
    KategoriModel(
      id: 'umbi',
      nama: 'Umbi-umbian',
      ikon: Icons.yard,
      warna: const Color(0xFFFFB74D),
    ),
    KategoriModel(
      id: 'rempah',
      nama: 'Rempah & Bumbu',
      ikon: Icons.spa,
      warna: const Color(0xFF9C27B0),
    ),
    KategoriModel(
      id: 'ternak',
      nama: 'Hasil Ternak',
      ikon: Icons.pets,
      warna: const Color(0xFFFFC107),
    ),
    KategoriModel(
      id: 'lainnya',
      nama: 'Lainnya',
      ikon: Icons.category,
      warna: const Color(0xFF607D8B),
    ),
  ];
}
