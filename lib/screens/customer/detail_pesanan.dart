import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../models/pesanan_model.dart';

class HalamanDetailPesanan extends StatelessWidget {
  final PesananModel pesanan;
  const HalamanDetailPesanan({super.key, required this.pesanan});

  String formatUang(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  String formatTanggal(DateTime tgl) {
    return DateFormat('dd MMM yyyy, HH:mm').format(tgl);
  }

  Color warnaStatus(StatusPesanan s) {
    switch (s) {
      case StatusPesanan.menunggu:
        return Colors.orange;
      case StatusPesanan.dikonfirmasi:
        return Colors.blue;
      case StatusPesanan.dikirim:
        return Colors.purple;
      case StatusPesanan.selesai:
        return Colors.green;
      case StatusPesanan.dibatalkan:
        return Colors.red;
    }
  }

  String teksStatus(StatusPesanan s) {
    switch (s) {
      case StatusPesanan.menunggu:
        return 'Menunggu Konfirmasi';
      case StatusPesanan.dikonfirmasi:
        return 'Dikonfirmasi';
      case StatusPesanan.dikirim:
        return 'Sedang Dikirim';
      case StatusPesanan.selesai:
        return 'Selesai';
      case StatusPesanan.dibatalkan:
        return 'Dibatalkan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // No Pesanan & Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pesanan.noPesanan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Chip(
                        label: Text(
                          teksStatus(pesanan.status),
                          style: TextStyle(color: warnaStatus(pesanan.status)),
                        ),
                        backgroundColor: warnaStatus(
                          pesanan.status,
                        ).withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dibuat tanggal: ${formatTanggal(pesanan.dibuatPada)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Alamat Pengiriman
          const Text(
            'Alamat Pengiriman',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pesanan.alamat.namaPenerima} - ${pesanan.alamat.noHp}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(pesanan.alamat.alamatLengkap()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Barang
          const Text(
            'Daftar Barang',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: pesanan.barang
                    .map(
                      (b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: b.gambarUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (c, u) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.green.shade50,
                                ),
                                errorWidget: (c, u, e) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.green.shade100,
                                  child: const Icon(
                                    Icons.grass,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${formatUang(b.harga)} x ${b.jumlah} ${b.satuan}',
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatUang(b.totalHarga),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ringkasan Pembayaran
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Barang'),
                      Text(formatUang(pesanan.totalBarang)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ongkos Kirim'),
                      Text(formatUang(pesanan.ongkir)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatUang(pesanan.totalBayar),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.warnaUtama,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Metode Pembayaran'),
                      Text(pesanan.metodeBayar),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
