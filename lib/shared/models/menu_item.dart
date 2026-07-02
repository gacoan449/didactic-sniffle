import 'package:flutter/material.dart';

class MenuItem {
  final String judul;
  final IconData ikon;
  final Widget halaman;
  final bool perluLogin;

  const MenuItem({
    required this.judul,
    required this.ikon,
    required this.halaman,
    this.perluLogin = false,
  });
}
