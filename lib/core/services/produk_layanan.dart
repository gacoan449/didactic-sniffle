import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/konstanta.dart';
import '../models/produk_model.dart';
import 'logger_service.dart';

class LayananProduk {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser?.uid ?? '';
  String get namaPengguna =>
      _auth.currentUser?.displayName ?? 'Pengguna Tidak Dikenal';

  /// ✅ Singleton yang benar-benar aman
  factory LayananProduk() => instance;
  static final LayananProduk instance = LayananProduk._internal();
  LayananProduk._internal();

  Future<String> tambahProduk(
    Produk produk, {
    String? deviceID,
    String? ipAddress,
    String versiAplikasi = '1.0.0',
  }) async {
    if (uid.isEmpty) throw Exception("Belum login");
    if (!produk.apakahValid())
      throw Exception("Data produk tidak lengkap/tidak valid");

    final refProduk = _db.collection(Konstanta.KOLEKSI_PRODUK).doc();
    final produkBaru = produk.copyWith(
      id: refProduk.id,
      dibuatOleh: uid,
      diubahOleh: uid,
      deviceID: deviceID,
      ipAddress: ipAddress,
      versiAplikasi: versiAplikasi,
    );

    await _db.runTransaction((transaksi) async {
      transaksi.set(refProduk, produkBaru.toMapBuatBaru());
      final refRiwayat = _db.collection(Konstanta.KOLEKSI_RIWAYAT_STOK).doc();
      transaksi.set(
        refRiwayat,
        RiwayatStok(
          id: refRiwayat.id,
          idProduk: refProduk.id,
          jumlahSebelum: 0,
          jumlahSesudah: produkBaru.stok,
          perubahan: produkBaru.stok,
          jenis: JenisPerubahanStok.tambah,
          alasan: "Stok awal pendaftaran produk",
          dilakukanOleh: uid,
          dilakukanOlehNama: namaPengguna,
          deviceID: deviceID,
          ipAddress: ipAddress,
          versiAplikasi: versiAplikasi,
          waktu: DateTime.now(),
        ).toMap(),
      );
    });

    LayananLog.info("Produk berhasil ditambahkan: ${refProduk.id}");
    return refProduk.id;
  }

  /// ✅ Perbaiki logika: ambil stok lama, hitung jumlah baru, cek perubahan
  Future<void> ubahStok({
    required String idProduk,
    required int jumlahBaru,
    required JenisPerubahanStok jenis,
    required String alasan,
    String? deviceID,
    String? ipAddress,
    String versiAplikasi = '1.0.0',
  }) async {
    if (uid.isEmpty) throw Exception("Belum login");
    if (jumlahBaru < 0) throw Exception("Stok tidak boleh bernilai negatif");

    await _db.runTransaction((transaksi) async {
      final refProduk = _db.collection(Konstanta.KOLEKSI_PRODUK).doc(idProduk);
      final doc = await transaksi.get(refProduk);
      if (!doc.exists) throw Exception("Produk tidak ditemukan");

      final dataLama = Produk.fromMap(doc.id, doc.data()!);
      final jumlahSebelum = dataLama.stok;

      /// ✅ Langsung keluar jika tidak ada perubahan
      if (jumlahSebelum == jumlahBaru) return;

      transaksi.update(refProduk, {
        Konstanta.KUNCI_STOK: jumlahBaru,
        Konstanta.KUNCI_DIUBAH_OLEH: uid,
        Konstanta.KUNCI_DIPERBARUI_PADA: FieldValue.serverTimestamp(),
        Konstanta.KUNCI_DEVICE_ID: deviceID,
        Konstanta.KUNCI_IP_ADDRESS: ipAddress,
        Konstanta.KUNCI_VERSI_APLIKASI: versiAplikasi,
      });

      /// ✅ Riwayat dicatat DALAM transaksi, tidak terpisah
      final refRiwayat = _db.collection(Konstanta.KOLEKSI_RIWAYAT_STOK).doc();
      transaksi.set(
        refRiwayat,
        RiwayatStok(
          id: refRiwayat.id,
          idProduk: idProduk,
          jumlahSebelum: jumlahSebelum,
          jumlahSesudah: jumlahBaru,
          perubahan: jumlahBaru - jumlahSebelum,
          jenis: jenis,
          alasan: alasan,
          dilakukanOleh: uid,
          dilakukanOlehNama: namaPengguna,
          deviceID: deviceID,
          ipAddress: ipAddress,
          versiAplikasi: versiAplikasi,
          waktu: DateTime.now(),
        ).toMap(),
      );
    });
  }

