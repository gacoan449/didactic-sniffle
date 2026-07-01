import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/cari_provider.dart';
import '../../providers/keranjang_provider.dart';
import '../../providers/produk_provider.dart';
import '../../models/keranjang_item.dart';

class HalamanPencarian extends ConsumerStatefulWidget {
  const HalamanPencarian({super.key});

  @override
  ConsumerState<HalamanPencarian> createState() => _HalamanPencarianState();
}

class _HalamanPencarianState extends ConsumerState<HalamanPencarian> {
  final _cariCtrl = TextEditingController();
  DateTime? _waktuTerakhir;

  String formatUang(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  void _prosesCari(String kata) {
    final sekarang = DateTime.now();
    if (_waktuTerakhir != null &&
        sekarang.difference(_waktuTerakhir!) <
            const Duration(milliseconds: 400))
      return;
    _waktuTerakhir = sekarang;
    ref.read(cariKunciProvider.notifier).state = kata.trim();
  }

  @override
  void dispose() {
    _cariCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = ref.watch(hasilCariProvider);
    final keranjang = ref.read(keranjangProvider.notifier);
    final daftarKeranjang = ref.watch(keranjangProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _cariCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari produk segar...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) {
            setState(() {});
            _prosesCari(v);
          },
        ),
        actions: [
          if (_cariCtrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _cariCtrl.clear();
                setState(() {});
                ref.read(cariKunciProvider.notifier).state = '';
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
      body: hasil.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Gagal memuat data',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(hasilCariProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (data) {
          if (_cariCtrl.text.trim().isEmpty)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Mulai ketik untuk mencari',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    icon: const Icon(Icons.storefront),
                    label: const Text('Lihat Semua Produk'),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.go('/produk');
                    },
                  ),
                ],
              ),
            );

          if (data.isEmpty)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Produk tidak ditemukan',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    icon: const Icon(Icons.storefront),
                    label: const Text('Lihat Semua Produk'),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.go('/produk');
                    },
                  ),
                ],
              ),
            );

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
            itemBuilder: (c, i) {
              final p = data[i];
              final diKeranjang = daftarKeranjang
                  .where((b) => b.produkId == p.id)
                  .fold<int>(0, (s, b) => s + b.jumlah);
              final sisaStok = p.stok - diKeranjang;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: p.gambarUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                            color: Colors.green.shade50,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (c, u, e) => Container(
                            color: Colors.green.shade100,
                            child: const Icon(
                              Icons.grass,
                              size: 40,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.nama,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatUang(p.harga),
                            style: const TextStyle(
                              color: AppTheme.warnaUtama,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                size: 18,
                              ),
                              label: Text(
                                sisaStok <= 0 ? 'Stok Habis' : 'Tambah',
                                style: const TextStyle(fontSize: 13),
                              ),
                              onPressed: sisaStok > 0
                                  ? () async {
                                      await keranjang.tambah(
                                        KeranjangItem(
                                          produkId: p.id,
                                          nama: p.nama,
                                          harga: p.harga,
                                          jumlah: 1,
                                          satuan: p.satuan,
                                          gambarUrl: p.gambarUrl,
                                          stokTersedia: p.stok,
                                        ),
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              sisaStok == 1
                                                  ? 'Terakhir ditambahkan!'
                                                  : 'Ditambahkan ke keranjang',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
