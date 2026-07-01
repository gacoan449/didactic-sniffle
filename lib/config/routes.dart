import 'package:go_router/go_router.dart';
import '../screens/splash.dart';
import '../screens/auth/masuk.dart';
import '../screens/auth/daftar.dart';
import '../screens/umum/pengendali_menu.dart';
import '../screens/umum/profil.dart';
import '../screens/umum/produk_daftar.dart';
import '../screens/customer/keranjang.dart';

final AppRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/masuk', builder: (c, s) => const HalamanMasuk()),
    GoRoute(path: '/daftar', builder: (c, s) => const HalamanDaftar()),
    GoRoute(path: '/beranda', builder: (c, s) => const PengendaliMenu()),
    GoRoute(path: '/profil', builder: (c, s) => const HalamanProfil()),
    GoRoute(path: '/produk', builder: (c, s) => const HalamanDaftarProduk()),
    GoRoute(path: '/keranjang', builder: (c, s) => const HalamanKeranjang()),
    GoRoute(path: '/checkout', builder: (c, s) => const Scaffold(body: Center(child: Text('Halaman Checkout - Segera Hadir!')))),
  ],
);
