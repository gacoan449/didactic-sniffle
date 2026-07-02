import 'dart:developer' as dev;

class LayananLog {
  static const bool _modeRilis = bool.fromEnvironment('dart.vm.product');

  static info(String pesan) {
    if (!_modeRilis) dev.log("ℹ️ $pesan", name: "INFO");
  }

  static peringatan(String pesan) {
    if (!_modeRilis) dev.log("⚠️ $pesan", name: "PERINGATAN");
  }

  static error(String pesan, [dynamic error, StackTrace? trace]) {
    if (!_modeRilis)
      dev.log("❌ $pesan", error: error, stackTrace: trace, name: "ERROR");
  }
}
