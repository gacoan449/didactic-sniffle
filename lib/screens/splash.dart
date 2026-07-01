import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import '../services/cek_layanan.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String pesan = 'Memuat konfigurasi...';
  int langkah = 0;

  @override
  void initState() {
    super.initState();
    jalankanAlurPengecekan();
  }

  Future<void> jalankanAlurPengecekan() async {
    try {
      setState(() {
        langkah = 1;
        pesan = 'Memeriksa koneksi...';
      });
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        langkah = 2;
        pesan = 'Memeriksa status sistem...';
      });
      if (await CekLayanan.cekPemeliharaan()) {
        tampilkanPesan(AppConfig.pesanPemeliharaan);
        return;
      }

      setState(() {
        langkah = 3;
        pesan = 'Menyiapkan aplikasi...';
      });
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        langkah = 4;
        pesan = 'Selesai!';
      });
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        if (await CekLayanan.cekLogin()) {
          context.go('/beranda');
        } else {
          context.go('/masuk');
        }
      }
    } catch (e) {
      tampilkanPesan('Terjadi kesalahan: $e');
    }
  }

  void tampilkanPesan(String isi) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Pemberitahuan'),
        content: Text(isi),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Tutup Aplikasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grass, color: Colors.white, size: 80),
            const SizedBox(height: 16),
            Text(
              AppConfig.namaAplikasi,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versi ${AppConfig.versiAplikasi}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: langkah / 4,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pesan,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
