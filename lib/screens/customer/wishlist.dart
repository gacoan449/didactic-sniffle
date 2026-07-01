import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/keranjang_provider.dart';
import '../../services/wishlist_service.dart';
import '../../models/wishlist_model.dart';
import '../../models/produk_model.dart';

class HalamanWishlist extends ConsumerWidget {
  const HalamanWishlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(daftarWishlistProvider);
    final formatHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Produk Favorit')),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Gagal memuat: $e')),
        data: (daftar) {
          if (daftar.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada produk favorit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/beranda'),
                    child: const Text('Mulai Belanja Sekarang'),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: daftar.length,
            itemBuilder: (c, i) =>
                _KartuProduk(item: daftar[i], formatHarga: formatHarga),
          );
        },
      ),
    );
  }
}

class _KartuProduk extends ConsumerWidget {
  final WishlistModel item;
  final NumberFormat formatHarga;
  const _KartuProduk({required this.item, required this.formatHarga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.gambar,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (c, u, e) =>
                      const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () async {
                      await WishlistService().hapus(item.produkId);
                      ref.invalidate(daftarWishlistProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dihapus dari favorit'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white70,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: Icon(
                          Icons.favorite,
                          key: ValueKey('suka'),
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaProduk,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  formatHarga.format(item.harga),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warnaUtama,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: const Text(
                      '+ Keranjang',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      ref
                          .read(keranjangProvider.notifier)
                          .tambah(
                            ProdukModel(
                              id: item.produkId,
                              nama: item.namaProduk,
                              gambarUrl: item.gambar,
                              harga: item.harga,
                              stok: 999,
                              deskripsi: '',
                              kategori: '',
                              satuan: 'buah',
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ditambahkan ke keranjang'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
