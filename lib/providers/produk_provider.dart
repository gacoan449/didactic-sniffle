import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/produk_model.dart';
import '../services/produk_service.dart';

final daftarProdukProvider = StreamProvider<List<ProdukModel>>((ref) {
  return ProdukService().ambilSemua();
});
