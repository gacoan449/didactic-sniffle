import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/masuk_pembeli.dart';
import '../screens/auth/daftar_pembeli.dart';
import '../screens/kasir/login_kasir.dart';
import '../screens/kasir/dashboard_kasir.dart';
import '../screens/kasir/buat_transaksi.dart';
import '../screens/kasir/shift_kasir.dart';
import '../screens/kasir/scan_barcode.dart';
import '../screens/kasir/detail_transaksi.dart';

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
      path: '/shift-kasir',
      builder: (c, s) => const HalamanShiftKasir(kasirId: ''),
    ),
    GoRoute(
      path: '/scan-barcode',
      builder: (c, s) => const HalamanScanBarcode(),
    ),
    GoRoute(
      path: '/detail-transaksi/:id',
      builder: (c, s) =>
          HalamanDetailTransaksi(transaksiId: s.pathParameters['id']!),
    ),
  ],
);
