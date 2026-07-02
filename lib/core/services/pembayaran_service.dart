import 'dart:convert';
import 'package:http/http.dart' as http;

class LayananPembayaran {
  static const String _urlBackend =
      "https://us-central1-proyek-anda.cloudfunctions.net/pembayaran";

  Future<Map<String, dynamic>> buatPesananPembayaran({
    required String idPesanan,
    required int totalBayar,
    required String namaPelanggan,
    required String email,
    required String noHp,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$_urlBackend/buat-tagihan"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "order_id": idPesanan,
          "gross_amount": totalBayar,
          "nama": namaPelanggan,
          "email": email,
          "nohp": noHp,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {"berhasil": true, "data": jsonDecode(res.body)};
      }
      return {
        "berhasil": false,
        "pesan": "Gagal terhubung ke layanan pembayaran",
      };
    } catch (e) {
      return {"berhasil": false, "pesan": e.toString()};
    }
  }

  Future<Map<String, dynamic>> cekStatusPembayaran(String idPesanan) async {
    try {
      final res = await http.get(
        Uri.parse("$_urlBackend/status?id=$idPesanan"),
      );
      if (res.statusCode == 200) {
        return {"berhasil": true, "data": jsonDecode(res.body)};
      }
      return {"berhasil": false, "pesan": "Gagal cek status"};
    } catch (e) {
      return {"berhasil": false, "pesan": e.toString()};
    }
  }
}
