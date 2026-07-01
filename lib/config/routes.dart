import 'package:go_router/go_router.dart';
import '../screens/splash.dart';
import '../screens/auth/masuk.dart';
import '../screens/auth/daftar.dart';
import '../screens/auth/lupa_sandi.dart';
import '../screens/umum/pengendali_menu.dart';
import '../screens/umum/profil.dart';
import '../screens/umum/produk_daftar.dart';
import '../screens/umum/pencarian.dart';
import '../screens/customer/wishlist.dart';
import '../screens/customer/keranjang.dart';
import '../screens/customer/checkout.dart';
import '../screens/customer/riwayat_pesanan.dart';
import '../screens/customer/detail_pesanan.dart';
import '../screens/pengguna/daftar_alamat.dart';
import '../screens/pengguna/tambah_alamat.dart';
import '../screens/pengguna/ubah_profil.dart';
import '../models/pesanan_model.dart';
import '../models/alamat_model.dart';
import '../models/pengguna_model.dart';

final AppRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/masuk', builder: (c, s) => const HalamanMasuk()),
    GoRoute(path: '/daftar', builder: (c, s) => const HalamanDaftar()),
    GoRoute(path: '/lupa-sandi', builder: (c, s) => const HalamanLupaSandi()),
    GoRoute(path: '/beranda', builder: (c, s) => const PengendaliMenu()),
    GoRoute(path: '/profil', builder: (c, s) => const HalamanProfil()),
    GoRoute(path: '/ubah-profil', builder: (c, s) => HalamanUbahProfil(pengguna: s.extra as PenggunaModel?)),
    GoRoute(path: '/produk', builder: (c, s) => const HalamanDaftarProduk()),
    GoRoute(path: '/favorit', builder: (c, s) => const HalamanWishlist()),
    GoRoute(path: '/cari', builder: (c, s) => const HalamanPencarian()),
    GoRoute(path: '/keranjang', builder: (c, s) => const HalamanKeranjang()),
    GoRoute(path: '/checkout', builder: (c, s) => const HalamanCheckout()),
    GoRoute(path: '/riwayat', builder: (c, s) => const HalamanRiwayatPesanan()),
    GoRoute(path: '/daftar-alamat', builder: (c, s) => HalamanDaftarAlamat(pilihUntukCheckout: s.extra as bool? ?? false)),
    GoRoute(path: '/tambah-alamat', builder: (c, s) => HalamanTambahAlamat(alamat: s.extra as AlamatModel?)),
    GoRoute(
      path: '/detail-pesanan',
      builder: (c, s) => HalamanDetailPesanan(pesanan: s.extra as PesananModel),
    ),
  ],
);
