import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/produk_model.dart';
import '../models/kategori_model.dart';
import '../services/produk_service.dart';

final daftarKategoriProvider = StreamProvider<List<KategoriModel>>((ref) {
  return ProdukService().daftarKategori();
});

final daftarProdukProvider = StreamProvider.family<List<ProdukModel>, String?>((
  ref,
  kategoriId,
) {
  return ProdukService().daftarProduk(kategoriId: kategoriId);
});

final flashSaleProvider = StreamProvider<List<ProdukModel>>((ref) {
  return ProdukService().produkFlashSale();
});

final produkBaruProvider = StreamProvider<List<ProdukModel>>((ref) {
  return ProdukService().produkBaru();
});

final terlarisProvider = StreamProvider<List<ProdukModel>>((ref) {
  return ProdukService().produkTerlaris();
});

final organikProvider = StreamProvider<List<ProdukModel>>((ref) {
  return ProdukService().produkOrganik();
});

final cariProdukProvider = FutureProvider.family<List<ProdukModel>, String>((
  ref,
  kata,
) async {
  if (kata.isEmpty) return [];
  return ProdukService().cariProduk(kata);
});
