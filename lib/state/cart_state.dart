import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';

final cartStateProvider = StateNotifierProvider<CartStateNotifier, List<CartModel>>((ref) {
  return CartStateNotifier();
});

class CartStateNotifier extends StateNotifier<List<CartModel>> {
  CartStateNotifier() : super([]);

  void tambah(CartModel barang) {
    final daftarBaru = List<CartModel>.from(state);
    CartModel.tambahAtauUpdate(daftarBaru, barang);
    state = daftarBaru;
  }

  void hapus(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void ubahJumlah(String id, int jumlahBaru) {
    state = state.map((item) {
      if (item.id == id) {
        return CartModel(
          id: item.id,
          namaProduk: item.namaProduk,
          gambar: item.gambar,
          harga: item.harga,
          jumlah: jumlahBaru,
        );
      }
      return item;
    }).toList();
  }

  int get jumlah => state.length;
  double get totalHarga => state.fold(0, (total, item) => total + (item.harga * item.jumlah));
}
