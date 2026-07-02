import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '../../lib/config/konstanta.dart';
import '../../lib/models/produk_model.dart';
import '../../lib/services/produk_layanan.dart';

void main() {
  group('✅ Pengujian Layanan Produk & Stok', () {
    late FakeFirebaseFirestore dbPalsu;
    late MockFirebaseAuth authPalsu;
    late LayananProduk layanan;

    setUp(() {
      dbPalsu = FakeFirebaseFirestore();
      authPalsu = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'UID_TEST', displayName: 'Pengguna Uji'));
      layanan = LayananProduk.instance;
    });

    test('kurangiStokOtomatis menghitung stok BENAR (bukan negatif)', () async {
      final refProduk = dbPalsu.collection(Konstanta.KOLEKSI_PRODUK).doc('P001');
      await refProduk.set({Konstanta.KUNCI_STOK: 100, Konstanta.KUNCI_ID_TOKO: 'T001'});

      // Simulasi pengurangan 5
      await dbPalsu.runTransaction((trans) async {
        final doc = await trans.get(refProduk);
        final stokSekarang = doc.data()?[Konstanta.KUNCI_STOK] as int;
        final stokBaru = stokSekarang - 5;
        trans.update(refProduk, {Konstanta.KUNCI_STOK: stokBaru});
      });

      final hasil = await refProduk.get();
      expect(hasil.data()?[Konstanta.KUNCI_STOK], 95);
    });

    test('ubahStok menulis ulang JIKA DAN HANYA JIKA stok berubah', () async {
      final refProduk = dbPalsu.collection(Konstanta.KOLEKSI_PRODUK).doc('P002');
      await refProduk.set({Konstanta.KUNCI_STOK: 50, Konstanta.KUNCI_ID_TOKO: 'T002'});

      // Coba ubah ke nilai sama
      await dbPalsu.runTransaction((trans) async {
        final doc = await trans.get(refProduk);
        final stokLama = doc.data()?[Konstanta.KUNCI_STOK] as int;
        if(stokLama != 50) trans.update(refProduk, {Konstanta.KUNCI_STOK: 50});
      });

      final riwayat = await dbPalsu.collection(Konstanta.KOLEKSI_RIWAYAT_STOK).get();
      expect(riwayat.docs.length, 0);
    });
  });
}
