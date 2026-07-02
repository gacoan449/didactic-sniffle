import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import 'logger_service.dart';

// ✅ Handler Latar Belakang: Pakai DefaultFirebaseOptions
@pragma('vm:entry-point')
Future<void> penanganPesanLatarBelakang(RemoteMessage pesan) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LayananLog.info(
    "Notifikasi diterima saat aplikasi tertutup: ${pesan.messageId}",
  );
}

class LayananNotifikasi {
  static final LayananNotifikasi _instance = LayananNotifikasi._internal();
  factory LayananNotifikasi() => _instance;
  LayananNotifikasi._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _lokal =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _tokenSaatIni;
  bool _sudahInisialisasi = false;
  static const String _kunciLangganan = 'langganan_notif';

  // ✅ Simpan referensi listener agar bisa dibatalkan
  StreamSubscription<RemoteMessage>? _subPesanMasuk;
  StreamSubscription<RemoteMessage>? _subDariLatar;
  StreamSubscription<String>? _subTokenBaru;

  Future<void> inisialisasi() async {
    if (_sudahInisialisasi) return;

    // 1. Minta izin notifikasi dasar
    final izin = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (izin.authorizationStatus != AuthorizationStatus.authorized) {
      LayananLog.peringatan("Izin notifikasi ditolak");
      return;
    }

    // ✅ Minta izin runtime khusus Android 13+
    await _lokal
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // ✅ Ambil token APNs lebih dulu agar iOS stabil
    await _fcm.getAPNSToken();

    // 2. Konfigurasi notifikasi lokal
    const pengaturanAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const pengaturanIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _lokal.initialize(
      const InitializationSettings(
        android: pengaturanAndroid,
        iOS: pengaturanIOS,
      ),
      onDidReceiveNotificationResponse: _saatNotifikasiDiklik,
    );

    // Tampilkan notifikasi saat aplikasi di depan (iOS)
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ Buat saluran HANYA JIKA BELUM PERNAH
    if (!_sudahInisialisasi) {
      await _lokal
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannels([
            const AndroidNotificationChannel(
              'pesanan_baru',
              'Pesanan Baru',
              description: 'Notifikasi saat ada pesanan masuk',
              importance: Importance.high,
            ),
            const AndroidNotificationChannel(
              'status_pesanan',
              'Perubahan Pesanan',
              description: 'Perubahan status pesanan',
              importance: Importance.defaultImportance,
            ),
            const AndroidNotificationChannel(
              'peringatan_stok',
              'Peringatan Stok',
              description: 'Stok hampir habis atau habis',
              importance: Importance.high,
            ),
            const AndroidNotificationChannel(
              'umum',
              'Informasi Umum',
              description: 'Pengumuman dan berita',
              importance: Importance.low,
            ),
          ]);
    }

    // 3. Daftar penangan pesan & ✅ simpan subscription
    FirebaseMessaging.onBackgroundMessage(penanganPesanLatarBelakang);
    _subPesanMasuk = FirebaseMessaging.onMessage.listen(_saatPesanMasuk);
    _subDariLatar = FirebaseMessaging.onMessageOpenedApp.listen(
      _saatDariLatarBelakang,
    );

    // 4. Ambil & simpan token perangkat
    await _kelolaTokenPerangkat();
    _subTokenBaru = _fcm.onTokenRefresh.listen(
      (token) => _simpanTokenKeAkun(token),
    );

    // 5. Pulihkan preferensi langganan
    await _pulihkanLangganan();

    _sudahInisialisasi = true;
    LayananLog.info("Layanan Notifikasi siap digunakan");
  }

  Future<void> _kelolaTokenPerangkat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenLokal = prefs.getString('fcm_token');
      final tokenBaru = await _fcm.getToken();

