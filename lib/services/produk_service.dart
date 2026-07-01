import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/produk_repo.dart';
import '../models/produk_model.dart';

class ProdukService {
  final ProdukRepository repo;
  ProdukService(this.repo);

  Stream<List<ProdukModel>> ambilSemuaProduk() => repo.ambilSemua();
  Future<List<ProdukModel>> cariProduk(String kata) => repo.cari(kata);
  Future<List<ProdukModel>> ambilKategori(String kat) => repo.ambilKategori(kat);
}

final produkServiceProvider = Provider<ProdukService>((ref) {
  return ProdukService(ref.watch(produkRepoProvider));
});
