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
  ],
);
