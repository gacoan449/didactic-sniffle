class OrderModel {
  String id;
  String tanggal;
  String status;
  String alamat;
  String pembayaran;
  String kurir;
  int total;

  OrderModel({
    required this.id,
    required this.tanggal,
    required this.status,
    required this.alamat,
    required this.pembayaran,
    required this.kurir,
    required this.total,
  });
}
