import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/pesanan_provider.dart';
import '../../models/pesanan_model.dart';
import 'detail_pesanan.dart';

class HalamanRiwayatPesanan extends ConsumerWidget {
  const HalamanRiwayatPesanan({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final daftar = ref.watch(daftarPesananProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: daftar.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty)
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada pesanan',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (c, i) {
              final p = data[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.push('/detail-pesanan', extra: p),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.noPesanan,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                teksStatus(p.status),
                                style: TextStyle(
                                  color: warnaStatus(p.status),
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: warnaStatus(
                                p.status,
                              ).withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatTanggal(p.dibuatPada),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${p.barang.length} Barang'),
                            Text(
                              formatUang(p.totalBayar),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.warnaUtama,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
