import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/produk_model.dart';
import '../models/wishlist_model.dart';
import '../services/wishlist_service.dart';
import '../providers/wishlist_provider.dart';

class KartuProduk extends ConsumerWidget {
  final ProdukModel produk;
  const KartuProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daftarFavorit = ref.watch(daftarWishlistProvider).value ?? [];
    final disukai = daftarFavorit.any((e) => e.produkId == produk.id);
    final formatHarga = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: produk.gambarUrl, fit: BoxFit.cover,
                    placeholder: (c,u) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (c,u,e) => const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: InkWell(
                      onTap: () async {
                        final data = WishlistModel(
                          id: '', produkId: produk.id, namaProduk: produk.nama,
                          gambar: produk.gambarUrl, harga: produk.harga, ditambahkanPada: DateTime.now()
                        );
                        await WishlistService().ubahStatus(data);
                        ref.invalidate(daftarWishlistProvider);
                      },
                      child: CircleAvatar(
                        radius: 18, backgroundColor: Colors.white70,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            disukai ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(disukai),
                            color: disukai ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produk.nama, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text(formatHarga.format(produk.harga), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.warnaUtama)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
