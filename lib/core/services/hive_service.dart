import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaksi_kasir_model.dart';
import '../models/shift_kasir_model.dart';

class LayananHive {
  static const String namaBoxTransaksi = 'transaksi_offline';
  static const String namaBoxShift = 'shift_kasir';
  static const String namaBoxProduk = 'daftar_produk';

  static Future<void> inisialisasi() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    // Daftarkan semua Adapter Hive
    Hive.registerAdapter(TransaksiKasirModelAdapter());
    Hive.registerAdapter(ItemTransaksiAdapter());
    Hive.registerAdapter(ShiftKasirModelAdapter());

    // Buka semua Box yang dibutuhkan
    await Hive.openBox<TransaksiKasirModel>(namaBoxTransaksi);
    await Hive.openBox<ShiftKasirModel>(namaBoxShift);
    await Hive.openBox(namaBoxProduk);
  }

  // Simpan transaksi saat offline
  static Future<void> simpanTransaksiOffline(
    TransaksiKasirModel transaksi,
  ) async {
    final box = Hive.box<TransaksiKasirModel>(namaBoxTransaksi);
    await box.put(transaksi.id, transaksi);
  }

  // Ambil semua transaksi yang belum tersinkron
  static List<TransaksiKasirModel> ambilTransaksiOffline() {
    final box = Hive.box<TransaksiKasirModel>(namaBoxTransaksi);
    return box.values.toList();
  }

  // Hapus transaksi setelah berhasil tersinkron ke server
  static Future<void> hapusTransaksiOffline(String id) async {
    final box = Hive.box<TransaksiKasirModel>(namaBoxTransaksi);
    await box.delete(id);
  }

  // Tutup semua koneksi Hive
  static Future<void> tutup() async {
    await Hive.close();
  }
}
