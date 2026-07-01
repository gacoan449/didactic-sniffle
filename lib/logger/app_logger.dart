import 'package:logger/logger.dart';
import '../config/app_config.dart';

class AppLogger {
  static final Logger _log = Logger(
    printer: PrettyPrinter(methodCount: 2),
    level: AppConfig.modeDebug ? Level.all : Level.off,
  );

  static void info(dynamic pesan) => _log.i(pesan);
  static void warning(dynamic pesan) => _log.w(pesan);
  static void error(dynamic pesan, [StackTrace? tumpukan]) => _log.e(pesan, stackTrace: tumpukan);
}
