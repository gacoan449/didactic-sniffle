import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'config/theme.dart';
import 'config/routes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CicilanModelAdapter());
  Hive.registerAdapter(GudangModelAdapter());
  Hive.registerAdapter(PeranPenggunaAdapter());
  Hive.registerAdapter(PengaturanModelAdapter());
import "services/hive_service.dart";
  WidgetsFlutterBinding.ensureInitialized();
await LayananHive.inisialisasi();

  // Daftarkan Bahasa Indonesia untuk Timeago
  timeago.setLocaleMessages('id', timeago.IdMessages());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Petani Desa Berkah',
      theme: AppTheme.temaUtama,
      routerConfig: AppRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
