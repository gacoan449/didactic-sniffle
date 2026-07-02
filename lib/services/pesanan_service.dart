import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';
import '../config/konstanta.dart';
import 'notifikasi_service.dart';
import 'logger_service.dart';

class LayananPesanan {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LayananNotifikasi _notif = LayananNotifikasi();
  static const _uuid = Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  /// ✅ Buat pesanan SEPENUHNYA DIPROSES DI SERVER
  Future<Map<String, dynamic>> buatPesananDompet({
    required List<Map<String, dynamic>> daftarProduk,
    required int totalBayar,
    String catatan = '',
  }) async {
    if (_uid.isEmpty)
      return {'berhasil': false, 'pesan': 'Harus login terlebih dahulu'};
    try {
      final hasil = await FirebaseFunctions.instance
          .httpsCallable('buatPesananDenganDompet')
          .call({
            'daftarProduk': daftarProduk,
            'totalBayar': totalBayar,
            'catatan': catatan,
          });
      return hasil.data as Map<String, dynamic>;
    } on FirebaseFunctionsException catch (e) {
      LayananLog.error("Buat pesanan gagal", e);
      return {'berhasil': false, 'pesan': e.message ?? 'Terjadi kesalahan'};
    } catch (e) {
      LayananLog.error("Buat pesanan gagal", e);
      return {'berhasil': false, 'pesan': 'Terjadi kesalahan'};
    }
  }

  /// ✅ HANYA UBAH STATUS, SEMUA LOGIKA LAIN DIJALANKAN OLEH CLOUD FUNCTIONS
  Future<bool> perbaruiStatus(String idPesanan, String statusBaru) async {
    if (_uid.isEmpty) return false;
    try {
      await _db.collection(Konstanta.KOLEKSI_PESANAN).doc(idPesanan).update({
        'status': statusBaru,
        'diperbaruiPada': FieldValue.serverTimestamp(),
      });

      await _kirimNotifikasiPerubahan(idPesanan, statusBaru);
      return true;
    } catch (e, t) {
      LayananLog.error("Perbarui status gagal", e, t);
      return false;
    }
  }

  Future<void> _kirimNotifikasiPerubahan(
    String idPesanan,
    String statusBaru,
  ) async {
    final pesan = switch (statusBaru) {
      Konstanta.STATUS_PESANAN_MENUNGGU => (
        "🛒 Pesanan Baru Masuk",
        "Ada pesanan baru yang perlu diproses!",
      ),
      Konstanta.STATUS_PESANAN_DIPROSES => (
        "⚙️ Pesanan Diproses",
        "Pesanan Anda sedang disiapkan",
      ),
      Konstanta.STATUS_PESANAN_DIKIRIM => (
        "🚚 Pesanan Dikirim",
        "Pesanan sudah dalam perjalanan",
      ),
      Konstanta.STATUS_PESANAN_SELESAI => (
        "✅ Pesanan Selesai",
        "Terima kasih telah berbelanja",
      ),
      Konstanta.STATUS_PESANAN_DIBATALKAN => (
        "❌ Pesanan Dibatalkan",
        "Pesanan telah dibatalkan",
      ),
      _ => ("📢 Pembaruan Pesanan", "Status pesanan diperbarui"),
    };

    await _notif.kirimNotifikasiLangsung(pesan.$1, pesan.$2);
  }
}
