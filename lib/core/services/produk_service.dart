import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/produk_model.dart';

class LayananProduk {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> unggahFoto(XFile file, String produkId) async {
    final ref = _storage.ref().child(
      'produk/$produkId/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  Future<String> buatKodeProduk() async {
    final now = DateTime.now();
    return 'PRD${now.millisecondsSinceEpoch.toString().substring(5)}';
  }

  Future<List<ProdukModel>> ambilSemua({bool hanyaAktif = true}) async {
    Query q = _db.collection('produk');
    if (hanyaAktif) q = q.where('aktif', isEqualTo: true);
    final snap = await q.get();
    return snap.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  Future<List<ProdukModel>> cari(String kataKunci) async {
    final snap = await _db
        .collection('produk')
        .where('aktif', isEqualTo: true)
        .get();
    return snap.docs
        .map((d) => ProdukModel.dariMap(d.data(), d.id))
        .where(
          (p) => p.namaProduk.toLowerCase().contains(kataKunci.toLowerCase()),
        )
        .toList();
  }

  Future<List<ProdukModel>> ambilTerlaris() async {
    final snap = await _db
        .collection('produk')
        .where('aktif', isEqualTo: true)
        .where('terlaris', isEqualTo: true)
        .limit(10)
        .get();
    return snap.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  Future<List<ProdukModel>> ambilProdukBaru() async {
    final snap = await _db
        .collection('produk')
        .where('aktif', isEqualTo: true)
        .where('produkBaru', isEqualTo: true)
        .orderBy('dibuatPada', descending: true)
        .limit(10)
        .get();
    return snap.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  // ✅ METODE ULASAN DAN LAINNYA SUDAH BERADA DI DALAM CLASS
  Future<void> tambahUlasan(String produkId, UlasanProduk ulasan) async {
    await _db
        .collection('produk')
        .doc(produkId)
        .collection('ulasan')
        .add(ulasan.keMap());
    await _db.collection('produk').doc(produkId).update({
      'jumlahUlasan': FieldValue.increment(1),
    });
  }

  Future<List<ProdukModel>> ambilFlashSaleAktif() async {
    final sekarang = DateTime.now();
    final snap = await _db
        .collection('produk')
        .where('flashSale', isEqualTo: true)
        .where('aktif', isEqualTo: true)
        .where('diskonPersen', isGreaterThan: 0)
        .get();
    return snap.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  Future<List<ProdukModel>> ambilProdukSerupa(
    String kategoriId,
    String produkId,
  ) async {
    final snap = await _db
        .collection('produk')
        .where('aktif', isEqualTo: true)
        .limit(6)
        .get();
    return snap.docs
        .where((d) => d.id != produkId)
        .map((d) => ProdukModel.dariMap(d.data(), d.id))
        .toList();
  }

  Future<List<ProdukModel>> ambilMilikSupplier(String supplierId) async {
    final snap = await _db
        .collection('produk')
        .where('supplierId', isEqualTo: supplierId)
        .orderBy('dibuatPada', descending: true)
        .get();
    return snap.docs.map((d) => ProdukModel.dariMap(d.data(), d.id)).toList();
  }

  Future<ProdukModel> simpanProduk(ProdukModel produk) async {
    final ref = _db
        .collection('produk')
        .doc(produk.id.isEmpty ? null : produk.id);
    final data = produk.keMap();
    data['diperbaruiPada'] = FieldValue.serverTimestamp();
    await ref.set(data, SetOptions(merge: true));
    return ProdukModel.dariMap(data, ref.id);
  }

  Future<void> ubahStok(String produkId, int jumlah) async {
    await _db.collection('produk').doc(produkId).update({
      'stok': FieldValue.increment(jumlah),
      'diperbaruiPada': FieldValue.serverTimestamp(),
    });
  }
}
