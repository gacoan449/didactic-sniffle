import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/produk_provider.dart';
import '../../models/produk_model.dart';

class HalamanDaftarProduk extends ConsumerWidget {
  const HalamanDaftarProduk({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daftarAsync = ref.watch(daftarProdukProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produk Hasil Tani')),
      body: daftarAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (daftar) {
          if (daftar.isEmpty) return const Center(child: Text('Belum ada produk tersedia'));
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10,
            ),
            itemCount: daftar.length,
            itemBuilder: (c, i) => KartuProduk(data: daftar[i]),
          );
        },
      ),
    );
  }
}

class KartuProduk extends StatelessWidget {
  final ProdukModel data;
  const KartuProduk({super.key, required this.data});

  String formatHarga(double angka) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(angka);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {}, // Sementara dikosongkan sampai halaman detail dibuat
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: data.gambarUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: data.gambarUrl, fit: BoxFit.cover, width: double.infinity,
                      placeholder: (c, u) => Container(color: Colors.green.shade50, child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                      errorWidget: (c, u, e) => Container(color: Colors.green.shade100, child: const Icon(Icons.grass, size: 60, color: Colors.green)),
                    )
                  : Container(color: Colors.green.shade100, child: const Icon(Icons.grass, size: 60, color: Colors.green)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(formatHarga(data.harga), style: const TextStyle(color: AppTheme.warnaUtama, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    data.stok > 0 ? 'Stok: ${data.stok} ${data.satuan}' : 'HABIS',
                    style: TextStyle(fontSize: 12, color: data.stok > 0 ? Colors.grey : Colors.red, fontWeight: data.stok > 0 ? FontWeight.normal : FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
