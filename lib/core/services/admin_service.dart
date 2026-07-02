import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/peran_model.dart';
import '../models/pengguna_model.dart';

class LayananAdmin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> ubahPeranPengguna({
    required String adminId,
    required PeranPengguna peranAdmin,
    required String targetPenggunaId,
    required PeranPengguna peranBaru,
  }) async {
    try {
      final snapTarget = await _db
          .collection('pengguna')
          .doc(targetPenggunaId)
          .get();
      if (!snapTarget.exists) return false;
      final dataTarget = PenggunaModel.dariMap(
        snapTarget.data() ?? {},
        snapTarget.id,
      );

      final snapAdmin = await _db.collection('pengguna').doc(adminId).get();
      final namaAdmin = snapAdmin.data()?['nama'] ?? 'Tidak Diketahui';

      await _db.collection('pengguna').doc(targetPenggunaId).update({
        'peran': peranBaru.name,
      });

      await catatAksi(
        AuditLogModel(
          id: '',
          adminId: adminId,
          namaAdmin: namaAdmin,
          peranAdmin: peranAdmin,
          targetPenggunaId: targetPenggunaId,
          namaTarget: dataTarget.nama,
          emailTarget: dataTarget.email,
          aksi: 'Ubah Peran Pengguna',
          modul: 'Manajemen Pengguna',
          detail: 'Dari ${dataTarget.peran.name} menjadi ${peranBaru.name}',
          waktu: DateTime.now(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> catatAksi(AuditLogModel log) async {
    final infoPerangkat = DeviceInfoPlugin();
    String platform = 'Lainnya', perangkat = 'Tidak Diketahui';

    try {
      if (kIsWeb) {
        platform = 'Web';
        perangkat = 'Peramban Web';
      } else if (Platform.isAndroid) {
        final android = await infoPerangkat.androidInfo;
        platform = 'Android';
        perangkat = '${android.brand} ${android.model}';
      } else if (Platform.isIOS) {
        final ios = await infoPerangkat.iosInfo;
        platform = 'iOS';
        perangkat = ios.utsname.machine;
      }
    } catch (_) {}

    await _db
        .collection('audit_log')
        .add(
          log.keMap()..addAll({
            'perangkat': perangkat,
            'platform': platform,
            'waktu': FieldValue.serverTimestamp(),
          }),
        );
  }

  Future<Map<String, dynamic>> ambilRingkasanDashboard() async {
    try {
      final now = DateTime.now();
      final awalHari = DateTime(now.year, now.month, now.day);

      int totalPesanan = 0, totalPengguna = 0, totalProduk = 0;

      try {
        totalPesanan =
            (await _db
                    .collection('pesanan')
                    .where('tanggal', isGreaterThanOrEqualTo: awalHari)
                    .count()
                    .get())
                .count;
      } catch (_) {}

      try {
        totalPengguna = (await _db.collection('pengguna').count().get()).count;
      } catch (_) {}

      try {
        totalProduk = (await _db.collection('produk').count().get()).count;
      } catch (_) {}

      return {
        'totalPesananHariIni': totalPesanan,
        'totalPengguna': totalPengguna,
        'totalProduk': totalProduk,
      };
    } catch (e) {
      return {'totalPesananHariIni': 0, 'totalPengguna': 0, 'totalProduk': 0};
    }
  }
}
