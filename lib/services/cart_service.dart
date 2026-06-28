import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  static final List<CartModel> items = [];

  static void add(ProductModel product) {
    int index =
        items.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      items[index].qty++;
    } else {
      items.add(CartModel(product: product));
    }
  }

  static void remove(ProductModel product) {
    items.removeWhere((e) => e.product.id == product.id);
  }

  static void plus(CartModel item) {
    item.qty++;
  }

  static void minus(CartModel item) {
    if (item.qty > 1) {
      item.qty--;
    }
  }

  static int get total {
    int hasil = 0;

    for (var item in items) {
      hasil += item.total;
    }

    return hasil;
  }
}
