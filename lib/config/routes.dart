import 'package:go_router/go_router.dart';
import '../screens/splash.dart';
import '../screens/umum/pengendali_menu.dart';

final AppRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/beranda', builder: (c, s) => const PengendaliMenu()),
  ],
);