  /// ✅ Perbaiki bug besar: kurangi dari stok lama, bukan set negatif
  Future<void> kurangiStokOtomatis(
    String idProduk,
    int jumlahTerjual, {
    String? deviceID,
    String? ipAddress,
    String versiAplikasi = '1.0.0',
  }) async {
    await _db.runTransaction((transaksi) async {
      final refProduk = _db.collection(Konstanta.KOLEKSI_PRODUK).doc(idProduk);
      final doc = await transaksi.get(refProduk);
      if (!doc.exists)
        throw Exception(
          "Produk $idProduk tidak ditemukan saat pengurangan stok",
        );

      final stokSekarang = (doc.data()?[Konstanta.KUNCI_STOK] ?? 0) as int;
      if (stokSekarang < jumlahTerjual)
        throw Exception("Stok tidak cukup untuk produk $idProduk");

      final stokBaru = stokSekarang - jumlahTerjual;
      transaksi.update(refProduk, {Konstanta.KUNCI_STOK: stokBaru});

      final refRiwayat = _db.collection(Konstanta.KOLEKSI_RIWAYAT_STOK).doc();
      transaksi.set(
        refRiwayat,
        RiwayatStok(
          id: refRiwayat.id,
          idProduk: idProduk,
          jumlahSebelum: stokSekarang,
          jumlahSesudah: stokBaru,
          perubahan: -jumlahTerjual,
          jenis: JenisPerubahanStok.terjual,
          alasan: "Terjual dalam transaksi",
          dilakukanOleh: uid,
          dilakukanOlehNama: 'Sistem',
          deviceID: deviceID,
          ipAddress: ipAddress,
          versiAplikasi: versiAplikasi,
          waktu: DateTime.now(),
        ).toMap(),
      );
    });
  }

  Future<void> perbaruiProduk(
    Produk produk, {
    String? deviceID,
    String? ipAddress,
    String versiAplikasi = '1.0.0',
  }) async {
    if (uid.isEmpty) throw Exception("Belum login");
    if (!produk.apakahValid()) throw Exception("Data produk tidak valid");

    await _db.collection(Konstanta.KOLEKSI_PRODUK).doc(produk.id).update({
      ...produk.toMapUpdate(),
      Konstanta.KUNCI_DIUBAH_OLEH: uid,
      Konstanta.KUNCI_DEVICE_ID: deviceID,
      Konstanta.KUNCI_IP_ADDRESS: ipAddress,
      Konstanta.KUNCI_VERSI_APLIKASI: versiAplikasi,
    });
  }

  /// ✅ Siap untuk Paginasi, tidak batasi keras 100 saja
  Query<Produk> queryProduk({bool hanyaAktif = true}) {
    Query query = _db.collection(Konstanta.KOLEKSI_PRODUK);
    if (hanyaAktif)
      query = query.where(Konstanta.KUNCI_STATUS_AKTIF, isEqualTo: true);
    return query
        .orderBy(Konstanta.KUNCI_DIBUAT_PADA, descending: true)
        .withConverter<Produk>(
          fromFirestore: (s, _) => Produk.fromMap(s.id, s.data()!),
          toFirestore: (p, _) => p.toMapUmum(),
        );
  }

  Stream<List<Produk>> streamProdukToko(String idToko) {
    return _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .where(Konstanta.KUNCI_ID_TOKO, isEqualTo: idToko)
        .orderBy(Konstanta.KUNCI_DIBUAT_PADA, descending: true)
        .withConverter<Produk>(
          fromFirestore: (s, _) => Produk.fromMap(s.id, s.data()!),
          toFirestore: (p, _) => p.toMapUmum(),
        )
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  Stream<List<RiwayatStok>> streamRiwayatStok(String idProduk) {
    return _db
        .collection(Konstanta.KOLEKSI_RIWAYAT_STOK)
        .where(Konstanta.KUNCI_ID_PRODUK, isEqualTo: idProduk)
        .orderBy('waktu', descending: true)
        .limit(50)
        .withConverter<RiwayatStok>(
          fromFirestore: (s, _) => RiwayatStok.fromMap(s.id, s.data()!),
          toFirestore: (r, _) => r.toMap(),
        )
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  Future<Produk?> ambilProduk(String idProduk) async {
    final doc = await _db
        .collection(Konstanta.KOLEKSI_PRODUK)
        .doc(idProduk)
        .get();
    return doc.exists ? Produk.fromMap(doc.id, doc.data()!) : null;
  }
}
