class OrderModel {
  final String id;
  final String userId;
  final List<String> produk;
  final int total;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.produk,
    required this.total,
    required this.status,
  });
}
