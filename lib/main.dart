import "package:timeago/timeago.dart" as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'config/app_config.dart';
import 'core/di/injection.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: AppConfig.modeDebug ? '.env.development' : '.env.production');

  await LayananFirebase.inisialisasi();

  await setupDependencyInjection();

  FlutterError.onError = (d) => FlutterError.presentError(d);
  PlatformDispatcher.instance.onError = (e,s) { debugPrint('ERROR GLOBAL: $e'); debugPrint('JEJAK: $s'); return true; };

  runApp(const ProviderScope(child: AplikasiUtama()));
}

class AplikasiUtama extends StatelessWidget {
  const AplikasiUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.namaAplikasi,
      debugShowCheckedModeBanner: AppConfig.modeDebug,
      routerConfig: AppRoutes,
      theme: AppTheme.terang,
      darkTheme: AppTheme.gelap,
      themeMode: ThemeMode.system,
    );
  }
}
