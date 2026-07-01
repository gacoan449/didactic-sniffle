import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produk_model.dart';
import '../models/kategori_model.dart';
import '../models/ulasan_model.dart';
import '../models/tanya_jawab_model.dart';
import 'firebase_service.dart';

enum Urutkan { terbaru, termurah, termahal, terlaris }

class ProdukService {
  final FirebaseFirestore _db = LayananFirebase.db;

  Stream<List<KategoriModel>> daftarKategori() {
    return _db
        .collection('kategori')
        .orderBy('nama')
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => KategoriModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Query _queryDasar({String? kategoriId}) {
    Query query = _db.collection('produk').where('tersedia', isEqualTo: true);
    if (kategoriId != null && kategoriId.isNotEmpty) {
      query = query.where('kategoriId', isEqualTo: kategoriId);
    }
    return query;
  }

  Stream<List<ProdukModel>> daftarProduk({
    String? kategoriId,
    Urutkan urut = Urutkan.terbaru,
  }) {
    Query query = _queryDasar(kategoriId: kategoriId);
    switch (urut) {
      case Urutkan.terbaru:
        query = query.orderBy('dibuatPada', descending: true);
        break;
      case Urutkan.termurah:
        query = query.orderBy('harga', descending: false);
        break;
      case Urutkan.termahal:
        query = query.orderBy('harga', descending: true);
        break;
      case Urutkan.terlaris:
        // Aman meski field belum ada, karena sudah di-set default 0 di model
        query = query.orderBy('jumlahTerjual', descending: true);
        break;
    }
    return query
        .limit(20)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<ProdukModel>> produkFlashSale() {
    return _queryDasar()
        .where('flashSale', isEqualTo: true)
        .orderBy('dibuatPada', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<ProdukModel>> produkBaru() {
    return _queryDasar()
        .where('produkBaru', isEqualTo: true)
        .orderBy('dibuatPada', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<ProdukModel>> produkTerlaris() {
    return _queryDasar()
        .orderBy('jumlahTerjual', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<ProdukModel>> produkOrganik() {
    return _queryDasar()
        .where('organik', isEqualTo: true)
        .orderBy('dibuatPada', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Future<List<ProdukModel>> cariProduk(String kataKunci) async {
    if (kataKunci.trim().isEmpty) return [];
    final kunci = kataKunci.trim().toLowerCase();

    // ✅ Gunakan keyword terindeks agar bisa pencarian mengandung
    final hasil = await _db
        .collection('produk')
        .where('tersedia', isEqualTo: true)
        .where('keyword', arrayContains: kunci)
        .limit(30)
        .get();

    return hasil.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  Stream<List<UlasanModel>> daftarUlasan(String produkId) {
    return _db
        .collection('produk')
        .doc(produkId)
        .collection('ulasan')
        .orderBy('dibuatPada', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => UlasanModel.dariMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<TanyaJawabModel>> daftarTanyaJawab(String produkId) {
    return _db
        .collection('produk')
        .doc(produkId)
        .collection('tanyajawab')
        .orderBy('tglTanya', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => TanyaJawabModel.dariMap(d.data(), d.id))
              .toList(),
        );
  }
}