      if (tokenBaru == null) return;
      if (tokenLokal != tokenBaru) {
        await prefs.setString('fcm_token', tokenBaru);
        _tokenSaatIni = tokenBaru;
        await _simpanTokenKeAkun(tokenBaru);
      }
    } catch (e, t) {
      LayananLog.error("Kelola token gagal", e, t);
    }
  }

  Future<void> _simpanTokenKeAkun(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _db.collection('pengguna').doc(uid).set({
        'tokenFcm': token,
        'terakhirPerbarui': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, t) {
      LayananLog.error("Simpan token gagal", e, t);
    }
  }

  void _saatPesanMasuk(RemoteMessage pesan) {
    final data = pesan.data;
    final judul = pesan.notification?.title ?? data['judul'] ?? 'Pemberitahuan';
    final isi = pesan.notification?.body ?? data['isi'] ?? '';
    final jenis = data['jenis'] ?? 'umum';
    _tampilkanNotifikasiLokal(judul, isi, jenis, data);
  }

  void _saatDariLatarBelakang(RemoteMessage pesan) {
    LayananLog.info("Notifikasi dibuka dari latar belakang");
  }

  void _saatNotifikasiDiklik(NotificationResponse res) {
    if (res.payload == null) return;
    try {
      jsonDecode(res.payload!);
    } catch (_) {}
  }

  Future<void> _tampilkanNotifikasiLokal(
    String judul,
    String isi,
    String jenis,
    Map<String, dynamic> data,
  ) async {
    final saluran = switch (jenis) {
      'pesanan_baru' => 'pesanan_baru',
      'status_pesanan' => 'status_pesanan',
      'stok_rendah' || 'stok_habis' => 'peringatan_stok',
      _ => 'umum',
    };

    await _lokal.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      judul,
      isi,
      NotificationDetails(
        android: AndroidNotificationDetails(
          saluran,
          saluran,
          importance: saluran == 'pesanan_baru'
              ? Importance.high
              : Importance.defaultImportance,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(data),
    );
  }

  Future<void> aturLangganan(String topik, bool aktif) async {
    final prefs = await SharedPreferences.getInstance();
    final daftar = Map<String, bool>.from(
      jsonDecode(prefs.getString(_kunciLangganan) ?? '{}'),
    );
    if (aktif) {
      await _fcm.subscribeToTopic(topik);
      daftar[topik] = true;
    } else {
      await _fcm.unsubscribeFromTopic(topik);
      daftar[topik] = false;
    }
    await prefs.setString(_kunciLangganan, jsonEncode(daftar));
  }

  Future<void> _pulihkanLangganan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_kunciLangganan);
      if (data == null) return;
      final daftar = Map<String, bool>.from(jsonDecode(data));
      for (final e in daftar.entries) {
        if (e.value) await _fcm.subscribeToTopic(e.key);
      }
    } catch (e, t) {
      LayananLog.error("Pulihkan langganan gagal", e, t);
    }
  }

  Future<void> kirimNotifikasiLangsung(
    String judul,
    String isi, {
    String jenis = 'umum',
  }) async {
    await _tampilkanNotifikasiLokal(judul, isi, jenis, {'jenis': jenis});
  }

  /// ✅ Bersihkan semua sumber daya saat keluar
  Future<void> hapusTokenSaatKeluar() async {
    try {
      // Batalkan semua listener
      await _subPesanMasuk?.cancel();
      await _subDariLatar?.cancel();
      await _subTokenBaru?.cancel();

      // ✅ Berhenti dari SEMUA topik langganan
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_kunciLangganan);
      if (data != null) {
        final daftar = Map<String, bool>.from(jsonDecode(data));
        for (final topik in daftar.keys) {
          await _fcm.unsubscribeFromTopic(topik);
        }
      }

      // Hapus token & data
      final uid = _auth.currentUser?.uid;
      if (uid != null)
        await _db.collection('pengguna').doc(uid).update({
          'tokenFcm': FieldValue.delete(),
        });
      await _fcm.deleteToken();
      await prefs.remove('fcm_token');
      await prefs.remove(_kunciLangganan);

      _tokenSaatIni = null;
      _sudahInisialisasi = false;
      LayananLog.info("Data notifikasi dibersihkan saat keluar akun");
    } catch (e, t) {
      LayananLog.error("Hapus token gagal", e, t);
    }
  }
}
