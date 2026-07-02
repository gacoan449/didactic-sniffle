import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class KonfigurasiAppCheck {
  static Future<void> aktifkan() async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: kReleaseMode
          ? AndroidProvider.playIntegrity
          : AndroidProvider.debug,
      appleProvider: kReleaseMode
          ? AppleProvider.appAttest
          : AppleProvider.debug,
    );
  }
}
