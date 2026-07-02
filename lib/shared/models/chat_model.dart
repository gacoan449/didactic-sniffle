class ChatModel {
  final String pengirim;
  final String penerima;
  final String pesan;
  final String waktu;
  final bool dibaca;
  final String? foto;
  final String? orderId;

  ChatModel({
    required this.pengirim,
    required this.penerima,
    required this.pesan,
    required this.waktu,
    required this.dibaca,

    this.foto,
    this.orderId,
  });
}
