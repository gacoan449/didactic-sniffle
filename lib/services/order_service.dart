import '../models/order_model.dart';

class OrderService {
  static List<OrderModel> orders = [];

  static void tambah(OrderModel order) {
    orders.add(order);
  }
}
