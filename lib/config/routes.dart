import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/masuk_pembeli.dart';
import '../screens/auth/daftar_pembeli.dart';
import '../screens/auth/masuk_hp.dart';
import '../screens/kasir/login_kasir.dart';
import '../screens/kasir/dashboard_kasir.dart';
import '../screens/kasir/buat_transaksi.dart';
import '../screens/umum/riwayat_aktivitas.dart';
import '../screens/supplier/beranda_supplier.dart';
import '../screens/customer/pilih_kurir.dart';
import '../screens/dompet/beranda_dompet.dart';
import '../screens/dompet/isi_saldo.dart';
import '../screens/dompet/riwayat_dompet.dart';
import '../screens/customer/pilih_pembayaran.dart';
import '../screens/cicilan/ajukan_cicilan.dart';
import '../screens/gudang/beranda_gudang.dart';
import '../screens/admin/dashboard_admin.dart';
import "../screens/pengaturan/keamanan.dart";

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(
      path: '/masuk-pembeli',
      builder: (c, s) => const HalamanMasukPembeli(),
    ),
    GoRoute(
      path: '/daftar-pembeli',
      builder: (c, s) => const HalamanDaftarPembeli(),
    ),
    GoRoute(path: '/masuk-hp', builder: (c, s) => const HalamanMasukHP()),
    GoRoute(path: '/masuk-kasir', builder: (c, s) => const HalamanLoginKasir()),
    GoRoute(
      path: '/kasir-dashboard',
      builder: (c, s) => const HalamanDashboardKasir(),
    ),
    GoRoute(
      path: '/kasir-transaksi',
      builder: (c, s) => const HalamanBuatTransaksi(),
    ),
    GoRoute(
      path: '/riwayat-aktivitas',
      builder: (c, s) => const HalamanRiwayatAktivitas(),
    ),
    GoRoute(
      path: '/supplier',
      builder: (c, s) => const HalamanBerandaSupplier(),
    ),
    GoRoute(path: '/pilih-kurir', builder: (c, s) => const HalamanPilihKurir()),
    GoRoute(path: '/dompet', builder: (c, s) => const HalamanDompet()),
    GoRoute(path: '/isi-saldo', builder: (c, s) => const HalamanIsiSaldo()),
    GoRoute(
      path: '/riwayat-dompet',
      builder: (c, s) => const HalamanRiwayatDompet(),
    ),
    GoRoute(
      path: '/pilih-pembayaran',
      builder: (c, s) {
        final total = (s.extra as double?) ?? 0;
        return HalamanPilihPembayaran(totalBayar: total);
      },
    ),
    GoRoute(
      path: '/ajukan-cicilan',
      builder: (c, s) {
        final data = (s.extra as Map<String, dynamic>?) ?? {};
        return HalamanAjukanCicilan(
          totalBelanja: (data['total'] as double?) ?? 0,
          pesananId: (data['pesananId'] as String?) ?? '',
        );
      },
    ),
    GoRoute(path: '/gudang', builder: (c, s) => const HalamanGudang()),
    GoRoute(
      path: '/stok',
      builder: (c, s) =>
          const Scaffold(body: Center(child: Text('Daftar Stok Produk'))),
    ),
    GoRoute(
      path: '/stok-menipis',
      builder: (c, s) =>
          const Scaffold(body: Center(child: Text('Daftar Stok Menipis'))),
    ),
    GoRoute(
      path: '/pindah-stok',
      builder: (c, s) =>
          const Scaffold(body: Center(child: Text('Pindah Stok Antar Gudang'))),
    ),
    GoRoute(
      path: '/laporan-stok',
      builder: (c, s) =>
          const Scaffold(body: Center(child: Text('Laporan Stok Gudang'))),
    ),
    GoRoute(
      path: '/pengaturan-keamanan',
      builder: (c, s) => const HalamanKeamanan(),
    ),
    GoRoute(path: '/admin', builder: (c, s) => const HalamanDashboardAdmin()),
  ],
);
