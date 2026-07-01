import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String namaAplikasi = 'Petani Desa Berkah';
  static const String namaPerusahaan = 'Petani Desa Berkah Nusantara';
  static const String versiAplikasi = '1.0.0';
  static const int kodeVersi = 1;
  static const int minimumVersi = 1;
  static const bool wajibUpdate = false;
  static final bool modeDebug = dotenv.env['APP_MODE'] == 'development';
  static const String website = 'https://petanidesaberkah.com';
  static const String kebijakanPrivasi = '$website/privacy';
  static const String syaratKetentuan = '$website/terms';
  static const String tautanPlayStore =
      'https://play.google.com/store/apps/details?id=com.petanidesaberkah.app';
  static const int minimumVersiAndroid = 21;
  static const int ukuranMaksimalUnggahGambar = 5 * 1024 * 1024;
  static const Duration masaCache = Duration(hours: 24);
  static final String apiUrl =
      dotenv.env['API_URL'] ?? 'https://api.petanidesaberkah.com';
  static const bool modePemeliharaan = false;
  static const String pesanPemeliharaan =
      'Sedang perbaikan sistem, silakan coba lagi nanti';
  static const String emailSupport = "support@petanidesaberkah.com";
  static const Duration timeoutServer = Duration(seconds: 20);
}
