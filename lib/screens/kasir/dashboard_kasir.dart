import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/kasir_provider.dart';
import '../../services/auth_service.dart';

class HalamanDashboardKasir extends ConsumerWidget {
  const HalamanDashboardKasir({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kasir = ref.watch(kasirAktifProvider);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kasir Toko'),
            Text(
              'Selamat Datang, ${kasir?.namaLengkap ?? "Pengguna"}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Keluar',
            onPressed: () async {
              await LayananAuth().keluar();
              ref.read(kasirAktifProvider.notifier).state = null;
              if (context.mounted) context.go('/masuk-kasir');
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _menuItem(
            context,
            Icons.add_shopping_cart,
            'Transaksi Baru',
            Colors.green,
            '/kasir-transaksi',
          ),
          _menuItem(
            context,
            Icons.history,
            'Riwayat Transaksi',
            Colors.blue,
            '/riwayat-transaksi',
          ),
          _menuItem(
            context,
            Icons.shift,
            'Buka / Tutup Shift',
            Colors.orange,
            '/shift-kasir',
          ),
          _menuItem(
            context,
            Icons.qr_code_scanner,
            'Scan Barcode',
            Colors.purple,
            '/scan-barcode',
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext c,
    IconData ikon,
    String label,
    Color warna,
    String rute,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => c.go(rute),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 48, color: warna),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
