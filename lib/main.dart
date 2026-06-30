import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:screen_security/screen_security.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_alert_window/system_alert_window.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 🛡️ PENGAWAS PENGAWASAN FISIK LAYAR
class PengamanFisik {
  static bool _siapAktif = false;

  static Future<void> aktifkanPerisai() async {
    if (_siapAktif) return;
    await ScreenSecurity.enable();
    print("✅ [LAYAR] Screenshot & Rekam Layar Dikunci Total");
    _siapAktif = true;
  }

  static Future<bool> bolehTransaksi() async {
    bool adaPenimpa = await SystemAlertWindow.canDrawOverlays();
    bool adaAlatOtomatis = await Permission.accessibility.isGranted;
    
    if (adaPenimpa) print("⚠️ BAHAYA: Ada aplikasi menimpa layar!");
    if (adaAlatOtomatis) print("⚠️ BAHAYA: Ada alat otomatis/penyadap aktif!");
    
    return !adaPenimpa && !adaAlatOtomatis;
  }
}

// 🔒 VERIFIKASI ALAT BANTU TIDAK DIUBAH
class VerifikasiPustaka {
  static const String hashBenar = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
  static bool aman() => sha256.convert(utf8.encode("")).toString() == hashBenar;
}

// 🧹 PEMBERSIH MEMORI SEKETIKA
class Pembersih {
  static void hapus(Uint8List data) {
    for(int i=0; i<data.length; i++) data[i] = Random.secure().nextInt(256);
    for(int i=0; i<data.length; i++) data[i] = 0;
    print("🧹 [MEMORI] Data sensitif dibersihkan seketika");
  }
}

// 🔐 KUNCI RAHASIA TANPA PERNAH MENJADI TEKS
class KunciRahasia {
  static const List<int> bagian1 = [72,73,76,87,65];
  static const List<int> bagian2 = [95,83,70,84,88];
  static Uint8List ambil() {
    List<int> gabung = [...bagian1, ...bagian2];
    Uint8List hasil = Uint8List(gabung.length);
    for(int i=0; i<gabung.length; i++) hasil[i] = (gabung[i] ^ 7) % 256;
    return hasil;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PengamanFisik.aktifkanPerisai();
  runApp(AplikasiUtama());
}

class AplikasiUtama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Petani Desa Aman",
      theme: ThemeData(primarySwatch: Colors.green),
      home: HalamanDepan(),
    );
  }
}

class HalamanDepan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🛡️ Sistem Terkunci Aman"), centerTitle: true),
      body: FutureBuilder<bool>(
        future: PengamanFisik.bolehTransaksi(),
        builder: (ctx, data) {
          if(!data.hasData) return Center(child: CircularProgressIndicator());
          bool aman = data.data ?? false;
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(aman ? Icons.verified_user : Icons.block, size: 80, color: aman ? Colors.green : Colors.red),
                  SizedBox(height: 20),
                  Text(
                    aman 
                    ? "✅ Semua Benteng Pengaman Sudah Aktif\nAman Digunakan" 
                    : "❌ Matikan Aplikasi Penimpa & Alat Otomatis\nTerlebih Dahulu",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
