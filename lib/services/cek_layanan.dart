import 'package:connectivity_plus/connectivity_plus.dart';
import 'firebase_service.dart';
import '../config/app_config.dart';

class CekLayanan {
  static Future<bool> adaInternet() async {
    final hasil = await Connectivity().checkConnectivity();
    return hasil != ConnectivityResult.none;
  }

  static Future<bool> cekPemeliharaan() async {
    return AppConfig.modePemeliharaan;
  }

  static Future<bool> cekLogin() async {
    final user = LayananFirebase.auth.currentUser;
    return user != null;
  }
}
